import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rapido_app/api/api_service.dart';
import 'package:rapido_app/models/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  // Initialize - check if user is already logged in
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _user = await _apiService.getUserProfile();
      _isAuthenticated = true;
    } catch (e) {
      _isAuthenticated = false;
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    print('🚀 AuthProvider: Starting login...');
    _setLoading(true);
    _error = null;

    try {
      print('📞 AuthProvider: Calling API service...');
      final response = await _apiService.login(email, password);
      print('📋 AuthProvider: Got response: $response');
      
      _user = User.fromJson(response['data']['user']);
      _isAuthenticated = true;
      print('✅ AuthProvider: Login successful, user set');
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ AuthProvider: Login error: $e');
      _error = e.toString();
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<bool> register(Map<String, dynamic> userData) async {
    _setLoading(true);
    _error = null;

    try {
      await _apiService.register(userData);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update profile
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.updateProfile(profileData);
      _user = User.fromJson(response['data']['user']);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _apiService.logout();
      _user = null;
      _isAuthenticated = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}