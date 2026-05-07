import 'dart:convert';
import 'package:uuid/uuid.dart';

class PasswordEntry {
  final String id;
  final String categoryId;
  final String title;
  final String password;
  final String notes;
  final DateTime lastModified;
  final Map<String, String> customFields;

  PasswordEntry({
    String? id,
    required this.categoryId,
    required this.title,
    required this.password,
    this.notes = '',
    DateTime? lastModified,
    this.customFields = const {},
  }) : id = id ?? const Uuid().v4(),
       lastModified = lastModified ?? DateTime.now();

  PasswordEntry copyWith({
    String? categoryId,
    String? title,
    String? password,
    String? notes,
    DateTime? lastModified,
    Map<String, String>? customFields,
  }) {
    return PasswordEntry(
      id: id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      password: password ?? this.password,
      notes: notes ?? this.notes,
      lastModified: lastModified ?? DateTime.now(),
      customFields: customFields ?? this.customFields,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'password': password,
      'notes': notes,
      'lastModified': lastModified.toIso8601String(),
      'customFields': customFields,
    };
  }

  factory PasswordEntry.fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'] ?? '',
      categoryId: map['categoryId'] ?? '',
      title: map['title'] ?? '',
      password: map['password'] ?? '',
      notes: map['notes'] ?? '',
      lastModified: map['lastModified'] != null
          ? DateTime.parse(map['lastModified'])
          : DateTime.now(),
      customFields: Map<String, String>.from(map['customFields'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordEntry.fromJson(String source) =>
      PasswordEntry.fromMap(json.decode(source));
}
