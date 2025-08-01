import 'package:flutter/foundation.dart';
import 'package:rapido_app/services/realtime_service.dart';
import 'package:rapido_app/services/notification_service.dart';

class RealtimeProvider extends ChangeNotifier {
  bool _isConnected = false;
  String _connectionStatus = 'Disconnected';
  List<Map<String, dynamic>> _recentMessages = [];
  Map<String, dynamic>? _lastRideUpdate;
  Map<String, dynamic>? _lastNotification;

  bool get isConnected => _isConnected;
  String get connectionStatus => _connectionStatus;
  List<Map<String, dynamic>> get recentMessages => _recentMessages;
  Map<String, dynamic>? get lastRideUpdate => _lastRideUpdate;
  Map<String, dynamic>? get lastNotification => _lastNotification;

  RealtimeProvider() {
    _initializeRealtimeService();
  }

  void _initializeRealtimeService() {
    // Listen to WebSocket messages
    RealtimeService.messageStream.listen((message) {
      _handleRealtimeMessage(message);
    });
  }

  void _handleRealtimeMessage(Map<String, dynamic> message) {
    final type = message['type'];
    final data = message['data'];

    switch (type) {
      case 'connection':
        _handleConnectionUpdate(data);
        break;
      case 'ride_update':
        _handleRideUpdate(data);
        break;
      case 'notification':
        _handleNotification(data);
        break;
      case 'admin_action':
        _handleAdminAction(data);
        break;
      case 'status_change':
        _handleStatusChange(data);
        break;
      default:
        if (kDebugMode) {
          print('📨 Unknown message type: $type');
        }
    }

    // Add to recent messages
    _recentMessages.insert(0, {
      'type': type,
      'data': data,
      'timestamp': DateTime.now(),
    });

    // Keep only last 50 messages
    if (_recentMessages.length > 50) {
      _recentMessages = _recentMessages.take(50).toList();
    }

    notifyListeners();
  }

  void _handleConnectionUpdate(Map<String, dynamic> data) {
    _isConnected = data['status'] == 'connected';
    _connectionStatus = _isConnected ? 'Connected' : 'Disconnected';
    
    if (kDebugMode) {
      print('🔌 Connection status: $_connectionStatus');
    }
  }

  void _handleRideUpdate(Map<String, dynamic> data) {
    _lastRideUpdate = data;
    
    final rideId = data['rideId'];
    final status = data['status'];
    final pickup = data['pickup']?['address'] ?? 'Unknown location';
    final drop = data['drop']?['address'] ?? 'Unknown location';

    // Show appropriate notification based on status
    switch (status) {
      case 'approved':
        NotificationService.showRideApprovedNotification(
          rideId: rideId,
          pickup: pickup,
          drop: drop,
        );
        break;
      case 'rejected':
        final reason = data['rejectionReason'] ?? 'No reason provided';
        NotificationService.showRideRejectedNotification(
          rideId: rideId,
          reason: reason,
        );
        break;
      case 'in_progress':
        final driverName = data['driver']?['name'] ?? 'Driver';
        final vehicle = data['driver']?['vehicle'] ?? 'Vehicle';
        NotificationService.showRideStartedNotification(
          rideId: rideId,
          driverName: driverName,
          vehicleNumber: vehicle,
        );
        break;
      case 'completed':
        final fare = data['actualFare'] ?? 0.0;
        NotificationService.showRideCompletedNotification(
          rideId: rideId,
          fare: fare.toDouble(),
        );
        break;
    }

    if (kDebugMode) {
      print('🚗 Ride update: $rideId - $status');
    }
  }

  void _handleNotification(Map<String, dynamic> data) {
    _lastNotification = data;
    
    final title = data['title'];
    final body = data['body'];
    final type = data['notificationType'];

    switch (type) {
      case 'promotional':
        NotificationService.showPromotionalNotification(
          title: title,
          body: body,
        );
        break;
      case 'driver_assigned':
        final rideId = data['rideId'];
        final driverName = data['driverName'];
        final phone = data['phone'];
        final vehicle = data['vehicle'];
        NotificationService.showDriverAssignedNotification(
          rideId: rideId,
          driverName: driverName,
          phone: phone,
          vehicle: vehicle,
        );
        break;
      default:
        NotificationService.showRideStatusNotification(
          title: title,
          body: body,
        );
    }

    if (kDebugMode) {
      print('🔔 Notification: $title - $body');
    }
  }

  void _handleAdminAction(Map<String, dynamic> data) {
    final action = data['action'];
    final rideId = data['rideId'];
    final reason = data['reason'];

    if (kDebugMode) {
      print('👨‍💼 Admin action: $action on ride $rideId');
    }

    // This will trigger ride update notifications
    _handleRideUpdate({
      'rideId': rideId,
      'status': action == 'approve' ? 'approved' : 'rejected',
      'rejectionReason': action == 'reject' ? reason : null,
    });
  }

  void _handleStatusChange(Map<String, dynamic> data) {
    final rideId = data['rideId'];
    final newStatus = data['newStatus'];
    final oldStatus = data['oldStatus'];

    if (kDebugMode) {
      print('🔄 Status change: $rideId from $oldStatus to $newStatus');
    }

    _handleRideUpdate({
      'rideId': rideId,
      'status': newStatus,
      ...data,
    });
  }

  // Connect to WebSocket
  Future<void> connect({String? token}) async {
    _connectionStatus = 'Connecting...';
    notifyListeners();

    await RealtimeService.connect(token: token);
  }

  // Disconnect from WebSocket
  void disconnect() {
    RealtimeService.disconnect();
    _isConnected = false;
    _connectionStatus = 'Disconnected';
    notifyListeners();
  }

  // Subscribe to ride updates
  void subscribeToRide(String rideId) {
    if (_isConnected) {
      RealtimeService.subscribeToRide(rideId);
      if (kDebugMode) {
        print('📡 Subscribed to ride: $rideId');
      }
    }
  }

  // Subscribe to user notifications
  void subscribeToUser(String userId) {
    if (_isConnected) {
      RealtimeService.subscribeToUser(userId);
      if (kDebugMode) {
        print('📡 Subscribed to user: $userId');
      }
    }
  }

  // Send ride status update
  void updateRideStatus(String rideId, String status) {
    if (_isConnected) {
      RealtimeService.updateRideStatus(rideId, status);
      if (kDebugMode) {
        print('📤 Sent ride status update: $rideId - $status');
      }
    }
  }

  // Send admin action
  void sendAdminAction(String rideId, String action, {String? reason}) {
    if (_isConnected) {
      RealtimeService.sendAdminAction(rideId, action, reason: reason);
      if (kDebugMode) {
        print('📤 Sent admin action: $action on $rideId');
      }
    }
  }

  // Clear recent messages
  void clearRecentMessages() {
    _recentMessages.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    RealtimeService.dispose();
    super.dispose();
  }
} 