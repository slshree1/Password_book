# 🔐 Password Book

A secure, cross-platform password manager built with Flutter. Password Book is a feature-rich application that allows you to safely store, manage, and organize your passwords and sensitive credentials with enterprise-grade encryption.

[![Flutter](https://img.shields.io/badge/Flutter-3.11.1-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20Linux%20%7C%20macOS-brightgreen.svg)]()

---

## ✨ Key Features

### Security & Encryption
- **Master Password Protection**: Secure your vault with a strong master password
- **Advanced Encryption**: Uses `encrypt` and `cryptography` packages for industry-standard AES encryption
- **Secure Storage**: Passwords stored in encrypted format using `flutter_secure_storage`
- **Session Management**: Automatic timeout feature with activity detection to protect against unauthorized access

### Password Management
- **Organize by Categories**: Automatically categorized password entries for better organization
- **Add/Edit/Delete Entries**: Full CRUD operations for password management
- **Search & Filter**: Easily find entries by category
- **Copy to Clipboard**: Quick and secure copy functionality for passwords

### Backup & Recovery
- **Backup Service**: Create encrypted backups of your password database
- **File Import/Export**: Import and export passwords using the file picker
- **Cross-Device Sync**: Backup your data and restore on any device

### User Experience
- **Intuitive Interface**: Clean Material Design 3 interface with support for light and dark modes
- **Responsive Design**: Fully responsive UI that adapts to any screen size
- **Cross-Platform**: Available on Android, iOS, Web, Windows, Linux, and macOS
- **Activity Detection**: Real-time activity tracking for enhanced security

### Additional Features
- **UUID Generation**: Unique identifiers for each entry
- **Localization**: Multi-language support with `intl` package
- **State Management**: Efficient state management using Provider pattern

---

## 🛠️ Tech Stack

### Languages
- **Dart** (50.4%) - Primary language
- **C++** (24.8%) - Native performance
- **CMake** (19.3%) - Build system
- **Swift** (2.4%) - iOS integration
- **Other** (3.0%) - HTML, C

### Core Dependencies
```yaml
flutter: ^3.11.1
provider: ^6.1.5+1          # State management
flutter_secure_storage: ^10.0.0  # Secure credential storage
encrypt: ^5.0.3             # Encryption utilities
cryptography: ^2.9.0        # Cryptographic operations
path_provider: ^2.1.2       # Platform-specific file paths
file_picker: ^10.3.10       # File selection
uuid: ^4.5.3                # Unique identifier generation
intl: ^0.20.2               # Internationalization
```

---

## 📋 Prerequisites

Before running this project, ensure you have:

- **Flutter SDK**: Version 3.11.1 or higher
- **Dart SDK**: Compatible with Flutter 3.11.1
- **Platform Requirements**:
  - **Android**: SDK 21 or higher
  - **iOS**: iOS 11.0 or higher
  - **Windows/Linux/macOS**: Latest supported version

### Installation

1. [Install Flutter](https://flutter.dev/docs/get-started/install)
2. Verify installation:
   ```bash
   flutter doctor
   ```

---

## 🚀 Getting Started

### Clone Repository
```bash
git clone https://github.com/slshree1/Password_book.git
cd Password_book
```

### Install Dependencies
```bash
flutter pub get
```

### Run the Application

**Development Mode:**
```bash
flutter run
```

**Release Mode:**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release

# macOS
flutter build macos --release
```

---

## 📁 Project Structure

```
Password_book/
├── lib/
│   ├── main.dart                          # Application entry point
│   ├── models/                            # Data models
│   │   └── app_category.dart              # Password categories
│   ├── providers/                         # State management
│   │   ├── auth_provider.dart             # Authentication state
│   │   └── password_provider.dart         # Password management state
│   ├── services/                          # Business logic
│   │   ├── auth_service.dart              # Authentication logic
│   │   ├── encryption_service.dart        # Encryption/Decryption
│   │   ├── storage_service.dart           # Data persistence
│   │   └── backup_service.dart            # Backup/Restore operations
│   ├── screens/                           # UI Screens
│   │   ├── auth/                          # Authentication screens
│   │   │   ├── setup_master_password_screen.dart
│   │   │   └── login_screen.dart
│   │   ├── home/                          # Home screen
│   │   │   └── home_screen.dart
│   │   ├── password_entry/                # Password entry screens
│   │   │   └── add_edit_entry_screen.dart
│   │   └── settings/                      # Settings screen
│   │       └── settings_screen.dart
│   └── widgets/                           # Reusable widgets
│       └── entry_list_tile.dart           # Password entry list tile
├── android/                               # Android-specific code
├── ios/                                   # iOS-specific code
├── web/                                   # Web-specific code
├── windows/                               # Windows-specific code
├── linux/                                 # Linux-specific code
├── macos/                                 # macOS-specific code
├── pubspec.yaml                           # Project configuration
└── analysis_options.yaml                  # Linting rules
```

---

## 🔐 Security Features

### Master Password
- Enforced strong password requirements on first launch
- Used to derive encryption keys
- Never stored in plain text

### Encryption Standards
- **Algorithm**: AES (Advanced Encryption Standard)
- **Key Derivation**: Secure key derivation from master password
- **Storage**: All passwords encrypted before storage

### Secure Storage
- Platform-specific secure storage:
  - **Android**: Uses Android Keystore
  - **iOS**: Uses Keychain
- Sensitive data never stored in SharedPreferences

### Session Security
- Automatic timeout after inactivity
- Activity detection on user interaction
- App lifecycle monitoring

---

## 🎨 Architecture

Password Book follows a clean, scalable architecture:

### Layer Breakdown
1. **Presentation Layer** (`screens/`, `widgets/`): UI components
2. **State Management Layer** (`providers/`): Application state using Provider
3. **Services Layer** (`services/`): Business logic and external interactions
4. **Data Layer** (`models/`): Data structures

### Design Patterns
- **Provider Pattern**: State management
- **Service Locator**: Dependency injection
- **Observer Pattern**: App lifecycle management
- **Repository Pattern**: Data access abstraction

---

## 📱 Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Supported | SDK 21+ |
| iOS | ✅ Supported | iOS 11.0+ |
| Web | ✅ Supported | All modern browsers |
| Windows | ✅ Supported | Windows 10+ |
| Linux | ✅ Supported | Ubuntu 20.04+ |
| macOS | ✅ Supported | macOS 10.14+ |

---

## 🧪 Testing

Run tests with:
```bash
flutter test
```

---

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (Google Play)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release --web-renderer html
```

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: Build fails with "CocoaPods could not find compatible versions"
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

**Issue**: Secure storage not working
- Ensure Android/iOS keystore is properly configured
- Check platform-specific security settings

**Issue**: Encryption fails
- Verify cryptography package is correctly installed
- Check Dart version compatibility

---

## 📝 Usage Guide

### First Launch
1. App opens with master password setup screen
2. Enter a strong master password
3. Password is encrypted and stored securely

### Managing Passwords
1. **Add Entry**: Tap the "+" button, select category, enter details
2. **View Entry**: Tap any entry to view details
3. **Edit Entry**: Tap entry, modify details, save
4. **Delete Entry**: Swipe or use delete option in entry details
5. **Copy Password**: Tap copy icon to copy to clipboard

### Backup Data
1. Go to Settings
2. Select "Backup" option
3. Choose backup destination
4. Restore from backup file when needed

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## ⚠️ Security Notice

**Important**: Password Book is provided "as-is" for personal use. While security best practices are implemented, no security software is 100% foolproof. For critical passwords and enterprise use, consider additional security measures.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**slshree1** - [GitHub Profile](https://github.com/slshree1)

---

## 🙏 Acknowledgments

- Flutter community for excellent documentation
- Contributors and testers
- Open-source libraries used in this project

---

## 📞 Support

If you encounter any issues or have questions:

1. Check existing [GitHub Issues](https://github.com/slshree1/Password_book/issues)
2. Create a new issue with detailed information
3. Include device info, Flutter version, and error logs

---

## 🚀 Future Enhancements

Planned features for upcoming releases:
- [ ] Biometric authentication (fingerprint, face recognition)
- [ ] Cloud sync support
- [ ] Password strength analyzer
- [ ] Security audit features
- [ ] Two-factor authentication
- [ ] Browser extension integration
- [ ] Password sharing with secure links

---

**Last Updated**: May 7, 2026

For the latest updates and information, visit the [GitHub Repository](https://github.com/slshree1/Password_book)
