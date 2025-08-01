import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/foundation.dart';

class RealtimeService {
  static WebSocketChannel? _channel;
  static StreamController<Map<String, dynamic>>? _messageController;
  static bool _isConnected = false;
  static Timer? _reconnectTimer;
  static const String _baseUrl = 'ws://localhost:5000'; // Update with your backend WebSocket URL

  static Stream<Map<String, dynamic>> get messageStream => 
      _messageController?.stream ?? Stream.empty();

  static bool get isConnected => _isConnected;

  static Future<void> initialize() async {
    _messageController = StreamController<Map<String, dynamic>>.broadcast();
  }

  static Future<void> connect({String? token}) async {
    if (_isConnected) return;

    try {
      final wsUrl = token != null 
          ? '$_baseUrl/ws?token=$token'
          : '$_baseUrl/ws';
      
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          _handleError(error);
        },
        onDone: () {
          _handleDisconnect();
        },
      );

      _isConnected = true;
      _sendMessage({
        'type': 'connection',
        'data': {'status': 'connected'}
      });
      
      if (kDebugMode) {
        print('🔌 WebSocket connected');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ WebSocket connection failed: $e');
      }
      _scheduleReconnect();
    }
  }

  static void _handleMessage(dynamic message) {
    try {
      Map<String, dynamic> data;
      if (message is String) {
        data = json.decode(message);
      } else {
        data = Map<String, dynamic>.from(message);
      }
      
      _messageController?.add(data);
      
      if (kDebugMode) {
        print('📨 WebSocket message received: $data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error parsing WebSocket message: $e');
      }
    }
  }

  static void _handleError(dynamic error) {
    _isConnected = false;
    if (kDebugMode) {
      print('❌ WebSocket error: $error');
    }
    _scheduleReconnect();
  }

  static void _handleDisconnect() {
    _isConnected = false;
    if (kDebugMode) {
      print('🔌 WebSocket disconnected');
    }
    _scheduleReconnect();
  }

  static void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_isConnected) {
        connect();
      }
    });
  }

  static void _sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(json.encode(message));
    }
  }

  // Subscribe to ride updates
  static void subscribeToRide(String rideId) {
    _sendMessage({
      'type': 'subscribe',
      'data': {
        'channel': 'ride_updates',
        'rideId': rideId
      }
    });
  }

  // Subscribe to user notifications
  static void subscribeToUser(String userId) {
    _sendMessage({
      'type': 'subscribe',
      'data': {
        'channel': 'user_notifications',
        'userId': userId
      }
    });
  }

  // Send ride status update
  static void updateRideStatus(String rideId, String status) {
    _sendMessage({
      'type': 'ride_status_update',
      'data': {
        'rideId': rideId,
        'status': status,
        'timestamp': DateTime.now().toIso8601String()
      }
    });
  }

  // Send admin approval/rejection
  static void sendAdminAction(String rideId, String action, {String? reason}) {
    _sendMessage({
      'type': 'admin_action',
      'data': {
        'rideId': rideId,
        'action': action, // 'approve' or 'reject'
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String()
      }
    });
  }

  static void disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
    if (kDebugMode) {
      print('🔌 WebSocket disconnected manually');
    }
  }

  static void dispose() {
    disconnect();
    _messageController?.close();
  }
} 