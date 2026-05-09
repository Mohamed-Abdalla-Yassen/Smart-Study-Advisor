// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  // ─── Change to your Django server IP ───────────────────────
  // static const String baseUrl = 'http://192.168.1.15:8000/playground/recommend/noAi/'; // My PC IP "firefox"
  static const String baseUrl = 'http://127.0.0.1:8000'; // Linux desktop
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://YOUR_PC_IP:8000'; // Real device

  static const Duration _timeout = Duration(seconds: 15);

  // ── Logic Recommendations (GET) ────────────────────────────
  // Matches: /api/recommend?difficulty=&prereq=&pref=&year=&dept=
  static Future<List<CourseResult>> getLogicRecommendations(
    StudentQuery query,
  ) async {
    final uri = Uri.parse('$baseUrl/playground/recommend/noAi/')
        .replace(queryParameters: query.toQueryParams());

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'error') {
        throw ApiException(message: data['message'], statusCode: 500);
      }
      final list = data['recommendations'] as List;
      return list.map((e) => CourseResult(name: e.toString())).toList();
    } else {
      throw ApiException(
        message: 'Server error (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
  }

  // ── Logic Recommendations (POST) ───────────────────────────
  // Matches: /api/recommend-post  (get_recommendations_post view)
  static Future<List<CourseResult>> getLogicRecommendationsPost(
    StudentQuery query,
  ) async {
    final uri = Uri.parse('$baseUrl/api/recommend-post');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(query.toJson()),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'error') {
        throw ApiException(message: data['message'], statusCode: 500);
      }
      final list = data['recommendations'] as List;
      return list.map((e) => CourseResult(name: e.toString())).toList();
    } else {
      throw ApiException(
        message: 'Server error (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
  }

  // ── AI Recommendations (POST) ──────────────────────────────
  // Matches: /api/recommend/ai/  (get_AI_recommendations view)
  static Future<List<CourseResult>> getAiRecommendations(
    StudentQuery query,
  ) async {
    final uri = Uri.parse('$baseUrl/playground/recommend/ai/');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(query.toJson()),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'error') {
        throw ApiException(message: data['message'], statusCode: 500);
      }
      final list = data['recommendations'] as List;
      return list.map((e) => CourseResult(name: e.toString())).toList();
    } else {
      throw ApiException(
        message: 'Server error (${response.statusCode})',
        statusCode: response.statusCode,
      );
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

