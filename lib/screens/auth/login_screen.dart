import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/password_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await context.read<AuthProvider>().login(
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    if (!success) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Incorrect master password';
      });
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
                        Icons.lock,
                        size: iconSize.clamp(48.0, 80.0),
                        color: Colors.blue,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Unlock Vault',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontSize: (size.width * 0.06).clamp(18.0, 24.0),
                            ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      if (_errorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.02),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: (size.width * 0.035).clamp(12.0, 16.0),
                            ),
                          ),
                        ),
                      PasswordInputField(
                        controller: _passwordController,
                        labelText: 'Master Password',
                      ),
                      SizedBox(height: size.height * 0.04),
                      SizedBox(
                        width: double.infinity,
                        height: (size.height * 0.06).clamp(
                          48.0,
                          60.0,
                        ), // Responsive height
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? SizedBox(
                                  height: (size.width * 0.05).clamp(16.0, 24.0),
                                  width: (size.width * 0.05).clamp(16.0, 24.0),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Unlock',
                                  style: TextStyle(
                                    fontSize: (size.width * 0.04).clamp(
                                      14.0,
                                      18.0,
                                    ),
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
