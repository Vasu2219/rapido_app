import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/providers/auth_provider.dart';
import 'package:rapido_app/theme/app_theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: const Text(
          'Account',
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
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(user),
                const SizedBox(height: 24),
                
                // Menu Options
                _buildMenuOptions(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Row(
      children: [
        // Profile Avatar
        CircleAvatar(
          radius: 30,
          backgroundColor: AppTheme.cardColor,
          child: Text(
            user?.firstName?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(
              color: AppTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user?.firstName ?? 'User'} ${user?.lastName ?? ''}',
                style: const TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '5.0',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () {
            // Navigate to settings
          },
        ),
        
        _buildMenuItem(
          icon: Icons.phone_android,
          title: 'Simple mode',
          subtitle: 'A simplified app for older adults',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'NEW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            // Navigate to simple mode
          },
        ),
        
        _buildMenuItem(
          icon: Icons.umbrella,
          title: 'Rider insurance',
          subtitle: '₹10L cover for ₹3/trip',
          onTap: () {
            // Navigate to insurance
          },
        ),
        
        _buildMenuItem(
          icon: Icons.email,
          title: 'Messages',
          onTap: () {
            // Navigate to messages
          },
        ),
        
        _buildMenuItem(
          icon: Icons.card_giftcard,
          title: 'Send a gift',
          onTap: () {
            // Navigate to gift
          },
        ),
        
        _buildMenuItem(
          icon: Icons.star,
          title: 'Rapido One',
          subtitle: 'Earn up to 10% Rapido One credits on rides',
          onTap: () {
            // Navigate to Rapido One
          },
        ),
        
        _buildMenuItem(
          icon: Icons.delivery_dining,
          title: 'Earn by driving or delivering',
          onTap: () {
            // Navigate to driver signup
          },
        ),
        
        _buildMenuItem(
          icon: Icons.group,
          title: 'Saved groups',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'NEW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            // Navigate to saved groups
          },
        ),
        
        _buildMenuItem(
          icon: Icons.business,
          title: 'Set up your business profile',
          subtitle: 'Automate work travel & meal expenses',
          onTap: () {
            // Navigate to business profile
          },
        ),
        
        _buildMenuItem(
          icon: Icons.account_circle,
          title: 'Manage Rapido account',
          onTap: () {
            // Navigate to account management
          },
        ),
        
        const SizedBox(height: 24),
        
        // Logout Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.textColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: trailing ?? const Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.secondaryTextColor,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'Logout',
          style: TextStyle(color: AppTheme.textColor),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppTheme.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.secondaryTextColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
} 