# Kazhutha Kali (Donkey Card Game) Frontend

A premium, real-time multiplayer card game frontend built with Flutter, following Clean Architecture guidelines.

## 🛠️ Tech Stack & Architecture
- **State Management:** Riverpod (Notifier & AsyncNotifier)
- **Routing:** GoRouter (with protected route redirects and sub-navigation AppScaffold)
- **Networking:** Dio (HTTP Client) & ActionCable (WebSockets)
- **Local Storage:** Flutter Secure Storage (JWT, tokens)
- **Code Generation:** Freezed (Data Models) & Retrofit / JsonSerializable
- **Theme & Animations:** Glassmorphism, Custom Painters, and Flutter Animate

---

## 🚀 Getting Started

### 1. Prerequisites
Ensure you have the latest stable version of Flutter installed:
```bash
flutter --version
```

### 2. Code Generation
Before running or building the project, generate code dependencies for Freezed and JSON serialization models:
```bash
# Run code generator once
dart run build_runner build --delete-conflicting-outputs

# Or watch for changes during development
dart run build_runner watch --delete-conflicting-outputs
```

---

## ⚙️ Environment Configuration

The application loads environment variables at runtime from the `.env` file located at the root of the project.

#### 1. Setup the `.env` file
Create a `.env` file in the root directory:
```env
BASE_URL=http://192.168.1.42:3000
WS_BASE_URL=ws://192.168.1.42:3000
```

*Note: Change these variables to point to staging or production servers (e.g. `https://api.yourdomain.com` / `wss://api.yourdomain.com`) before building the application.*

---

## 🏃 Run & Build Commands

Since configuration variables are loaded from the `.env` asset, no extra command line parameters are required to configure target URLs. Simply verify that the `.env` file holds the correct URLs before starting the build:

### 1. Running the App (Dev)
```bash
flutter run
```

### 2. Building for Release (Production / Staging)

#### 🤖 Android Build
Compile a split-per-ABI APK or a Google Play App Bundle:
```bash
# Build release APK
flutter build apk --release

# Build release App Bundle (AAB) for Google Play Store upload
flutter build appbundle --release
```

#### 🍏 iOS Build
Prepare an IPA or an archive ready for App Store Connect upload:
```bash
# Build release archive (iOS)
flutter build ipa --release
```

---

## 🧪 Verification & Linting
Ensure all code conforms to style guidelines and test coverage:
```bash
# Check code style and compilation issues
flutter analyze

# Run unit and widget test suite
flutter test
```
