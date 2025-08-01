import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapido_app/providers/ride_provider.dart';
import 'package:rapido_app/providers/realtime_provider.dart';
import 'package:rapido_app/theme/app_theme.dart';
import 'package:intl/intl.dart';

class RideBookingScreen extends StatefulWidget {
  final String serviceType;

  const RideBookingScreen({
    Key? key,
    required this.serviceType,
  }) : super(key: key);

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  final _purposeController = TextEditingController();
  final _requirementsController = TextEditingController();
  
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
  bool _isLoading = false;

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    _purposeController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Book ${_getServiceTitle()}',
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Type Card
              _buildServiceTypeCard(),
              const SizedBox(height: 24),
              
              // Pickup Location
              _buildLocationField(
                controller: _pickupController,
                label: 'Pickup Location',
                icon: Icons.my_location,
                color: Colors.green,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pickup location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Drop Location
              _buildLocationField(
                controller: _dropController,
                label: 'Drop Location',
                icon: Icons.location_on,
                color: Colors.red,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter drop location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Schedule Time
              _buildScheduleSection(),
              const SizedBox(height: 24),
              
              // Purpose
              _buildTextField(
                controller: _purposeController,
                label: 'Purpose of Travel',
                hint: 'e.g., Client meeting, Airport pickup',
                icon: Icons.work,
              ),
              const SizedBox(height: 16),
              
              // Special Requirements
              _buildTextField(
                controller: _requirementsController,
                label: 'Special Requirements',
                hint: 'e.g., AC car, Extra luggage space',
                icon: Icons.info,
              ),
              const SizedBox(height: 32),
              
              // Book Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _bookRide,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Book Ride',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTypeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getServiceColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getServiceIcon(),
              color: _getServiceColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getServiceTitle(),
                  style: const TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getServiceDescription(),
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(color: AppTheme.textColor),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: AppTheme.secondaryTextColor),
            prefixIcon: Icon(icon, color: color),
            filled: true,
            fillColor: AppTheme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.accentColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule Time',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDateTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor, width: 1),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDateTime),
                        style: const TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('hh:mm a').format(_selectedDateTime),
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.secondaryTextColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: AppTheme.textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.secondaryTextColor),
            prefixIcon: Icon(icon, color: AppTheme.secondaryTextColor),
            filled: true,
            fillColor: AppTheme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.accentColor),
            ),
          ),
        ),
      ],
    );
  }

  String _getServiceTitle() {
    switch (widget.serviceType) {
      case 'trip':
        return 'Trip';
      case 'intercity':
        return 'Intercity';
      case 'reserve':
        return 'Reserve';
      case 'rentals':
        return 'Rentals';
      case 'teens':
        return 'Teens';
      case 'corporate':
        return 'Corporate';
      default:
        return 'Ride';
    }
  }

  String _getServiceDescription() {
    switch (widget.serviceType) {
      case 'trip':
        return 'Quick rides around the city';
      case 'intercity':
        return 'Long distance travel between cities';
      case 'reserve':
        return 'Book rides in advance';
      case 'rentals':
        return 'Hourly or daily car rentals';
      case 'teens':
        return 'Safe rides for teenagers';
      case 'corporate':
        return 'Business travel solutions';
      default:
        return 'Book your ride';
    }
  }

  IconData _getServiceIcon() {
    switch (widget.serviceType) {
      case 'trip':
        return Icons.directions_car;
      case 'intercity':
        return Icons.flight;
      case 'reserve':
        return Icons.schedule;
      case 'rentals':
        return Icons.access_time;
      case 'teens':
        return Icons.school;
      case 'corporate':
        return Icons.business;
      default:
        return Icons.directions_car;
    }
  }

  Color _getServiceColor() {
    switch (widget.serviceType) {
      case 'trip':
        return Colors.green;
      case 'intercity':
        return Colors.blue;
      case 'reserve':
        return Colors.orange;
      case 'rentals':
        return Colors.purple;
      case 'teens':
        return Colors.red;
      case 'corporate':
        return Colors.indigo;
      default:
        return AppTheme.accentColor;
    }
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.accentColor,
              onPrimary: Colors.white,
              surface: AppTheme.cardColor,
              onSurface: AppTheme.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppTheme.accentColor,
                onPrimary: Colors.white,
                surface: AppTheme.cardColor,
                onSurface: AppTheme.textColor,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _bookRide() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final rideProvider = Provider.of<RideProvider>(context, listen: false);
      final realtimeProvider = Provider.of<RealtimeProvider>(context, listen: false);

      // Create ride request
      final rideData = {
        'pickupLocation': _pickupController.text,
        'dropLocation': _dropController.text,
        'scheduleTime': _selectedDateTime.toIso8601String(),
        'purpose': _purposeController.text,
        'specialRequirements': _requirementsController.text,
        'serviceType': widget.serviceType,
      };

      final success = await rideProvider.createRide(rideData);

      if (success) {
        // Subscribe to real-time updates for the new ride
        if (rideProvider.rides.isNotEmpty) {
          final newRide = rideProvider.rides.first;
          realtimeProvider.subscribeToRide(newRide.id);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Ride booked successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to book ride: ${rideProvider.error}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 