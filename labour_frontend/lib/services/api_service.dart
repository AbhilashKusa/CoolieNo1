import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Variables used in this file
// baseUrl - Base URL for the API endpoints
// storage - Instance of FlutterSecureStorage for storing secure data
// url - URL for the API endpoint
// body - JSON-encoded request body
// response - HTTP response from the API
// responseBody - Decoded JSON response body
// name - User's name for registration
// mobile - User's mobile number for registration
// email - User's email for registration and login
// password - User's password for registration and login
class ApiService {
  final String baseUrl = "http://localhost:3000";
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  /// Register method
  Future<void> register(String name, String mobile, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode({
      'name': name,
      'mobile': mobile,
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    final responseBody = jsonDecode(response.body);
    
    if (response.statusCode == 201) {
      // Store token and user ID
      await storage.write(key: 'authToken', value: responseBody['token']);
      await storage.write(key: 'userId', value: responseBody['userId'].toString());
      return;
    }
    
    throw Exception(responseBody['error'] ?? 'Registration failed');
  }

  /// Login method
  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}