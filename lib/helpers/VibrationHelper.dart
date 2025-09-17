import 'package:vibration/vibration.dart';

class VibrationHelper {
  /// Reproduce un patrón de vibración personalizable
  ///
  /// [intensities] - Lista de intensidades de vibración (light, medium, heavy)
  /// [delays] - Lista de delays en milisegundos entre cada vibración
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// // Vibración simple
  /// VibrationHelper.playPattern();
  ///
  /// // Vibración personalizada
  /// VibrationHelper.playPattern(
  ///   intensities: [VibrationIntensity.heavy, VibrationIntensity.medium],
  ///   delays: [200]
  /// );
  /// ```
  static Future<void> playPattern({
    List<VibrationIntensity> intensities = const [
      VibrationIntensity.heavy,
      VibrationIntensity.medium
    ],
    List<int> delays = const [200],
  }) async {
    if (intensities.isEmpty) return;

    // Verificar si el dispositivo tiene capacidad de vibración
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) return;

    // Reproducir la primera vibración
    await _playVibration(intensities[0]);

    // Reproducir el resto de vibraciones con sus delays
    for (int i = 1; i < intensities.length; i++) {
      // Usar el delay correspondiente o el último disponible
      final delayIndex = i - 1;
      final delay =
          delayIndex < delays.length ? delays[delayIndex] : delays.last;

      await Future.delayed(Duration(milliseconds: delay));
      await _playVibration(intensities[i]);
    }
  }

  /// Reproduce una vibración simple
  ///
  /// [intensity] - Intensidad de la vibración
  /// [duration] - Duración en milisegundos (solo para Android)
  static Future<void> playSingle({
    VibrationIntensity intensity = VibrationIntensity.medium,
    int duration = 200,
  }) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) return;

    await _playVibration(intensity, duration: duration);
  }

  /// Reproduce un patrón de vibración usando la API nativa de la librería
  ///
  /// [pattern] - Lista alternando delays y duraciones de vibración en milisegundos
  /// [repeat] - Índice desde donde repetir el patrón (-1 para no repetir)
  /// [amplitude] - Intensidad de la vibración (solo Android, -1 para default)
  ///
  /// Ejemplo: [0, 200, 100, 300] = espera 0ms, vibra 200ms, pausa 100ms, vibra 300ms
  static Future<void> playCustomPattern({
    required List<int> pattern,
    int repeat = -1,
    int amplitude = -1,
  }) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) return;

    await Vibration.vibrate(
      pattern: pattern,
      repeat: repeat,
      amplitude: amplitude,
    );
  }

  /// Reproduce un patrón predefinido de notificación
  /// Útil para notificaciones de dispositivos Bluetooth
  static Future<void> playNotification() async {
    await playCustomPattern(
      pattern: [0, 300, 200, 150],
      amplitude: 128, // Intensidad media
    );
  }

  /// Reproduce un patrón predefinido de alerta
  /// Útil para alertas importantes
  static Future<void> playAlert() async {
    await playCustomPattern(
      pattern: [0, 400, 150, 200, 150, 400],
      amplitude: 255, // Intensidad máxima
    );
  }

  /// Reproduce un patrón predefinido de éxito
  /// Útil para confirmaciones
  static Future<void> playSuccess() async {
    await playCustomPattern(
      pattern: [0, 500],
      amplitude: 250, // Intensidad maxima
    );
  }

  /// Reproduce un patrón predefinido de error
  /// Útil para errores o fallos
  static Future<void> playError() async {
    await playCustomPattern(
      pattern: [0, 1000, 300, 1000],
      amplitude: 255, // Intensidad máxima
    );
  }

  /// Reproduce una vibración larga
  static Future<void> playLong() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) return;

    await Vibration.vibrate(duration: 1000);
  }

  /// Reproduce una vibración corta
  static Future<void> playShort() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) return;

    await Vibration.vibrate(duration: 100);
  }

  /// Cancela cualquier vibración en progreso
  static Future<void> cancel() async {
    await Vibration.cancel();
  }

  /// Verifica si el dispositivo tiene capacidad de vibración
  static Future<bool> hasVibrator() async {
    return await Vibration.hasVibrator();
  }

  /// Verifica si el dispositivo soporta control de amplitud (Android 8.0+)
  static Future<bool> hasAmplitudeControl() async {
    return await Vibration.hasAmplitudeControl();
  }

  /// Método privado para reproducir una vibración según su intensidad
  ///
  /// [intensity] - Intensidad de la vibración
  /// [duration] - Duración en milisegundos
  static Future<void> _playVibration(
    VibrationIntensity intensity, {
    int duration = 200,
  }) async {
    final hasAmplitude = await hasAmplitudeControl();

    if (hasAmplitude) {
      // En dispositivos con control de amplitud, usar diferentes intensidades
      int amplitude;
      switch (intensity) {
        case VibrationIntensity.light:
          amplitude = 64; // ~25% de intensidad
          break;
        case VibrationIntensity.medium:
          amplitude = 128; // ~50% de intensidad
          break;
        case VibrationIntensity.heavy:
          amplitude = 255; // 100% de intensidad
          break;
      }

      await Vibration.vibrate(
        duration: duration,
        amplitude: amplitude,
      );
    } else {
      // En dispositivos sin control de amplitud, simular con diferentes duraciones
      int vibrationDuration;
      switch (intensity) {
        case VibrationIntensity.light:
          vibrationDuration = (duration * 0.6).round();
          break;
        case VibrationIntensity.medium:
          vibrationDuration = duration;
          break;
        case VibrationIntensity.heavy:
          vibrationDuration = (duration * 1.5).round();
          break;
      }

      await Vibration.vibrate(duration: vibrationDuration);
    }
  }
}

/// Enum para definir las intensidades de vibración disponibles
enum VibrationIntensity {
  light,
  medium,
  heavy,
}
