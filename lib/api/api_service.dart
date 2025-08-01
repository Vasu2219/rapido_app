import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rapido_app/models/user.dart';
import 'package:rapido_app/models/ride.dart';

class ApiService {
  // Base URL for the API
  static const String baseUrl = 'http://localhost:5000'; // For web/Chrome
  // static const String baseUrl = 'http://10.0.2.2:5000'; // For Android emulator
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
  
  // Login - Updated to handle real backend response
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔍 API Service: Starting login process...');
      print('📍 Backend URL: $baseUrl');
      print('📧 Email: $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: await _getHeaders(requiresAuth: false),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      print('📊 Response Status: ${response.statusCode}');
      print('📝 Response Body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        // Real login response with token and user data
        print('✅ Real login successful - saving token and user data');
        // Save token
        await storage.write(key: 'auth_token', value: data['data']['token']);
        // Save user data
        await storage.write(key: 'user_data', value: jsonEncode(data['data']['user']));
        return data;
      }
      
      throw Exception(data['message'] ?? 'Login failed');
    } catch (e) {
      print('💥 Login error: $e');
      rethrow;
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

  // Get stored token
  Future<String?> getStoredToken() async {
    return await storage.read(key: 'auth_token');
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
    try {
      print('🔍 Getting user rides...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/rides'), // Use the correct endpoint
        headers: await _getHeaders(),
      );
      
      print('📊 User rides response status: ${response.statusCode}');
      print('📝 User rides response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        final rides = data['data']['rides'] as List;
        print('✅ Retrieved ${rides.length} rides');
        return rides.map((ride) => Ride.fromJson(ride)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to get rides');
      }
    } catch (e) {
      print('💥 Error getting user rides: $e');
      rethrow;
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

  // Admin Methods
  
  // Get all rides for admin
  Future<List<Ride>> getAdminRides({String? status}) async {
    try {
      String endpoint = '$baseUrl/api/admin/rides';
      if (status != null && status.isNotEmpty && status != 'All') {
        endpoint += '?status=${status.toLowerCase()}';
      }
      
      print('🔍 Getting admin rides from: $endpoint');
      
      final response = await http.get(
        Uri.parse(endpoint),
        headers: await _getHeaders(),
      );
      
      print('📊 Admin rides response status: ${response.statusCode}');
      print('📝 Admin rides response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        final rides = data['data']['rides'] as List;
        print('✅ Retrieved ${rides.length} admin rides');
        return rides.map((ride) => Ride.fromJson(ride)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to get admin rides');
      }
    } catch (e) {
      print('💥 Error getting admin rides: $e');
      rethrow;
    }
  }

  // Approve ride
  Future<Map<String, dynamic>> approveRide(String rideId, {String? comments}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/rides/$rideId/approve'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'comments': comments ?? '',
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to approve ride');
      }
    } catch (e) {
      print('💥 Error approving ride: $e');
      rethrow;
    }
  }

  // Reject ride
  Future<Map<String, dynamic>> rejectRide(String rideId, {String? reason, String? comments}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/rides/$rideId/reject'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'reason': reason ?? 'Not approved',
          'comments': comments ?? '',
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to reject ride');
      }
    } catch (e) {
      print('💥 Error rejecting ride: $e');
      rethrow;
    }
  }

  // Get admin notification count
  Future<int> getAdminNotificationCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications/admin/count'),
        headers: await _getHeaders(),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return data['data']['pendingRides'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('💥 Error getting notification count: $e');
      return 0;
    }
  }

  // Cancel ride
  Future<Map<String, dynamic>> cancelRide(String rideId, {String? reason}) async {
    try {
      print('🚫 Canceling ride: $rideId');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/api/rides/$rideId'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'cancellationReason': reason ?? 'User cancelled',
        }),
      );
      
      print('📊 Cancel ride response status: ${response.statusCode}');
      print('📝 Cancel ride response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ Ride cancelled successfully');
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to cancel ride');
      }
    } catch (e) {
      print('💥 Error canceling ride: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_data');
  }
}