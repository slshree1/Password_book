import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/password_input_field.dart';

class SetupMasterPasswordScreen extends StatefulWidget {
  const SetupMasterPasswordScreen({super.key});

  @override
  State<SetupMasterPasswordScreen> createState() =>
      _SetupMasterPasswordScreenState();
}

class _SetupMasterPasswordScreenState extends State<SetupMasterPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthProvider>().setMasterPassword(
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsiveness calculations
    final size = MediaQuery.of(context).size;
    final paddingH = size.width * 0.04;
    final paddingV = size.height * 0.02;
    final iconSize = size.height * 0.08;

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Password Book')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: paddingH,
            vertical: paddingV,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: paddingH * 1.5,
                  vertical: paddingV * 1.5,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.security,
                        size: iconSize.clamp(48.0, 80.0),
                        color: Colors.blue,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Set Master Password',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontSize: (size.width * 0.06).clamp(18.0, 24.0),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        'This password will be used to encrypt all your data locally. If you lose it, your data cannot be recovered.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: (size.width * 0.035).clamp(12.0, 16.0),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      PasswordInputField(
                        controller: _passwordController,
                        labelText: 'Master Password',
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter a password';
                          if (value.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      PasswordInputField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        validator: (value) {
                          if (value != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.04),
                      SizedBox(
                        width: double.infinity,
                        height: (size.height * 0.06).clamp(
                          48.0,
                          60.0,
                        ), // Responsive button height
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(
                            'Save and Continue',
                            style: TextStyle(
                              fontSize: (size.width * 0.04).clamp(14.0, 18.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
