import 'package:flutter/material.dart';
import 'package:rapido_app/theme/app_theme.dart';
import 'package:rapido_app/widgets/service_card.dart';
import 'package:rapido_app/screens/ride_booking_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Go anywhere, get anything',
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Card
            _buildFeaturedCard(),
            const SizedBox(height: 24),
            
            // Service Categories Grid
            _buildServiceGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side - Text content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enjoy stress-free travel with Uber Reserve',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      // Navigate to reserve booking
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Book in advance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Right side - Calendar illustration
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Calendar grid
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GridView.count(
                        crossAxisCount: 7,
                        padding: const EdgeInsets.all(4),
                        children: List.generate(31, (index) {
                          final day = index + 1;
                          final isHighlighted = day == 18; // Highlight day 18
                          
                          return Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: isHighlighted ? Colors.red : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                day.toString(),
                                style: TextStyle(
                                  color: isHighlighted ? Colors.white : Colors.black54,
                                  fontSize: 10,
                                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  
                  // Location pin
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Services',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Row 1
        Row(
          children: [
            Expanded(
              child: ServiceCard(
                title: 'Trip',
                icon: Icons.directions_car,
                color: Colors.green,
                hasPromo: true,
                onTap: () => _navigateToRideBooking('trip'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ServiceCard(
                title: 'Intercity',
                icon: Icons.flight,
                color: Colors.blue,
                hasPromo: true,
                onTap: () => _navigateToRideBooking('intercity'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 2
        Row(
          children: [
            Expanded(
              child: ServiceCard(
                title: 'Reserve',
                icon: Icons.schedule,
                color: Colors.orange,
                onTap: () => _navigateToRideBooking('reserve'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ServiceCard(
                title: 'Rentals',
                icon: Icons.access_time,
                color: Colors.purple,
                onTap: () => _navigateToRideBooking('rentals'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Row 3
        Row(
          children: [
            Expanded(
              child: ServiceCard(
                title: 'Teens',
                icon: Icons.school,
                color: Colors.red,
                onTap: () => _navigateToRideBooking('teens'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ServiceCard(
                title: 'Corporate',
                icon: Icons.business,
                color: Colors.indigo,
                onTap: () => _navigateToRideBooking('corporate'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToRideBooking(String serviceType) {
    // Navigate to ride booking screen
    // This would be implemented based on your navigation structure
  }
} 