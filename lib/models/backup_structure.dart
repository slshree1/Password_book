import 'dart:convert';

class BackupStructure {
  final String version;
  final DateTime backupDate;
  // Key: Category ID, Value: List of Maps (entries)
  final Map<String, List<Map<String, dynamic>>> data;

  BackupStructure({
    this.version = '1.0',
    DateTime? backupDate,
    required this.data,
  }) : backupDate = backupDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'backupDate': backupDate.toIso8601String(),
      'data': data,
    };
  }

  factory BackupStructure.fromMap(Map<String, dynamic> map) {
    return BackupStructure(
      version: map['version'] ?? '1.0',
      backupDate: map['backupDate'] != null
          ? DateTime.parse(map['backupDate'])
          : DateTime.now(),
      data: Map<String, List<Map<String, dynamic>>>.from(
        (map['data'] as Map<String, dynamic>? ?? {}).map((key, value) {
          return MapEntry(key, List<Map<String, dynamic>>.from(value as List));
        }),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BackupStructure.fromJson(String source) =>
      BackupStructure.fromMap(json.decode(source));
}
