import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor {
  dev,
  qa, 
  prod,
}

class AppConfig {
  static Flavor? appFlavor;
  static bool _isInitialized = false;
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    String envFile;
    switch (appFlavor) {
      case Flavor.dev:
        envFile = 'lib/config/env/.env.dev';
        break;
      case Flavor.qa:
        envFile = 'lib/config/env/.env.qa';
        break;
      case Flavor.prod:
        envFile = 'lib/config/env/.env.prod';
        break;
      default:
        envFile = 'lib/config/env/.env.dev';
    }
    
    await dotenv.load(fileName: envFile);
    _isInitialized = true;
  }
  
  static String get flavorName => appFlavor?.name ?? 'dev';
  
  static String get baseUrl => dotenv.env['URL_BASE'] ?? 'http://10.0.2.2:8000';
  static String get appName => dotenv.env['APP_NAME'] ?? 'Lorry';
  static bool get debugMode => dotenv.env['DEBUG_MODE'] == 'true';
  
  static bool get isprod => appFlavor == Flavor.prod;
  static bool get isDev => appFlavor == Flavor.dev;
  static bool get isQA => appFlavor == Flavor.qa;
}