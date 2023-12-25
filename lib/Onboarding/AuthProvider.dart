import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  static const String apiUrl = 'https://campusconnect.site/api/login-api/';
  static const String logoutApiUrl = 'https://campusconnect.site/api/logout-api/';

  bool _isLoggedIn = false;
  int? _userId;
  String? _userName;
  String? _userPhone;
  String? _userEmail; // Added for storing the user's email

  String? get userName => _userName;
  String? get userPhone => _userPhone;
  bool get isLoggedIn => _isLoggedIn;
  int? getUserId() => _userId;

  void _storeUserData(Map<String, dynamic> userData) {
    _userId = userData['user_id'];
    _userName = userData['name'];
    _userPhone = userData['phone'];
    _userEmail = userData['email']; // Store the user's email during login
  }

  Future<void> login(String email, String password) async {
    try {
      // Show loading indicator here
      final response = await _performLoginRequest(email, password);
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        if (userData['user_id'] != null) {
          _isLoggedIn = true;
          _storeUserData(userData);
        } else {
          _isLoggedIn = false;
          print('Login failed: Invalid credentials or other error ${response.body}');
        }
      } else {
        _isLoggedIn = false;
        print('Login failed: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      _isLoggedIn = false;
    } finally {
      // Hide loading indicator here
      notifyListeners();
    }
  }

  Future<http.Response> _performLoginRequest(String email, String password) async {
    final requestBody = jsonEncode({
      "email": email,
      "password": password,
    });

    return await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );
  }

  Future<void> logout(String password) async {
    try {
      // Show loading indicator here

      final requestBody = jsonEncode({
        "email": _userEmail, // Use the stored email for logout
        "password": password, // Use the provided password for logout
      });

      final response = await http.post(
        Uri.parse(logoutApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Logout successful
        _isLoggedIn = false;
        print('Logout successful. Response: ${requestBody}');
      } else {
        print('Logout failed: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      // Hide loading indicator here
      notifyListeners();
    }
  }
}
