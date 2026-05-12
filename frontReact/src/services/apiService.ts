// apiService.ts
// lib/services/apiService.ts
import { StudentForm, CourseResult, CourseMapper, studentFormToJson } from '../models/models';

// const BASE_URL = 'http://192.168.1.28:8000/api'; // your PC's IP
const BASE_URL = 'http://127.0.0.1:8000/api';
// const BASE_URL = 'http://10.0.2.2:8000/api'; // Android emulator
// const BASE_URL = 'http://YOUR_PC_IP:8000/api'; // Real device

const TIMEOUT_MS = 15000;

export class ApiException extends Error {
  statusCode: number;

  constructor(message: string, statusCode: number) {
    super(message);
    this.name = 'ApiException';
    this.statusCode = statusCode;
  }
}

/**
 * Replace bare NaN (Python pandas artifact) with null.
 * NaN is valid in Python/pandas but NOT in JSON spec.
 * JSON.parse throws SyntaxError when it encounters bare NaN.
 * Note: JS uses `/g` flag for global replacement equivalent to Dart's replaceAll.
 */
const sanitizeNaN = (raw: string): string => {
  return raw
    .replace(/:\s*NaN/g, ': null')   // {"key": NaN}
    .replace(/,\s*NaN/g, ', null')   // [1, NaN, 2]
    .replace(/\[\s*NaN/g, '[null')   // [NaN, ...]
    .replace(/NaN\s*\]/g, 'null]')   // [..., NaN]
    .replace(/NaN\s*,/g, 'null,');   // NaN, ...
};

/**
 * Fetch wrapper to support request timeouts via AbortController
 */
const fetchWithTimeout = async (url: string, options: RequestInit): Promise<Response> => {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), TIMEOUT_MS);

  try {
    const response = await fetch(url, {
      ...options,
      signal: controller.signal,
    });
    clearTimeout(timeoutId);
    return response;
  } catch (error: any) {
    clearTimeout(timeoutId);
    if (error.name === 'AbortError') {
      throw new ApiException('Request timed out', 408);
    }
    throw error;
  }
};

/**
 * Shared response parser
 */
const parseResponse = async (response: Response): Promise<CourseResult[]> => {
  if (!response.ok) {
    throw new ApiException(`Server error (${response.status})`, response.status);
  }

  const rawText = await response.text();
  
  // Must sanitize BEFORE JSON.parse — bare NaN breaks the parser
  const sanitized = sanitizeNaN(rawText);

  // Debug log (remove once working)
  console.log('═══ API RESPONSE (sanitized, first 600 chars) ═══');
  console.log(sanitized.substring(0, Math.min(sanitized.length, 600)));
  console.log('═════════════════════════════════════════════════');

  let data: any;
  try {
    data = JSON.parse(sanitized);
  } catch (e: any) {
    throw new ApiException(
      `JSON parse failed after NaN sanitization: ${e.message}\n` +
      `Raw body (first 300 chars): ${rawText.substring(0, Math.min(rawText.length, 300))}`,
      200
    );
  }

  if (data.status === 'error') {
    throw new ApiException(data.message?.toString() ?? 'Unknown error', 500);
  }

  // ── New shape: { status, total_found, data: [...] } ───────
  if (data.data && Array.isArray(data.data)) {
    const results = data.data.map((e: any) => CourseMapper.fromJson(e));
    // Sort descending by match % (backend usually does this, but be safe)
    results.sort((a: CourseResult, b: CourseResult) => b.matchPercentage - a.matchPercentage);
    return results;
  }

  // ── Legacy fallback: { recommendations: [...] } ───────────
  if (data.recommendations && Array.isArray(data.recommendations)) {
    return data.recommendations.map((e: any): CourseResult => ({
      name: String(e),
      matchPercentage: 0,
      matchTier: '',
      difficulty: '',
      prerequisite: null,
      preference: '',
      yearOfStudy: 0,
      department: '',
    }));
  }

  throw new ApiException(
    `Unexpected response format. Top-level keys: ${Object.keys(data).join(', ')}`,
    200
  );
};

export const ApiService = {
  // ── Logic Recommendations ─────────────────────────────────────
  getLogicRecommendations: async (form: StudentForm): Promise<CourseResult[]> => {
    const response = await fetchWithTimeout(`${BASE_URL}/recommend/`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      // Note: We use the transformer from the previous file because Set cannot be JSON stringified directly
      body: JSON.stringify(studentFormToJson(form)),
    });
    return parseResponse(response);
  },

  // ── AI Recommendations ────────────────────────────────────────
  getAiRecommendations: async (form: StudentForm): Promise<CourseResult[]> => {
    const response = await fetchWithTimeout(`${BASE_URL}/recommend/ai/`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(studentFormToJson(form)),
    });
    return parseResponse(response);
  },
};