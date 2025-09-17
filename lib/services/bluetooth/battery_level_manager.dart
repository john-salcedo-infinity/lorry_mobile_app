import 'package:app_lorry/helpers/helpers.dart';

/// Singleton para gestionar la persistencia del nivel de batería del dispositivo Bluetooth
class BatteryLevelManager {
  static BatteryLevelManager? _instance;
  static const String _batteryLevelKey = 'bluetooth_battery_level';
  
  int? _currentBatteryLevel;
  DateTime? _lastUpdate;
  
  BatteryLevelManager._internal();
  
  static BatteryLevelManager get instance {
    _instance ??= BatteryLevelManager._internal();
    return _instance!;
  }
  
  /// Inicializa el manager cargando el último nivel de batería guardado
  Future<void> initialize() async {
    try {
      final prefs = Preferences();
      await prefs.init();
      
      final savedLevelStr = prefs.getValue(_batteryLevelKey);
      if (savedLevelStr.isNotEmpty) {
        final savedLevel = int.tryParse(savedLevelStr);
        if (savedLevel != null && savedLevel >= 0 && savedLevel <= 100) {
          _currentBatteryLevel = savedLevel;
        }
      }
    } catch (e) {
      print('Error inicializando BatteryLevelManager: $e');
    }
  }
  
  /// Actualiza el nivel de batería y lo persiste
  Future<void> updateBatteryLevel(int level) async {
    if (level < 0 || level > 100) {
      print('Nivel de batería inválido: $level');
      return;
    }
    
    try {
      _currentBatteryLevel = level;
      _lastUpdate = DateTime.now();
      
      // Guardar en preferencias
      final prefs = Preferences();
      await prefs.init();
      prefs.saveKey(_batteryLevelKey, level.toString());
      
      print('Nivel de batería actualizado y guardado: $level%');
    } catch (e) {
      print('Error guardando nivel de batería: $e');
    }
  }
  
  /// Obtiene el último nivel de batería conocido
  int? get currentBatteryLevel => _currentBatteryLevel;
  
  /// Obtiene el timestamp de la última actualización
  DateTime? get lastUpdate => _lastUpdate;
  
  /// Verifica si el nivel de batería está disponible
  bool get hasBatteryLevel => _currentBatteryLevel != null;
  
  /// Limpia los datos de batería guardados
  Future<void> clearBatteryData() async {
    try {
      _currentBatteryLevel = null;
      _lastUpdate = null;
      
      final prefs = Preferences();
      await prefs.init();
      prefs.removeKey(_batteryLevelKey);
      
      print('Datos de batería limpiados');
    } catch (e) {
      print('Error limpiando datos de batería: $e');
    }
  }
  
  /// Verifica si los datos de batería son recientes (menos de 10 minutos)
  bool get isBatteryDataRecent {
    if (_lastUpdate == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(_lastUpdate!);
    
    return difference.inMinutes < 10;
  }
}