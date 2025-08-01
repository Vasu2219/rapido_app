import 'package:flutter/material.dart';
import 'package:rapido_app/api/api_service.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({Key? key}) : super(key: key);

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  final ApiService _apiService = ApiService();
  final List<String> _testResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runConnectionTests();
  }

  Future<void> _runConnectionTests() async {
    setState(() {
      _isLoading = true;
      _testResults.clear();
    });

    // Test 1: Health Check
    _addResult('🔍 Testing API Connection...');
    try {
      final response = await _apiService.testConnection();
      if (response) {
        _addResult('✅ Health Check: SUCCESS');
      } else {
        _addResult('❌ Health Check: FAILED');
      }
    } catch (e) {
      _addResult('❌ Health Check: ERROR - $e');
    }

    // Test 2: Registration Test
    _addResult('\n🔍 Testing Registration...');
    try {
      final testUser = {
        'firstName': 'Test',
        'lastName': 'User',
        'email': 'test${DateTime.now().millisecondsSinceEpoch}@example.com',
        'password': 'TestPass123!',
        'phone': '9876543210',
        'employeeId': 'EMP${DateTime.now().millisecondsSinceEpoch}',
        'department': 'Engineering',
      };
      
      final result = await _apiService.register(testUser);
      if (result['success'] == true) {
        _addResult('✅ Registration: SUCCESS');
        _addResult('   User: ${result['data']['user']['firstName']} ${result['data']['user']['lastName']}');
      } else {
        _addResult('❌ Registration: FAILED - ${result['message']}');
      }
    } catch (e) {
      _addResult('❌ Registration: ERROR - $e');
    }

    // Test 3: Login Test with Admin
    _addResult('\n🔍 Testing Admin Login...');
    try {
      final result = await _apiService.login('admin@rapido.com', 'Admin@123');
      if (result['success'] == true) {
        _addResult('✅ Login: SUCCESS');
        if (result['data'] != null && result['data']['token'] != null) {
          _addResult('   Token: ${result['data']['token'].toString().substring(0, 20)}...');
          _addResult('   User: ${result['data']['user']['firstName']} ${result['data']['user']['lastName']}');
        } else {
          _addResult('   Response: ${result['message']}');
        }
      } else {
        _addResult('❌ Login: FAILED - ${result['message']}');
      }
    } catch (e) {
      _addResult('❌ Login: ERROR - $e');
    }

    // Test 4: Get All Rides
    _addResult('\n🔍 Testing Get Rides...');
    try {
      final rides = await _apiService.getAllRides();
      _addResult('✅ Get Rides: SUCCESS');
      _addResult('   Total Rides: ${rides.length}');
    } catch (e) {
      _addResult('❌ Get Rides: ERROR - $e');
    }

    // Test 5: Book Ride
    _addResult('\n🔍 Testing Book Ride...');
    try {
      final rideData = {
        'pickupLocation': 'Test Pickup Location - Flutter',
        'dropLocation': 'Test Drop Location - Flutter',
        'scheduledTime': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
      };
      
      final result = await _apiService.bookRide(rideData);
      if (result['success'] == true) {
        _addResult('✅ Book Ride: SUCCESS');
        _addResult('   Ride ID: ${result['data']['ride']['_id']}');
      } else {
        _addResult('❌ Book Ride: FAILED - ${result['message']}');
      }
    } catch (e) {
      _addResult('❌ Book Ride: ERROR - $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _addResult(String result) {
    setState(() {
      _testResults.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Connection Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔧 Backend Configuration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Base URL: ${ApiService.baseUrl}'),
                  const Text('Admin Email: admin@rapido.com'),
                  const Text('Admin Password: Admin@123'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Test Results',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  ElevatedButton(
                    onPressed: _runConnectionTests,
                    child: const Text('Re-test'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResults.join('\n'),
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
