import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_category.dart';
import '../../models/password_entry.dart';
import '../../providers/password_provider.dart';
import '../../widgets/password_input_field.dart';

class AddEditEntryScreen extends StatefulWidget {
  final AppCategory category;
  final PasswordEntry? entry;

  const AddEditEntryScreen({super.key, required this.category, this.entry});

  @override
  State<AddEditEntryScreen> createState() => _AddEditEntryScreenState();
}

class _AddEditEntryScreenState extends State<AddEditEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;
  final Map<String, TextEditingController> _customControllers = {};

  final Map<AppCategory, List<String>> _categoryFields = {
    AppCategory.onlinePlatforms: ['Email / Username', 'Account Name'],
    AppCategory.applications: ['App Name', 'Username'],
    AppCategory.banking: ['Bank Name', 'Account Number', 'Routing Number'],
    AppCategory.socialEmail: ['Platform', 'Email'],
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _passwordController = TextEditingController(
      text: widget.entry?.password ?? '',
    );
    _notesController = TextEditingController(text: widget.entry?.notes ?? '');

    final fields = _categoryFields[widget.category] ?? [];
    for (var field in fields) {
      _customControllers[field] = TextEditingController(
        text: widget.entry?.customFields[field] ?? '',
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    for (var c in _customControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final customFields = <String, String>{};
    _customControllers.forEach((key, controller) {
      customFields[key] = controller.text.trim();
    });

    final newEntry = PasswordEntry(
      id: widget.entry?.id,
      categoryId: widget.category.id,
      title: _titleController.text.trim(),
      password: _passwordController.text,
      notes: _notesController.text.trim(),
      customFields: customFields,
    );

    await context.read<PasswordProvider>().addOrUpdateEntry(newEntry);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    if (widget.entry == null) return;

    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          // Responsive dialog buttons: stack on small screens, row on larger ones
          if (isSmallScreen) ...[
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
            ),
          ] else ...[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<PasswordProvider>().deleteEntry(
        widget.category.id,
        widget.entry!.id,
      );
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = _categoryFields[widget.category] ?? [];

    // UI responsiveness variables
    final size = MediaQuery.of(context).size;
    final paddingH = size.width * 0.04;
    final paddingV = size.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Add Entry' : 'Edit Entry'),
        actions: [
          if (widget.entry != null)
            IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: paddingH,
            vertical: paddingV,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title / Identifier',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Required'
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),

                  ...fields.map((field) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.02),
                      child: TextFormField(
                        controller: _customControllers[field],
                        decoration: InputDecoration(
                          labelText: field,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    );
                  }),

                  PasswordInputField(
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Required' : null,
                  ),
                  SizedBox(height: size.height * 0.02),

                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: size.height * 0.04),

                  SizedBox(
                    height: (size.height * 0.06).clamp(48.0, 60.0),
                    child: ElevatedButton(
                      onPressed: _save,
                      child: Text(
                        'Save Entry',
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
    );
  }
}
