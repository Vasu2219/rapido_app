import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/providers/auth_provider.dart';
import 'package:rapido_app/screens/admin_dashboard_screen.dart';
import 'package:rapido_app/screens/user_dashboard_screen.dart';
import 'package:rapido_app/screens/login_screen.dart';

class RoleBasedNavigation extends StatelessWidget {
  const RoleBasedNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print('🧭 RoleBasedNavigation: isAuthenticated=${authProvider.isAuthenticated}');
        print('🧭 RoleBasedNavigation: user=${authProvider.user}');
        print('🧭 RoleBasedNavigation: userRole=${authProvider.user?.role}');

        // If not authenticated, show login screen
        if (!authProvider.isAuthenticated || authProvider.user == null) {
          print('🧭 Redirecting to LoginScreen - not authenticated');
          return const LoginScreen();
        }

        // Get user role
        final userRole = authProvider.user!.role.toLowerCase();
        print('🧭 User role detected: $userRole');

        // Route based on role
        switch (userRole) {
          case 'admin':
            print('🧭 Routing to AdminDashboardScreen');
            return const AdminDashboardScreen();
          case 'user':
          case 'employee':
            print('🧭 Routing to UserDashboardScreen');
            return const UserDashboardScreen();
          default:
            print('🧭 Unknown role: $userRole, defaulting to UserDashboardScreen');
            return const UserDashboardScreen();
        }
      },
    );
  }
}

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({Key? key}) : super(key: key);

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  @override
  void initState() {
    super.initState();
    print('🧭 DashboardWrapper initialized');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print('🧭 DashboardWrapper: Building with auth state');
        print('🧭 DashboardWrapper: isAuthenticated=${authProvider.isAuthenticated}');
        
        if (authProvider.isLoading) {
          print('🧭 DashboardWrapper: Showing loading screen');
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            ),
          );
        }

        return const RoleBasedNavigation();
      },
    );
  }
}

// Custom route for handling role-based navigation
class RoleBasedRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print('🧭 RoleBasedRoute: Generating route for ${settings.name}');
    
    switch (settings.name) {
      case '/':
      case '/dashboard':
        return MaterialPageRoute(
          builder: (context) => const DashboardWrapper(),
          settings: settings,
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          settings: settings,
        );
      case '/admin':
        return MaterialPageRoute(
          builder: (context) => const AdminDashboardScreen(),
          settings: settings,
        );
      case '/user':
        return MaterialPageRoute(
          builder: (context) => const UserDashboardScreen(),
          settings: settings,
        );
      default:
        print('🧭 RoleBasedRoute: Unknown route ${settings.name}, redirecting to dashboard');
        return MaterialPageRoute(
          builder: (context) => const DashboardWrapper(),
          settings: settings,
        );
    }
  }
}

// Utility class for navigation helpers
class NavigationHelper {
  static void navigateBasedOnRole(BuildContext context, AuthProvider authProvider) {
    print('🧭 NavigationHelper: Navigating based on role');
    
    if (!authProvider.isAuthenticated || authProvider.user == null) {
      print('🧭 NavigationHelper: Not authenticated, going to login');
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    final userRole = authProvider.user!.role.toLowerCase();
    print('🧭 NavigationHelper: User role: $userRole');

    switch (userRole) {
      case 'admin':
        print('🧭 NavigationHelper: Navigating to admin dashboard');
        Navigator.of(context).pushReplacementNamed('/admin');
        break;
      case 'user':
      case 'employee':
        print('🧭 NavigationHelper: Navigating to user dashboard');
        Navigator.of(context).pushReplacementNamed('/user');
        break;
      default:
        print('🧭 NavigationHelper: Unknown role, going to default dashboard');
        Navigator.of(context).pushReplacementNamed('/dashboard');
        break;
    }
  }

  static void logout(BuildContext context, AuthProvider authProvider) {
    print('🧭 NavigationHelper: Logging out user');
    authProvider.logout().then((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  static String getDefaultRouteForRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return '/admin';
      case 'user':
      case 'employee':
        return '/user';
      default:
        return '/dashboard';
    }
  }
}
