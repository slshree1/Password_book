import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/backup_service.dart';
import '../../widgets/password_input_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _changeMasterPassword() async {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    String? errorMessage;

    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Change Master Password'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    PasswordInputField(
                      controller: oldPasswordController,
                      labelText: 'Old Password',
                    ),
                    SizedBox(height: size.height * 0.02),
                    PasswordInputField(
                      controller: newPasswordController,
                      labelText: 'New Password',
                      validator: (v) {
                        if (v == null || v.length < 6)
                          return 'At least 6 characters';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (isSmallScreen) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final success = await context
                            .read<AuthProvider>()
                            .changeMasterPassword(
                              oldPasswordController.text,
                              newPasswordController.text,
                            );
                        if (success) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password changed successfully'),
                              ),
                            );
                          }
                        } else {
                          setState(() {
                            errorMessage = 'Old password incorrect';
                          });
                        }
                      }
                    },
                    child: const Text('Change'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ] else ...[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final success = await context
                          .read<AuthProvider>()
                          .changeMasterPassword(
                            oldPasswordController.text,
                            newPasswordController.text,
                          );
                      if (success) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password changed successfully'),
                            ),
                          );
                        }
                      } else {
                        setState(() {
                          errorMessage = 'Old password incorrect';
                        });
                      }
                    }
                  },
                  child: const Text('Change'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _createBackup() async {
    final backupService = context.read<BackupService>();
    try {
      final path = await backupService.createBackup();
      if (!mounted) return;
      if (path != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup saved to $path')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to backup: $e')));
    }
  }

  Future<void> _restoreBackup() async {
    final backupService = context.read<BackupService>();
    try {
      final success = await backupService.restoreBackup();
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup restored successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to restore: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Change Master Password'),
                onTap: _changeMasterPassword,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Create Backup'),
                subtitle: const Text('Export an encrypted backup file'),
                onTap: _createBackup,
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Restore Backup'),
                subtitle: const Text('Import an encrypted backup file'),
                onTap: _restoreBackup,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Lock Vault',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
