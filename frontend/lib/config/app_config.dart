import 'package:flutter/foundation.dart';

class AppConfig {
  static const String developmentBackendUrl = 'http://localhost:8000';
  static const String productionBackendUrl = 'https://carbonlens-api.up.railway.app'; // Adjust to your actual Railway URL

  static String get backendUrl {
    if (kReleaseMode) {
      return productionBackendUrl;
    }
    return developmentBackendUrl;
  }
}
