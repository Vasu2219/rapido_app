import 'package:flutter/material.dart';
import 'package:rapido_app/api/api_service.dart';
import 'package:rapido_app/models/ride.dart';

class RideProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Ride> _rides = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Ride> get rides => _rides;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get user rides
  Future<void> getUserRides() async {
    _setLoading(true);
    _error = null;

    try {
      _rides = await _apiService.getUserRides();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Book a ride
  Future<bool> bookRide(Map<String, dynamic> rideData) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.bookRide(rideData);
      // Add the new ride to the list
      final newRide = Ride.fromJson(response['data']['ride']);
      _rides.add(newRide);
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

  // Get pending rides
  List<Ride> getPendingRides() {
    return _rides.where((ride) => ride.status.toLowerCase() == 'pending').toList();
  }

  // Get completed rides
  List<Ride> getCompletedRides() {
    return _rides.where((ride) => ride.status.toLowerCase() == 'completed').toList();
  }

  // Get ride by id
  Ride? getRideById(String id) {
    try {
      return _rides.firstWhere((ride) => ride.id == id);
    } catch (e) {
      return null;
    }
  }
}