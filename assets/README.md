# Assets Directory

This directory contains all the static assets used in the Rapido app.

## Structure

- `images/`: Contains all image assets used in the app
- `icons/`: Contains icon assets
- `fonts/`: Contains font files

## Usage

All assets are referenced in the `pubspec.yaml` file and can be accessed in the code using the `AssetImage` or similar widgets.

Example:

```dart
Image.asset('assets/images/logo.png')
```

Make sure to add any new assets to the pubspec.yaml file under the assets section.