# QR Nova (Flutter)

A light lavender/blue QR scanner and QR generator app, organized into separate Dart files.

## Features
- Scan QR codes with the camera (camera permission is included in AndroidManifest.xml).
- Pick a QR image from the gallery and scan it.
- Generate QR codes for text, URLs, Wi-Fi credentials, and email addresses.
- Save generated QR PNGs in the app's documents directory and share them.
- Recent scan/generation history (in-memory; resets when the app process is restarted).
- Settings and creator information screens.

## Setup
1. Open this project folder in your Flutter IDE or terminal.
2. Run `flutter pub get`.
3. Optional: replace `assets/shivendra.jpg` with your own profile photo, keeping the same filename.
4. Run `flutter run` on an Android device. Accept the camera permission when prompted.
5. To build: `flutter build apk --release`.

## Notes
- The included `assets/shivendra.jpg` is a generic placeholder avatar because a personal profile photo was not included in the uploaded project.
- Save currently writes QR PNG files to the app's private documents directory, not directly to the public gallery.
- History is stored in memory only and is cleared when the app process restarts.
- A Flutter SDK was not available in the editing environment, so the project could not be compiled here. Run `flutter pub get`, `flutter analyze`, and `flutter build apk --release` locally to validate against your installed Flutter SDK.
