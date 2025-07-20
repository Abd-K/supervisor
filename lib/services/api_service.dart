import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supervisor/models/orphan.dart';

class ApiService {
  static const String _baseUrl = 'https://f91934e7fe45.ngrok-free.app/api';
  static const String _apiKey = 'orphan_hq_demo_2025';

  Future<http.Response> createOrphan(Map<String, dynamic> orphanData) async {
    final url = Uri.parse('$_baseUrl/orphans');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': _apiKey,
        'ngrok-skip-browser-warning': 'true',
        'User-Agent': 'Flutter-App',
      },
      body: jsonEncode(orphanData),
    );
    return response;
  }
} 