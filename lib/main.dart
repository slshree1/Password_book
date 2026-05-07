import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/password_provider.dart';
import 'services/auth_service.dart';
import 'services/backup_service.dart';
import 'services/encryption_service.dart';
import 'services/storage_service.dart';
import 'screens/auth/setup_master_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final encryptionService = EncryptionService();
  final authService = AuthService(encryptionService);
  final storageService = StorageService(encryptionService);
  final backupService = BackupService(encryptionService, storageService);

  runApp(
    MultiProvider(
      providers: [
        Provider<EncryptionService>.value(value: encryptionService),
        Provider<StorageService>.value(value: storageService),
        Provider<BackupService>.value(value: backupService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, storageService),
        ),
        ChangeNotifierProvider(create: (_) => PasswordProvider(storageService)),
      ],
      child: const PasswordBookApp(),
    ),
  );
}

class PasswordBookApp extends StatefulWidget {
  const PasswordBookApp({super.key});

  @override
  State<PasswordBookApp> createState() => _PasswordBookAppState();
}

class _PasswordBookAppState extends State<PasswordBookApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AuthProvider>().userActivityDetected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthProvider>().userActivityDetected();
        FocusScope.of(context).unfocus();
      },
      onPanDown: (_) => context.read<AuthProvider>().userActivityDetected(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Password Book',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isFirstLaunch) {
              return const SetupMasterPasswordScreen();
            } else if (!authProvider.isAuthenticated) {
              return const LoginScreen();
            } else {
              return const HomeScreen();
            }
          },
        ),
      ),
    );
  }
}
