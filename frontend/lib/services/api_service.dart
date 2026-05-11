// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/playground';
  // static const String baseUrl = 'http://10.0.2.2:8000/playground'; // Android emulator
  // static const String baseUrl = 'http://YOUR_PC_IP:8000/playground'; // Real device

  static const Duration _timeout = Duration(seconds: 15);

  // ── Logic Recommendations ─────────────────────────────────────
  static Future<List<CourseResult>> getLogicRecommendations(
    StudentForm form,
  ) async {
    final uri = Uri.parse('$baseUrl/recommend/complex/noAi/');
    final response = await http
        .post(uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(form.toJson()))
        .timeout(_timeout);
    return _parseResponse(response);
  }

  // ── AI Recommendations ────────────────────────────────────────
  static Future<List<CourseResult>> getAiRecommendations(
    StudentForm form,
  ) async {
    final uri = Uri.parse('$baseUrl/recommend/ai/');
    final response = await http
        .post(uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(form.toJson()))
        .timeout(_timeout);
    return _parseResponse(response);
  }

  // ── Replace bare NaN (Python pandas artifact) with null ──────
  // NaN is valid in Python/pandas but NOT in JSON spec.
  // jsonDecode throws FormatException when it encounters bare NaN.
  static String _sanitizeNaN(String raw) {
    return raw
        .replaceAll(RegExp(r':\s*NaN'), ': null')   // {"key": NaN}
        .replaceAll(RegExp(r',\s*NaN'), ', null')   // [1, NaN, 2]
        .replaceAll(RegExp(r'\[\s*NaN'), '[null')   // [NaN, ...]
        .replaceAll(RegExp(r'NaN\s*]'), 'null]')    // [..., NaN]
        .replaceAll(RegExp(r'NaN\s*,'), 'null,');   // NaN, ...
  }

  // ── Shared response parser ────────────────────────────────────
  static List<CourseResult> _parseResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException(
        message: 'Server error (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    // Must sanitize BEFORE jsonDecode — bare NaN breaks the parser
    final sanitized = _sanitizeNaN(response.body);

    // Debug log (remove once working)
    debugPrint('═══ API RESPONSE (sanitized, first 600 chars) ═══');
    debugPrint(sanitized.substring(0, sanitized.length.clamp(0, 600)));
    debugPrint('═════════════════════════════════════════════════');

    final Map<String, dynamic> data;
    try {
      data = jsonDecode(sanitized) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        message: 'JSON parse failed after NaN sanitization: $e\n'
            'Raw body (first 300 chars): '
            '${response.body.substring(0, response.body.length.clamp(0, 300))}',
        statusCode: 200,
      );
    }

    if (data['status'] == 'error') {
      throw ApiException(
        message: data['message']?.toString() ?? 'Unknown error',
        statusCode: 500,
      );
    }

    // ── New shape: { status, total_found, data: [...] } ───────
    if (data.containsKey('data') && data['data'] is List) {
      final list = data['data'] as List;
      final results = list
          .map((e) => CourseResult.fromJson(e as Map<String, dynamic>))
          .toList();
      // Sort descending by match % (backend usually does this, but be safe)
      results.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
      return results;
    }

    // ── Legacy fallback: { recommendations: [...] } ───────────
    if (data.containsKey('recommendations') && data['recommendations'] is List) {
      final list = data['recommendations'] as List;
      return list
          .map((e) => CourseResult(
                name: e.toString(),
                matchPercentage: 0,
                matchTier: '',
                difficulty: '',
                preference: '',
                yearOfStudy: 0,
                department: '',
              ))
          .toList();
    }

    throw ApiException(
      message: 'Unexpected response format. Top-level keys: ${data.keys.toList()}',
      statusCode: 200,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  const ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}