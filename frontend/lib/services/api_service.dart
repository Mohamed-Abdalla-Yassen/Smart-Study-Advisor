// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  // ─── Change this to your Django server IP when running ───
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // iOS simulator
  // static const String baseUrl = 'http://YOUR_PC_IP:8000/api'; // Real device

  static const Duration _timeout = Duration(seconds: 15);

  // ── Headers ────────────────────────────────────────────────
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ── AI-Based Recommendation (Gemini via Django) ────────────
  static Future<List<CourseRecommendation>> getAIRecommendations(
    StudentProfile profile,
  ) async {
    final uri = Uri.parse('$baseUrl/recommend/ai/');
    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(profile.toJson()))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['recommendations'] as List;
      return list.map((e) => CourseRecommendation.fromJson(e)).toList();
    } else {
      throw ApiException(
        message: 'AI advisor failed (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
  }

  // ── Logic-Based Recommendation (Prolog via Django) ─────────
  static Future<List<CourseRecommendation>> getLogicRecommendations(
    StudentProfile profile,
  ) async {
    final uri = Uri.parse('$baseUrl/recommend/logic/');
    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(profile.toJson()))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['recommendations'] as List;
      return list.map((e) => CourseRecommendation.fromJson(e)).toList();
    } else {
      throw ApiException(
        message: 'Logic advisor failed (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
  }

  // ── Health Check ───────────────────────────────────────────
  static Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$baseUrl/health/');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  const ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}