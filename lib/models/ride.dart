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
  final Map<String, dynamic>? userDetails; // To store full user object if available

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
    this.userDetails,
  });

  // Factory constructor to create a Ride from JSON
  factory Ride.fromJson(Map<String, dynamic> json) {
    // Handle userId - it can be either a string or an object
    String userIdValue;
    Map<String, dynamic>? userDetailsValue;
    
    if (json['userId'] is String) {
      userIdValue = json['userId'];
    } else if (json['userId'] is Map<String, dynamic>) {
      final userObj = json['userId'] as Map<String, dynamic>;
      userIdValue = userObj['_id'] ?? userObj['id'] ?? '';
      userDetailsValue = userObj;
    } else {
      userIdValue = '';
    }
    
    return Ride(
      id: json['_id'] ?? json['id'] ?? '',
      userId: userIdValue,
      // Handle both old and new field names
      pickupLocation: json['pickup'] ?? json['pickupLocation'] ?? '',
      dropLocation: json['drop'] ?? json['dropLocation'] ?? '',
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
      userDetails: userDetailsValue,
    );
  }

  // Convert Ride to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'pickup': pickupLocation, // Use backend field names
      'drop': dropLocation, // Use backend field names
      'scheduleTime': scheduledTime.toIso8601String(), // Use backend field name
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