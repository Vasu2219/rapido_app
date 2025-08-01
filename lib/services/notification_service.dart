import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (kDebugMode) {
      print('🔔 Notification service initialized');
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('🔔 Notification tapped: ${response.payload}');
    }
    // Handle notification tap - navigate to specific screen
  }

  static Future<void> showRideStatusNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'ride_status',
      'Ride Status Updates',
      channelDescription: 'Notifications for ride status changes',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> showRideApprovedNotification({
    required String rideId,
    required String pickup,
    required String drop,
  }) async {
    await showRideStatusNotification(
      title: '🚗 Ride Approved!',
      body: 'Your ride from $pickup to $drop has been approved.',
      payload: 'ride_approved:$rideId',
    );
  }

  static Future<void> showRideRejectedNotification({
    required String rideId,
    required String reason,
  }) async {
    await showRideStatusNotification(
      title: '❌ Ride Rejected',
      body: 'Your ride request was rejected. Reason: $reason',
      payload: 'ride_rejected:$rideId',
    );
  }

  static Future<void> showRideStartedNotification({
    required String rideId,
    required String driverName,
    required String vehicleNumber,
  }) async {
    await showRideStatusNotification(
      title: '🚀 Ride Started',
      body: 'Your ride has started! Driver: $driverName, Vehicle: $vehicleNumber',
      payload: 'ride_started:$rideId',
    );
  }

  static Future<void> showRideCompletedNotification({
    required String rideId,
    required double fare,
  }) async {
    await showRideStatusNotification(
      title: '✅ Ride Completed',
      body: 'Your ride has been completed. Fare: ₹$fare',
      payload: 'ride_completed:$rideId',
    );
  }

  static Future<void> showNewRideRequestNotification({
    required String rideId,
    required String userName,
    required String pickup,
    required String drop,
  }) async {
    await showRideStatusNotification(
      title: '🆕 New Ride Request',
      body: 'New ride request from $userName: $pickup to $drop',
      payload: 'new_ride_request:$rideId',
    );
  }

  static Future<void> showDriverAssignedNotification({
    required String rideId,
    required String driverName,
    required String phone,
    required String vehicle,
  }) async {
    await showRideStatusNotification(
      title: '👨‍💼 Driver Assigned',
      body: 'Driver $driverName ($vehicle) has been assigned to your ride. Call: $phone',
      payload: 'driver_assigned:$rideId',
    );
  }

  static Future<void> showPromotionalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'promotions',
      'Promotions',
      channelDescription: 'Promotional notifications and offers',
      importance: Importance.low,
      priority: Priority.low,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
} 