import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/providers/realtime_provider.dart';
import 'package:rapido_app/theme/app_theme.dart';

class ConnectionStatusBar extends StatelessWidget {
  const ConnectionStatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RealtimeProvider>(
      builder: (context, realtimeProvider, child) {
        if (realtimeProvider.isConnected) {
          return const SizedBox.shrink(); // Hide when connected
        }
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(color: Colors.orange.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.wifi_off,
                color: Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Connecting to real-time updates...',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 