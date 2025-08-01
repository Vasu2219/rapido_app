import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/providers/auth_provider.dart';
import 'package:rapido_app/providers/ride_provider.dart';
import 'package:rapido_app/models/user.dart';
import 'package:rapido_app/screens/connection_test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Load user rides when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RideProvider>(context, listen: false).getUserRides();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final rideProvider = Provider.of<RideProvider>(context);
    final User? user = authProvider.user;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text(
          'Rapido',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.bug_report,
              color: Colors.orange,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnectionTestScreen(),
                ),
              );
            },
            tooltip: 'Test API Connection',
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.onBackground,
              size: 28,
            ),
            onPressed: () {
              // Navigate to profile screen
              // TODO: Implement profile screen navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Where to?',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // Show date picker for scheduling
                        },
                        tooltip: 'Later',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Suggestions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suggestions',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  TextButton(
                    onPressed: () {
                      // View all suggestions
                    },
                    child: const Text('See all'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Ride Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRideOption(
                    context: context,
                    title: 'Trip',
                    icon: Icons.directions_car,
                    isPromo: true,
                    onTap: () {
                      // Book a trip
                    },
                  ),
                  _buildRideOption(
                    context: context,
                    title: 'Auto',
                    icon: Icons.electric_rickshaw,
                    onTap: () {
                      // Book an auto
                    },
                  ),
                  _buildRideOption(
                    context: context,
                    title: 'Moto',
                    icon: Icons.motorcycle,
                    onTap: () {
                      // Book a motorcycle
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Commute Smarter Section
              Text(
                'Commute smarter',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              
              const SizedBox(height: 16),
              
              // Commute Options
              Row(
                children: [
                  Expanded(
                    child: _buildCommuteOption(
                      context: context,
                      title: 'Go with Rapido Auto',
                      description: 'Doorstep pick-up, no bargaining',
                      icon: Icons.electric_rickshaw,
                      onTap: () {
                        // Book an auto
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCommuteOption(
                      context: context,
                      title: 'Hop on Rapido Moto',
                      description: 'Move through traffic faster',
                      icon: Icons.motorcycle,
                      onTap: () {
                        // Book a motorcycle
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Save Every Day Section
              Text(
                'Save every day',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              
              const SizedBox(height: 16),
              
              // Recent Rides or Promotions
              if (rideProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (rideProvider.error != null)
                Center(
                  child: Text(
                    'Failed to load rides: ${rideProvider.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              else if (rideProvider.rides.isEmpty)
                Center(
                  child: Text(
                    'No recent rides found',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rideProvider.rides.length > 2 ? 2 : rideProvider.rides.length,
                  itemBuilder: (context, index) {
                    final ride = rideProvider.rides[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          ride.status.toLowerCase() == 'completed' 
                              ? Icons.check_circle 
                              : Icons.pending,
                          color: Color(int.parse(ride.getStatusColor().replaceAll('#', '0xFF'))),
                        ),
                        title: Text(ride.dropLocation),
                        subtitle: Text(
                          '${ride.status} • ₹${ride.estimatedFare.toStringAsFixed(2)}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // View ride details
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
            icon: Icon(Icons.history),
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
  
  Widget _buildRideOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    bool isPromo = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            if (isPromo)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Promo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCommuteOption({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}