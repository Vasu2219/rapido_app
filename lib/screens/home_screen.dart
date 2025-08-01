import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/providers/auth_provider.dart';
import 'package:rapido_app/providers/realtime_provider.dart';
import 'package:rapido_app/theme/app_theme.dart';
import 'package:rapido_app/widgets/service_card.dart';
import 'package:rapido_app/widgets/promotional_banner.dart';
import 'package:rapido_app/widgets/recent_destination_card.dart';
import 'package:rapido_app/widgets/connection_status_bar.dart';
import 'package:rapido_app/screens/ride_booking_screen.dart';
import 'package:rapido_app/screens/services_screen.dart';
import 'package:rapido_app/screens/activity_screen.dart';
import 'package:rapido_app/screens/account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    
    // Connect to real-time service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final realtimeProvider = Provider.of<RealtimeProvider>(context, listen: false);
      
      if (authProvider.isAuthenticated && authProvider.token != null) {
        realtimeProvider.connect(token: authProvider.token);
        realtimeProvider.subscribeToUser(authProvider.user?.id ?? '');
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Connection Status Bar
            const ConnectionStatusBar(),
            
            // Main Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Header
                        _buildAppHeader(),
                        const SizedBox(height: 24),
                        
                        // Search Bar
                        _buildSearchBar(),
                        const SizedBox(height: 16),
                        
                        // Recent Destination
                        const RecentDestinationCard(),
                        const SizedBox(height: 24),
                        
                        // Services Section
                        _buildServicesSection(),
                        const SizedBox(height: 24),
                        
                        // Promotional Banner
                        const PromotionalBanner(),
                        const SizedBox(height: 24),
                        
                        // Plan Your Next Trip Section
                        _buildPlanNextTripSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppHeader() {
    return Row(
      children: [
        Text(
          'Rapido',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const Spacer(),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.cardColor,
              child: Text(
                authProvider.user?.firstName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search,
            color: AppTheme.secondaryTextColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Where to?',
              style: TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.schedule,
                  color: AppTheme.secondaryTextColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Later',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Suggestions',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServicesScreen()),
                );
              },
              child: Text(
                'See all',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
      ],
    );
  }

  Widget _buildPlanNextTripSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan your next trip',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppTheme.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.lightBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'Coming Soon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        border: Border(
          top: BorderSide(color: AppTheme.dividerColor, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.textColor,
        unselectedItemColor: AppTheme.secondaryTextColor,
        elevation: 0,
        currentIndex: 0, // Home is selected
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServicesScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActivityScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  void _navigateToRideBooking(String serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RideBookingScreen(serviceType: serviceType),
      ),
    );
  }
}