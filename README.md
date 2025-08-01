# Rapido App

A Flutter-based ride-sharing application that connects to the Rapido backend API.

## Project Overview

This mobile application is designed to provide a user-friendly interface for booking rides through the Rapido service. It mimics the UI shown in the reference image but is branded as Rapido.

## Features

- User authentication (login/registration)
- Ride booking
- Ride history
- Profile management

## Backend Integration

This app connects to the Node.js backend API located at `E:\Rapido\backend-api` which provides:

- User authentication endpoints
- Ride booking and management
- Admin functionalities

## Project Structure

```
lib/
├── api/            # API service classes for backend communication
├── models/         # Data models
├── screens/        # UI screens
├── widgets/        # Reusable UI components
├── utils/          # Utility functions and constants
├── theme/          # App theme configuration
└── main.dart       # Application entry point
```

## Getting Started

1. Install Flutter SDK
2. Run `flutter pub get` to install dependencies
3. Ensure the backend API is running
4. Run the app with `flutter run`