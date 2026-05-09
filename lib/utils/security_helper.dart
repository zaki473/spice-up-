import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityHelper {
  // 1. Secure Storage Instance
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Menulis data secara aman (Encrypted)
  static Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Membaca data secara aman
  static Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  // Menghapus data secara aman
  static Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  // 2. Safe Logger
  // Hanya mencetak log jika aplikasi berjalan dalam mode Debug.
  // Log otomatis mati/dihapus saat build production (Release).
  static void log(String message) {
    if (kDebugMode) {
      print("🛡️ [SECURITY_LOG]: $message");
    }
  }

  static void logSensitive(String label, String data) {
    if (kDebugMode) {
      print("🛡️ [SENSITIVE]: $label -> $data");
    }
  }
}
