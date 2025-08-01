import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/screens/splash_screen.dart';
import 'package:rapido_app/screens/login_screen.dart';
import 'package:rapido_app/screens/home_screen.dart';
import 'package:rapido_app/screens/registration_screen.dart';
import 'package:rapido_app/screens/admin_dashboard_screen.dart';
import 'package:rapido_app/screens/user_dashboard_screen.dart';
import 'package:rapido_app/navigation/role_based_navigation.dart';
import 'package:rapido_app/providers/auth_provider.dart';
import 'package:rapido_app/providers/ride_provider.dart';
import 'package:rapido_app/providers/realtime_provider.dart';
import 'package:rapido_app/theme/app_theme.dart';
import 'package:rapido_app/services/notification_service.dart';
import 'package:rapido_app/services/realtime_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize services
  await NotificationService.initialize();
  await RealtimeService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RideProvider()),
        ChangeNotifierProvider(create: (_) => RealtimeProvider()),
      ],
      child: MaterialApp(
        title: 'Rapido Corporate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Force dark theme for Uber-like design
        initialRoute: '/splash',
        onGenerateRoute: RoleBasedRoute.generateRoute,
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/home': (context) => const HomeScreen(),
          '/dashboard': (context) => const DashboardWrapper(),
          '/admin': (context) => const AdminDashboardScreen(),
          '/user': (context) => const UserDashboardScreen(),
        },
      ),
    );
  }
}