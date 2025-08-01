class Ride {
  final String id;
  final String userId;
  final String pickupLocation;
  final String dropLocation;
  final DateTime scheduledTime;
  final String status;
  final double estimatedFare;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? driver;

  // Getter for scheduleTime (alias for scheduledTime)
  DateTime get scheduleTime => scheduledTime;

  Ride({
    required this.id,
    required this.userId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.scheduledTime,
    required this.status,
    required this.estimatedFare,
    required this.createdAt,
    required this.updatedAt,
    this.driver,
  });

  // Factory constructor to create a Ride from JSON
  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropLocation: json['dropLocation'] ?? '',
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'])
          : json['scheduleTime'] != null
              ? DateTime.parse(json['scheduleTime'])
              : DateTime.now(),
      status: json['status'] ?? 'pending',
      estimatedFare: (json['estimatedFare'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      driver: json['driver'],
    );
  }

  // Convert Ride to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'scheduledTime': scheduledTime.toIso8601String(),
      'status': status,
      'estimatedFare': estimatedFare,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'driver': driver,
    };
  }

  // Get status color
  String getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA000'; // Amber
      case 'approved':
        return '#4CAF50'; // Green
      case 'completed':
        return '#2196F3'; // Blue
      case 'cancelled':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }
}