import 'package:flutter/foundation.dart';

class AppConfig {
  static const String developmentBackendUrl = 'http://localhost:8000';
  static const String productionBackendUrl = 'https://carbonlens-ai-production.up.railway.app';

  static String get backendUrl {
    if (kReleaseMode) {
      return productionBackendUrl;
    }
    return developmentBackendUrl;
  }
}
