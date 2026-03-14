# Fitness App

FitLife is a Flutter + Firebase fitness tracker with workout execution flows,
progress analytics, profile management, notifications, and support tools.

## Features

- Email/password authentication with optional `Remember Me`
- Google Sign-In (web and mobile flows)
- Workout catalog with category filters (Strength, Cardio, Core, Stretching)
- Exercise detail screen with timer, set/reps tracking, and completion flow
- Automatic stat updates: total workouts, calories burned, and minutes trained
- Progress dashboard backed by Firestore workout logs
- In-app notifications for completed workouts
- Profile editing, including avatar selection from camera/gallery/files
- Light/Dark theme toggle persisted with local preferences
- Help/About screens with external links and support request submission

## Tech Stack

- Flutter (Dart SDK `^3.11.0`)
- Firebase Core + Firebase Auth + Cloud Firestore
- Provider (theme state management)
- Shared Preferences (local session/theme flags)
- Google Sign-In
- Image Picker + Path Provider
- URL Launcher

## Project Structure

```text
lib/
	main.dart                   # App entrypoint and Firebase initialization
	firebase_options.dart       # Generated Firebase config (FlutterFire)
	exercise/                   # Exercise category and detail screens
	pages/                      # Auth, home, profile, settings, progress, etc.
	services/                   # Firestore, shared preferences, theme helpers
images/                       # App image assets
android/ ios/ web/ windows/   # Platform projects
```

## Prerequisites

- Flutter SDK installed and available in PATH
- Dart SDK compatible with project constraint (`^3.11.0`)
- Firebase project configured for your target platforms
- Android Studio/Xcode/VS Code as needed for platform builds

## Firebase Setup

1. Create a Firebase project.
2. Enable providers in Firebase Authentication:
	 - Email/Password
	 - Google
3. Create a Firestore database.
4. Register your app IDs/bundle IDs/package names for each platform.
5. Ensure platform config files are present:
	 - `android/app/google-services.json`
	 - `ios/Runner/GoogleService-Info.plist`
6. Regenerate `lib/firebase_options.dart` if needed:

```bash
flutterfire configure
```

## Firestore Data Model (Expected)

Top-level collections used by the app:

- `users/{uid}`
- `workouts/{workoutId}`
- `supportRequests/{requestId}`

Subcollections under `users/{uid}`:

- `workoutLogs/{logId}`
- `notifications/{notificationId}`

Common user stats fields:

- `totalWorkouts` (number)
- `totalCalories` (number)
- `totalMinutes` (number)

## Getting Started

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Run tests:

```bash
flutter test
```

## Development Notes

- The app starts at `LandingPage` and routes to auth/home flows.
- Theme mode is managed by `ThemeProvider` and persisted via shared preferences.
- Workout completion updates Firestore stats and logs through `DatabaseMethods`.
- Google Sign-In for Android requires SHA fingerprints in Firebase.

## Useful Commands

```bash
flutter analyze
flutter test
flutter pub outdated
```

## Troubleshooting

- If Firebase initialization fails, verify `firebase_options.dart` and platform
	config files.
- If Google Sign-In fails on Android, add SHA-1/SHA-256 in Firebase Console and
	download the latest `google-services.json`.
- If Firestore reads fail, confirm security rules allow the signed-in user
	access to their own documents.

## License

This project currently has no explicit license file.
