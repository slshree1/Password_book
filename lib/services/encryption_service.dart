import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;

class EncryptionService {
  enc.Key? _key;
  static const int _iterations = 100000;
  static const int _keyLength = 32; // 256 bits

  bool get isKeyDerived => _key != null;

  /// Derive AES 256 key from a string password using PBKDF2
  Future<void> deriveKey(String password, String saltStr) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _iterations,
      bits: _keyLength * 8,
    );

    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: utf8.encode(saltStr),
    );

    final keyBytes = await secretKey.extractBytes();
    _key = enc.Key(Uint8List.fromList(keyBytes));
  }

  void clearKey() {
    _key = null;
  }

  /// Encrypt JSON strings or strings
  String encrypt(String plainText) {
    if (_key == null) throw Exception("Key not derived yet");

    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(_key!, mode: enc.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // Store IV along with ciphertext
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypt
  String decrypt(String cipherTextWithIv) {
    if (_key == null) throw Exception("Key not derived yet");

    final parts = cipherTextWithIv.split(':');
    if (parts.length != 2) throw Exception("Invalid ciphertext format");

    final iv = enc.IV.fromBase64(parts[0]);
    final encrypted = enc.Encrypted.fromBase64(parts[1]);

    final encrypter = enc.Encrypter(enc.AES(_key!, mode: enc.AESMode.cbc));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
