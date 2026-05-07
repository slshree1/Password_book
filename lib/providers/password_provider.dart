import 'package:flutter/material.dart';
import '../models/password_entry.dart';
import '../services/storage_service.dart';

class PasswordProvider extends ChangeNotifier {
  final StorageService _storageService;

  // Cache the entries by category ID
  final Map<String, List<PasswordEntry>> _entries = {};

  PasswordProvider(this._storageService);

  List<PasswordEntry> getEntries(String categoryId) {
    return _entries[categoryId] ?? [];
  }

  Future<void> loadCategory(String categoryId) async {
    try {
      final entries = await _storageService.loadEntries(categoryId);
      _entries[categoryId] = entries;
      notifyListeners();
    } catch (e) {
      _entries[categoryId] = [];
      notifyListeners();
    }
  }

  Future<void> loadAllCategories(List<String> categoryIds) async {
    for (final id in categoryIds) {
      await loadCategory(id);
    }
  }

  Future<void> addOrUpdateEntry(PasswordEntry entry) async {
    await _storageService.saveEntry(entry);

    // Update memory cache
    final categoryList = _entries[entry.categoryId] ?? [];
    final index = categoryList.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      categoryList[index] = entry;
    } else {
      categoryList.add(entry);
    }
    _entries[entry.categoryId] = categoryList;

    notifyListeners();
  }

  Future<void> deleteEntry(String categoryId, String entryId) async {
    await _storageService.deleteEntry(categoryId, entryId);

    _entries[categoryId]?.removeWhere((e) => e.id == entryId);
    notifyListeners();
  }

  void clearCache() {
    _entries.clear();
    notifyListeners();
  }
}
