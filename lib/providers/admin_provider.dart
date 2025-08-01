import 'package:flutter/material.dart';
import 'package:rapido_app/api/api_service.dart';
import 'package:rapido_app/models/ride.dart';

class AdminProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Ride> _allRides = [];
  List<Ride> _filteredRides = [];
  bool _isLoading = false;
  String? _error;
  String _currentFilter = 'All';
  int _notificationCount = 0;
  
  // Getters
  List<Ride> get allRides => _allRides;
  List<Ride> get filteredRides => _filteredRides;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentFilter => _currentFilter;
  int get notificationCount => _notificationCount;
  
  // Auto refresh timer
  void startAutoRefresh() {
    // Refresh every 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      if (!_isLoading) {
        refreshRides();
      }
      startAutoRefresh();
    });
  }
  
  // Get all rides for admin
  Future<void> getAllRides() async {
    _setLoading(true);
    _error = null;
    
    try {
      _allRides = await _apiService.getAdminRides();
      _applyFilter(_currentFilter);
      _updateNotificationCount();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }
  
  // Refresh rides (for pull-to-refresh)
  Future<void> refreshRides() async {
    await getAllRides();
  }
  
  // Filter rides by status
  void filterRides(String status) {
    _currentFilter = status;
    _applyFilter(status);
    notifyListeners();
  }
  
  void _applyFilter(String status) {
    if (status == 'All') {
      _filteredRides = List.from(_allRides);
    } else {
      _filteredRides = _allRides.where((ride) => 
        ride.status.toLowerCase() == status.toLowerCase()
      ).toList();
    }
  }
  
  // Approve ride
  Future<bool> approveRide(String rideId, {String? comments}) async {
    try {
      await _apiService.approveRide(rideId, comments: comments);
      
      // Update the ride status locally
      final rideIndex = _allRides.indexWhere((ride) => ride.id == rideId);
      if (rideIndex != -1) {
        // Create a new ride object with updated status
        final updatedRide = Ride(
          id: _allRides[rideIndex].id,
          userId: _allRides[rideIndex].userId,
          pickupLocation: _allRides[rideIndex].pickupLocation,
          dropLocation: _allRides[rideIndex].dropLocation,
          scheduledTime: _allRides[rideIndex].scheduledTime,
          status: 'approved',
          estimatedFare: _allRides[rideIndex].estimatedFare,
          createdAt: _allRides[rideIndex].createdAt,
          updatedAt: DateTime.now(),
          driver: _allRides[rideIndex].driver,
          userDetails: _allRides[rideIndex].userDetails,
        );
        
        _allRides[rideIndex] = updatedRide;
        _applyFilter(_currentFilter);
        _updateNotificationCount();
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Reject ride
  Future<bool> rejectRide(String rideId, {String? reason, String? comments}) async {
    try {
      await _apiService.rejectRide(rideId, reason: reason, comments: comments);
      
      // Update the ride status locally
      final rideIndex = _allRides.indexWhere((ride) => ride.id == rideId);
      if (rideIndex != -1) {
        // Create a new ride object with updated status
        final updatedRide = Ride(
          id: _allRides[rideIndex].id,
          userId: _allRides[rideIndex].userId,
          pickupLocation: _allRides[rideIndex].pickupLocation,
          dropLocation: _allRides[rideIndex].dropLocation,
          scheduledTime: _allRides[rideIndex].scheduledTime,
          status: 'rejected',
          estimatedFare: _allRides[rideIndex].estimatedFare,
          createdAt: _allRides[rideIndex].createdAt,
          updatedAt: DateTime.now(),
          driver: _allRides[rideIndex].driver,
          userDetails: _allRides[rideIndex].userDetails,
        );
        
        _allRides[rideIndex] = updatedRide;
        _applyFilter(_currentFilter);
        _updateNotificationCount();
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Update notification count
  void _updateNotificationCount() {
    _notificationCount = _allRides.where((ride) => 
      ride.status.toLowerCase() == 'pending'
    ).length;
  }
  
  // Get notification count from server
  Future<void> updateNotificationCount() async {
    try {
      _notificationCount = await _apiService.getAdminNotificationCount();
      notifyListeners();
    } catch (e) {
      print('Error updating notification count: $e');
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
