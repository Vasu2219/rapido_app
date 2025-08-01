import 'package:flutter/material.dart';
import 'package:rapido_app/theme/app_theme.dart';
import 'package:rapido_app/models/ride.dart';
import 'package:intl/intl.dart';

class RideCard extends StatelessWidget {
  final Ride ride;

  const RideCard({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                _buildStatusIndicator(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusText(),
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(ride.scheduleTime),
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFareIndicator(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Route information
            Row(
              children: [
                // Pickup
                Expanded(
                  child: _buildLocationInfo(
                    icon: Icons.my_location,
                    title: 'Pickup',
                    address: ride.pickupLocation,
                    color: Colors.green,
                  ),
                ),
                
                // Arrow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_downward,
                    color: AppTheme.secondaryTextColor,
                    size: 20,
                  ),
                ),
                
                // Drop
                Expanded(
                  child: _buildLocationInfo(
                    icon: Icons.location_on,
                    title: 'Drop',
                    address: ride.dropLocation,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            
            // Driver information (if available)
            if (ride.driver != null) ...[
              const SizedBox(height: 16),
              _buildDriverInfo(),
            ],
            
            // Action buttons
            if (_showActionButtons()) ...[
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildFareIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '₹${ride.estimatedFare.toStringAsFixed(0)}',
        style: const TextStyle(
          color: AppTheme.accentColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLocationInfo({
    required IconData icon,
    required String title,
    required String address,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.accentColor.withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: AppTheme.accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride.driver!['name'] ?? 'Driver',
                  style: const TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ride.driver!['vehicle'] ?? 'Vehicle',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.phone,
              color: AppTheme.accentColor,
              size: 20,
            ),
            onPressed: () {
              // Handle call action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (ride.status == 'pending')
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle cancel action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel Ride',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        
        if (ride.status == 'approved')
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle track action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Track Ride',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        
        if (ride.status == 'completed')
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle rate action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Rate Ride',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }

  String _getStatusText() {
    switch (ride.status.toLowerCase()) {
      case 'pending':
        return 'Pending Approval';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return ride.status;
    }
  }

  Color _getStatusColor() {
    switch (ride.status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      default:
        return AppTheme.secondaryTextColor;
    }
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return date.toString();
    }
  }

  bool _showActionButtons() {
    return ['pending', 'approved', 'completed'].contains(ride.status.toLowerCase());
  }
} 