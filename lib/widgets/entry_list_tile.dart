import 'package:flutter/material.dart';
import '../models/password_entry.dart';

class EntryListTile extends StatefulWidget {
  final PasswordEntry entry;
  final VoidCallback onTap;

  const EntryListTile({super.key, required this.entry, required this.onTap});

  @override
  State<EntryListTile> createState() => _EntryListTileState();
}

class _EntryListTileState extends State<EntryListTile> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    // Relative margins instead of hardcoded
    final size = MediaQuery.of(context).size;
    final marginV = size.height * 0.005;

    return Card(
      margin: EdgeInsets.symmetric(vertical: marginV),
      child: ListTile(
        title: Text(
          widget.entry.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: (size.width * 0.04).clamp(14.0, 18.0),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _showPassword ? widget.entry.password : '••••••••',
          style: TextStyle(fontSize: (size.width * 0.035).clamp(12.0, 16.0)),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: widget.onTap,
        trailing: IconButton(
          icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      ),
    );
  }
}
