import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/screens/splash_screen.dart';
import 'package:rapido_app/screens/login_screen.dart';
import 'package:rapido_app/screens/home_screen.dart';
import 'package:rapido_app/screens/registration_screen.dart';
import 'package:rapido_app/providers/auth_provider.dart';
import 'package:rapido_app/providers/ride_provider.dart';
import 'package:rapido_app/theme/app_theme.dart';

void main() {
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
      ],
      child: MaterialApp(
        title: 'Rapido',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}