import 'dart:convert';
import 'package:intl/intl.dart';
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
}
