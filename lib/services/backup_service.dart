import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../models/app_category.dart';
import '../models/backup_structure.dart';
import '../models/password_entry.dart';
import 'encryption_service.dart';
import 'storage_service.dart';

class BackupService {
  final EncryptionService _encryptionService;
  final StorageService _storageService;

  BackupService(this._encryptionService, this._storageService);

  Future<String?> createBackup() async {
    try {
      final Map<String, List<Map<String, dynamic>>> allData = {};

      for (var category in AppCategory.values) {
        final entries = await _storageService.loadEntries(category.id);
        allData[category.id] = entries.map((e) => e.toMap()).toList();
      }

      final backupStructure = BackupStructure(data: allData);
      final jsonString = backupStructure.toJson();

      final encryptedBackup = _encryptionService.encrypt(jsonString);
      final Uint8List encryptedBytes = Uint8List.fromList(utf8.encode(encryptedBackup));

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: 'passwords_backup.enc',
        type: FileType.custom,
        allowedExtensions: ['enc'],
        bytes: encryptedBytes,
      );

      if (outputFile == null) {
        return null; // User canceled
      }

      final backupFile = File(outputFile);
      await backupFile.writeAsBytes(encryptedBytes);
      return backupFile.path;
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  Future<bool> restoreBackup() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['enc'],
      );

      if (result == null || result.files.single.path == null) {
        return false;
      }

      final backupFile = File(result.files.single.path!);
      final encryptedBackup = await backupFile.readAsString();

      final decryptedJson = _encryptionService.decrypt(encryptedBackup);
      final backupStructure = BackupStructure.fromJson(decryptedJson);

      for (var categoryId in backupStructure.data.keys) {
        final entriesList = backupStructure.data[categoryId]!;
        final decodedEntries = entriesList
            .map((e) => PasswordEntry.fromMap(e))
            .toList();
        await _storageService.saveEntries(categoryId, decodedEntries);
      }

      return true;
    } catch (e) {
      throw Exception('Failed to restore backup: $e');
    }
  }
}
