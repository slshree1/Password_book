import 'package:flutter/material.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const PasswordInputField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.validator,
    this.onChanged,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: TextStyle(fontSize: (size.width * 0.04).clamp(14.0, 18.0)),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(fontSize: (size.width * 0.035).clamp(12.0, 16.0)),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            size: (size.width * 0.06).clamp(20.0, 24.0),
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
