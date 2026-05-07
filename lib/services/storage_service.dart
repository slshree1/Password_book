import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/password_entry.dart';
import 'encryption_service.dart';

class StorageService {
  final EncryptionService _encryptionService;

  StorageService(this._encryptionService);

  Future<File> _getFile(String categoryId) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/${categoryId}_data.enc');
  }

  Future<List<PasswordEntry>> loadEntries(String categoryId) async {
    try {
      final file = await _getFile(categoryId);
      if (!await file.exists()) {
        return [];
      }

      final encryptedString = await file.readAsString();
      if (encryptedString.isEmpty) return [];

      final decryptedString = _encryptionService.decrypt(encryptedString);
      final List<dynamic> jsonList = json.decode(decryptedString);

      return jsonList.map((e) => PasswordEntry.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Failed to load entries: $e');
    }
  }

  Future<void> saveEntries(
    String categoryId,
    List<PasswordEntry> entries,
  ) async {
    final file = await _getFile(categoryId);

    final jsonList = entries.map((e) => e.toMap()).toList();
    final jsonString = json.encode(jsonList);

    final encryptedString = _encryptionService.encrypt(jsonString);
    await file.writeAsString(encryptedString);
  }

  Future<void> saveEntry(PasswordEntry entry) async {
    final entries = await loadEntries(entry.categoryId);
    final index = entries.indexWhere((e) => e.id == entry.id);

    if (index >= 0) {
      entries[index] = entry;
    } else {
      entries.add(entry);
    }

    await saveEntries(entry.categoryId, entries);
  }

  Future<void> deleteEntry(String categoryId, String entryId) async {
    final entries = await loadEntries(categoryId);
    entries.removeWhere((e) => e.id == entryId);
    await saveEntries(categoryId, entries);
  }
}
