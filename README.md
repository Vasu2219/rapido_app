# Rapido Corporate Mobile App

A Flutter-based mobile application for the Rapido Corporate Ride Booking System with real-time features, Uber-like design, and seamless backend integration.

## 🚀 Features

### Core Features
- **User Authentication** with JWT tokens
- **Real-time Ride Updates** via WebSocket connections
- **Ride Booking** with multiple service types
- **Live Notifications** for ride status changes
- **Admin Approval Workflow** integration
- **Ride History & Activity** tracking

### UI/UX Features
- **Dark Theme** matching Uber's design language
- **Smooth Animations** and transitions
- **Responsive Design** for all screen sizes
- **Intuitive Navigation** with bottom tabs
- **Modern Card-based Layout**

### Real-time Features
- **WebSocket Integration** for live updates
- **Push Notifications** for ride status changes
- **Live Connection Status** indicator
- **Real-time Ride Tracking**
- **Instant Admin Actions** reflection

## 📱 Screens

### 1. Home Screen
- Search bar with "Where to?" functionality
- Service cards (Trip, Intercity, Reserve, Rentals)
- Promotional banner with offers
- Recent destinations
- Bottom navigation

### 2. Services Screen
- Featured service cards
- Complete service catalog
- Service-specific booking flows

### 3. Activity Screen
- Upcoming rides section
- Past rides history
- Filter and sort options
- Real-time status updates

### 4. Account Screen
- User profile information
- Settings and preferences
- Account management options
- Logout functionality

### 5. Ride Booking Screen
- Multi-step booking process
- Location selection
- Schedule time picker
- Service type selection
- Real-time fare estimation

## 🛠 Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider + ChangeNotifier
- **Real-time**: WebSocket Channel
- **HTTP Client**: Dio
- **Local Storage**: Shared Preferences + Secure Storage
- **Notifications**: Flutter Local Notifications
- **UI Components**: Custom widgets with Material Design
- **Animations**: Flutter Staggered Animations
- **Date/Time**: Intl package

## 📋 Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 2.17 or higher
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)
- Backend API running (see backend-api README)

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd rapido-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Update `lib/services/realtime_service.dart` with your WebSocket URL
   - Update API endpoints in providers if needed

4. **Run the app**
   ```bash
   # For Android
   flutter run
   
   # For iOS (macOS only)
   flutter run -d ios
   ```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
# API Configuration
API_BASE_URL=http://localhost:5000
WS_BASE_URL=ws://localhost:5000

# App Configuration
APP_NAME=Rapido Corporate
APP_VERSION=1.0.0
```

### Backend Integration
Ensure your backend API is running and accessible. The app expects:
- REST API endpoints for authentication and ride management
- WebSocket server for real-time updates
- JWT token-based authentication

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
│   ├── home_screen.dart      # Main home screen
│   ├── services_screen.dart  # Services catalog
│   ├── activity_screen.dart  # Ride history
│   ├── account_screen.dart   # User account
│   └── ride_booking_screen.dart # Booking flow
├── widgets/                  # Reusable UI components
│   ├── service_card.dart     # Service option cards
│   ├── ride_card.dart        # Ride information cards
│   ├── promotional_banner.dart # Promotional content
│   └── connection_status_bar.dart # Real-time status
├── providers/                # State management
│   ├── auth_provider.dart    # Authentication state
│   ├── ride_provider.dart    # Ride management
│   └── realtime_provider.dart # Real-time updates
├── services/                 # Business logic
│   ├── realtime_service.dart # WebSocket handling
│   └── notification_service.dart # Push notifications
├── models/                   # Data models
├── theme/                    # App theming
└── navigation/               # Navigation logic
```

## 🔌 Real-time Features

### WebSocket Integration
The app maintains a persistent WebSocket connection for:
- Live ride status updates
- Admin approval/rejection notifications
- Driver assignment updates
- Real-time fare changes

### Notification System
- **Ride Status**: Approval, rejection, completion
- **Driver Updates**: Assignment, arrival, departure
- **Promotional**: Offers and deals
- **System**: Connection status, errors

### Connection Management
- Automatic reconnection on disconnection
- Connection status indicator
- Graceful error handling
- Token-based authentication

## 🎨 UI/UX Design

### Design Principles
- **Dark Theme**: Consistent with modern ride-sharing apps
- **Card-based Layout**: Clean, organized information display
- **Smooth Animations**: Enhanced user experience
- **Intuitive Navigation**: Easy-to-use interface

### Color Scheme
- **Primary**: Black (#000000)
- **Accent**: Green (#00C853)
- **Background**: Dark Gray (#121212)
- **Cards**: Light Dark (#1E1E1E)
- **Text**: White (#FFFFFF)
- **Secondary Text**: Light Gray (#B3B3B3)

## 🔐 Security Features

- **JWT Token Authentication**
- **Secure Storage** for sensitive data
- **Token Refresh** mechanism
- **Input Validation** and sanitization
- **HTTPS/WSS** for API communication

## 📊 Performance Optimizations

- **Lazy Loading** for ride history
- **Image Caching** with cached_network_image
- **Efficient State Management** with Provider
- **Memory Management** with proper disposal
- **Background Processing** for notifications

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🚀 Deployment

### Android
1. Generate signed APK
2. Upload to Google Play Console
3. Configure app signing

### iOS
1. Archive the app in Xcode
2. Upload to App Store Connect
3. Configure app distribution

## 🔧 Troubleshooting

### Common Issues

1. **WebSocket Connection Failed**
   - Check backend server is running
   - Verify WebSocket URL configuration
   - Check network connectivity

2. **Build Errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Check Flutter version compatibility

3. **Real-time Updates Not Working**
   - Verify WebSocket server is accessible
   - Check authentication token
   - Review network permissions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔄 Version History

- **v1.0.0**: Initial release with core features
- Real-time ride updates
- Uber-like UI design
- Complete booking workflow
- Admin integration

---

**Note**: This app requires the Rapido Corporate Backend API to be running for full functionality. See the backend-api README for setup instructions.