import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  late encrypt.Encrypter _encrypter;
  late encrypt.Key _key;
  late encrypt.IV _iv;

  EncryptionService({required String passphrase}) {
    _key = encrypt.Key.fromUtf8(passphrase.substring(0, 32));
    _iv = encrypt.IV.fromUtf8(passphrase.substring(0, 16));
    _encrypter = encrypt.Encrypter(
      encrypt.AES(
        _key,
        mode: encrypt.AESMode.cbc,
      ),
    );
  }

  String encryptData(String data) {
    final encrypted = _encrypter.encrypt(data, iv: _iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedData) {
    final decrypted = _encrypter.decrypt64(encryptedData, iv: _iv);
    return decrypted;
  }
}
