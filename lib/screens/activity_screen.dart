import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/providers/ride_provider.dart';
import 'package:rapido_app/providers/realtime_provider.dart';
import 'package:rapido_app/theme/app_theme.dart';
import 'package:rapido_app/widgets/ride_card.dart';
import 'package:rapido_app/screens/ride_booking_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    // Load user rides when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RideProvider>(context, listen: false).getUserRides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppTheme.textColor),
            onPressed: () {
              // Show filter options
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Consumer<RideProvider>(
        builder: (context, rideProvider, child) {
          if (rideProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
            );
          }

          if (rideProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.secondaryTextColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load rides',
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rideProvider.error!,
                    style: TextStyle(
                      color: AppTheme.secondaryTextColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      rideProvider.getUserRides();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final rides = rideProvider.rides;
          final upcomingRides = rides.where((ride) => 
            ride.status == 'pending' || ride.status == 'approved'
          ).toList();
          final pastRides = rides.where((ride) => 
            ride.status == 'completed' || ride.status == 'cancelled'
          ).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upcoming Section
                _buildUpcomingSection(upcomingRides),
                const SizedBox(height: 24),
                
                // Past Section
                _buildPastSection(pastRides),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingSection(List rides) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        if (rides.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dividerColor, width: 1),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.schedule,
                  color: AppTheme.secondaryTextColor,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'You have no upcoming trips',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RideBookingScreen(serviceType: 'trip'),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reserve your trip',
                        style: TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: AppTheme.accentColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RideCard(ride: ride),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPastSection(List rides) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Past',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.dividerColor, width: 1),
              ),
              child: const Icon(
                Icons.sort,
                color: AppTheme.secondaryTextColor,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (rides.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dividerColor, width: 1),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.history,
                  color: AppTheme.secondaryTextColor,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'You don\'t have any recent activity',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your completed and cancelled rides will appear here',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RideCard(ride: ride),
              );
            },
          ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'Filter Rides',
          style: TextStyle(color: AppTheme.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('All Rides', true),
            _buildFilterOption('Pending', false),
            _buildFilterOption('Approved', false),
            _buildFilterOption('Completed', false),
            _buildFilterOption('Cancelled', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.secondaryTextColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply filter
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.accentColor : AppTheme.textColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: AppTheme.accentColor)
          : null,
      onTap: () {
        // Handle filter selection
      },
    );
  }
} 