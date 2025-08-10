import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Update this with your Railway URL
  static const String baseUrl =
      'https://children-cybersecurity-backend-production.up.railway.app/api';

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = endpoint.startsWith('/')
          ? '$baseUrl$endpoint'
          : '$baseUrl/$endpoint';
      print('🌐 GET request to: $url');

      final response = await http.get(Uri.parse(url), headers: _headers);

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ApiException(
          'Failed to load data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('❌ API GET error: $e');
      throw ApiException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      print('🔍 Making request to: $baseUrl$endpoint'); // ADD THIS
      print('🔍 Request data: $data');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );

      print('🔍 Response status: ${response.statusCode}'); // ADD THIS
      print('🔍 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw ApiException(
          'Request failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('🔍 Detailed error: $e');
      throw ApiException('Network error: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
