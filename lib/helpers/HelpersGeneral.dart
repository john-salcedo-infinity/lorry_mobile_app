import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';

class HelpersGeneral {
  static String formatCustomDate(DateTime date) {
    // Crea una instancia de DateFormat con el formato deseado
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    // Formatea la fecha
    return formatter.format(date);
  }

  static Future<User> getAuthUser() async {
    Preferences preference = Preferences();
    await preference.init();
    String user = preference.getValue("user");
    User datafinalstring = User.fromJson(jsonDecode(user));
    print("buscando user");
    return datafinalstring;
  }

  static String formatDayDate(DateTime date) {
    // Formatea la fecha al estilo "Día, d Mes yyyy"
    final DateFormat formatter = DateFormat('EEEE, d MMM yyyy', 'es_ES');

    // Inicializa los datos de formato para el idioma español
    String formattedDate = formatter.format(date);

    // Capitaliza la primera letra de cada parte de la fecha
    // Esto es necesario porque el formato 'EEEE, d MMM yyyy' devuelve el día y mes en minúsculas
    // y queremos que la primera letra sea mayúscula.

    List<String> parts = formattedDate.split(' ');
    if (parts.isNotEmpty) {
      parts[0] = parts[0][0].toUpperCase() + parts[0].substring(1); // Día
      if (parts.length > 2) {
        parts[2] = parts[2][0].toUpperCase() + parts[2].substring(1); // Mes
      }
    }
    formattedDate = parts.join(' ');

    return formattedDate;
  }

  /// Formatea un número double a una cadena con formato de configuración regional de EE.UU.
  /// 
  /// Este método toma un valor double y lo formatea usando la configuración regional
  /// de inglés estadounidense con exactamente 2 decimales. La cadena formateada
  /// incluirá separadores de coma para los miles.
  /// 
  /// Ejemplo:
  /// ```dart
  /// numberFormat(1234.567); // Retorna "1,234.57"
  /// numberFormat(42.1);     // Retorna "42.10"
  /// ```
  /// 
  /// Parámetros:
  /// * [number] - El valor double que será formateado
  /// 
  /// Retorna:
  /// Una representación [String] del número formateado con las convenciones
  /// de configuración regional de EE.UU. y 2 decimales.
  /// 
  static numberFormat(double number) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    return formatter.format(number);
  }
}
