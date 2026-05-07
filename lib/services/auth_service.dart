import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'encryption_service.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final EncryptionService _encryptionService;

  static const String _hashKey = 'master_password_hash';
  static const String _saltKey = 'master_password_salt';

  AuthService(this._encryptionService);

  Future<bool> isFirstLaunch() async {
    final hash = await _secureStorage.read(key: _hashKey);
    return hash == null;
  }

  Future<void> setMasterPassword(String password) async {
    final salt = const Uuid().v4();
    final saltedHash = await _hashPassword(password, salt);

    await _secureStorage.write(key: _saltKey, value: salt);
    await _secureStorage.write(key: _hashKey, value: saltedHash);

    await _encryptionService.deriveKey(password, salt);
  }

  Future<bool> login(String password) async {
    final storedHash = await _secureStorage.read(key: _hashKey);
    final salt = await _secureStorage.read(key: _saltKey);

    if (storedHash == null || salt == null) return false;

    final hashToVerify = await _hashPassword(password, salt);
    if (hashToVerify == storedHash) {
      await _encryptionService.deriveKey(password, salt);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _encryptionService.clearKey();
  }

  Future<String> _hashPassword(String password, String salt) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );
    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: utf8.encode(salt),
    );
    final keyBytes = await secretKey.extractBytes();
    return base64Encode(keyBytes);
  }
}
