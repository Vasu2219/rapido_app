import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rapido_app/models/user.dart';
import 'package:rapido_app/models/ride.dart';

class ApiService {
  // Base URL for the API
  static const String baseUrl = 'http://10.0.2.2:5000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:5000'; // For iOS simulator
  
  final storage = const FlutterSecureStorage();
  
  // Headers
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    
    if (requiresAuth) {
      final token = await storage.read(key: 'auth_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  // Test login with admin credentials (for testing)
  Future<Map<String, dynamic>> testLogin() async {
    return await login('admin@rapido.com', 'Admin@123');
  }
  
  // Login - Updated to handle current backend response
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: await _getHeaders(requiresAuth: false),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      // Handle the current backend response format
      if (response.statusCode == 200) {
        if (data.containsKey('data') && data['data'] != null && data['data'].containsKey('token')) {
          // Full response with token and user data
          await storage.write(key: 'auth_token', value: data['data']['token']);
          await storage.write(key: 'user_data', value: jsonEncode(data['data']['user']));
          return data;
        } else if (data.containsKey('message')) {
          // Temporary: Create mock response for testing
          final mockResponse = {
            'success': true,
            'message': 'Login successful (mock)',
            'data': {
              'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
              'user': {
                '_id': 'mock_user_id',
                'firstName': 'Admin',
                'lastName': 'User',
                'email': email,
                'role': 'admin',
                'isActive': true,
                'createdAt': DateTime.now().toIso8601String(),
                'updatedAt': DateTime.now().toIso8601String(),
              }
            }
          };
          
          await storage.write(key: 'auth_token', value: mockResponse['data']['token']);
          await storage.write(key: 'user_data', value: jsonEncode(mockResponse['data']['user']));
          return mockResponse;
        }
      }
      
      throw Exception(data['message'] ?? 'Login failed');
    } catch (e) {
      print('Login error: $e');
      throw Exception('Failed to login: $e');
    }
  }
  
  // Register
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: await _getHeaders(requiresAuth: false),
      body: jsonEncode(userData),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 201 && data['success'] == true) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to register');
    }
  }
  
  // Get user profile
  Future<User> getUserProfile() async {
    final userData = await storage.read(key: 'user_data');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    throw Exception('User data not found');
  }
  
  // Update profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/auth/profile'),
      headers: await _getHeaders(),
      body: jsonEncode(profileData),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200 && data['success'] == true) {
      // Update stored user data
      await storage.write(key: 'user_data', value: jsonEncode(data['data']['user']));
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to update profile');
    }
  }
  
  // Book a ride
  Future<Map<String, dynamic>> bookRide(Map<String, dynamic> rideData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/rides'),
      headers: await _getHeaders(),
      body: jsonEncode(rideData),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 201 && data['success'] == true) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to book ride');
    }
  }
  
  // Get user rides
  Future<List<Ride>> getUserRides() async {
    final user = await getUserProfile();
    
    final response = await http.get(
      Uri.parse('$baseUrl/api/rides/user/${user.id}'),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200 && data['success'] == true) {
      final rides = data['data']['rides'] as List;
      return rides.map((ride) => Ride.fromJson(ride)).toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to get rides');
    }
  }
  
  // Get all rides (for testing)
  Future<List<Ride>> getAllRides() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/rides'),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200 && data['success'] == true) {
      final rides = data['data']['rides'] as List;
      return rides.map((ride) => Ride.fromJson(ride)).toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to get rides');
    }
  }
  
  // Test API connection
  Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
  
  // Logout
  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_data');
  }
}
