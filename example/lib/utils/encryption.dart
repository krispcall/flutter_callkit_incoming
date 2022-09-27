import "package:encrypt/encrypt.dart";
import "package:mvp/constant/Constants.dart";

class EncryptionDecryption {
  static String decrypt(String text) {
    final key = Key.fromBase64(Const.PRIVATE_KEY);
    final fernet = Fernet(key);
    final encrypter = Encrypter(fernet);
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(text));
    return decrypted;
  }
}
