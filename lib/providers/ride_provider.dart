import 'package:flutter/material.dart';
import 'package:rapido_app/api/api_service.dart';
import 'package:rapido_app/models/ride.dart';

class RideProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Ride> _rides = [];
  List<Ride> _filteredRides = [];
  bool _isLoading = false;
  String? _error;
  String _selectedFilter = 'All';

  // Getters
  List<Ride> get rides => _filteredRides;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedFilter => _selectedFilter;

  // Set filter and update the filtered rides
  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  // Apply filter to rides
  void _applyFilter() {
    if (_selectedFilter == 'All') {
      _filteredRides = List.from(_rides);
    } else {
      _filteredRides = _rides.where((ride) => 
        ride.status.toLowerCase() == _selectedFilter.toLowerCase()
      ).toList();
    }
  }

  // Get user rides
  Future<void> getUserRides() async {
    _setLoading(true);
    _error = null;

    try {
      _rides = await _apiService.getUserRides();
      _applyFilter(); // Apply current filter to new data
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
      _applyFilter(); // Apply current filter after adding new ride
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

  // Cancel a ride
  Future<bool> cancelRide(String rideId, {String? reason}) async {
    try {
      // Find the ride to cancel
      final rideIndex = _rides.indexWhere((ride) => ride.id == rideId);
      if (rideIndex == -1) {
        throw Exception('Ride not found');
      }

      // Optimistically update the UI
      final oldRide = _rides[rideIndex];
      _rides[rideIndex] = Ride(
        id: oldRide.id,
        userId: oldRide.userId,
        pickupLocation: oldRide.pickupLocation,
        dropLocation: oldRide.dropLocation,
        scheduledTime: oldRide.scheduledTime,
        estimatedFare: oldRide.estimatedFare,
        status: 'cancelled',
        createdAt: oldRide.createdAt,
        updatedAt: DateTime.now(),
        driver: oldRide.driver,
        userDetails: oldRide.userDetails,
      );
      _applyFilter();
      notifyListeners();

      // Make the API call
      await _apiService.cancelRide(rideId, reason: reason);
      
      // Refresh data to get the latest state
      await getUserRides();
      return true;
    } catch (e) {
      _error = e.toString();
      // Refresh data on error to revert optimistic update
      await getUserRides();
      notifyListeners();
      return false;
    }
  }

  // Create a ride (alias for bookRide)
  Future<bool> createRide(Map<String, dynamic> rideData) async {
    return await bookRide(rideData);
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

  // Get approved rides
  List<Ride> getApprovedRides() {
    return _rides.where((ride) => ride.status.toLowerCase() == 'approved').toList();
  }

  // Get cancelled rides
  List<Ride> getCancelledRides() {
    return _rides.where((ride) => ride.status.toLowerCase() == 'cancelled').toList();
  }

  // Get all rides (unfiltered)
  List<Ride> get allRides => _rides;

  // Get ride by id
  Ride? getRideById(String id) {
    try {
      return _rides.firstWhere((ride) => ride.id == id);
    } catch (e) {
      return null;
    }
  }
}