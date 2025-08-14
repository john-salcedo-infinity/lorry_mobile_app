import 'package:flutter/material.dart';

class Apptheme {
  // #regions General settings
  // Orange colors
  static const Color primary = Color.fromRGBO(242, 119, 53, 1);
  static const Color darkorange = Color.fromRGBO(204, 71, 0, 1);
  static const Color lightOrange = Color.fromRGBO(253, 235, 224, 1);
  static const Color alertOrange = Color.fromRGBO(242, 100, 26, 1);
  static const Color toastAlertBorder = Color.fromRGBO(255, 157, 105, 1);
  static const Color selectActiveBorder = Color.fromRGBO(255, 190, 156, 1);
  static const Color selectActiveBackground = Color.fromRGBO(255, 248, 245, 1);
  static const Color selectActiveSelectChevron =
      Color.fromRGBO(255, 174, 130, 1);

  // Green colors
  static const Color secondary = Color.fromRGBO(23, 100, 93, 1);
  static const Color secondaryv2 = Color.fromRGBO(50, 150, 108, 1);
  static const Color secondaryv3 = Color.fromRGBO(220, 230, 227, 1);
  static const Color lightGreen = Color.fromRGBO(220, 230, 227, 1);
  static const Color tireBackground = Color.fromRGBO(220, 230, 227, 1);
  static const Color textColorPrimary = Color.fromRGBO(23, 100, 93, 1);
  static const Color toastSucessBackground = Color.fromRGBO(235, 255, 241, 1);

  // Other colors
  static const Color backgroundColor = Color.fromRGBO(249, 249, 252, 1);
  static const Color grayInput = Color.fromRGBO(73, 77, 76, 0.5);
  static const Color lightGray = Color.fromRGBO(148, 148, 148, .5);
  static const Color textColorSecondary = Color.fromRGBO(73, 77, 76, 1);
  // Typography
  static const String textFamily = "Poppins";
  static const TextStyle textPrimary = TextStyle(fontFamily: textFamily);

  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
  );

  // #regions Variant color
  static const Color primaryopacity = Color.fromRGBO(242, 100, 26, 0.80);

  // #endregions

  // #regions Text Style
  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    color: Apptheme.textColorSecondary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleStylev2 = TextStyle(
    fontSize: 15,
    color: Apptheme.textColorSecondary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: Apptheme.textColorSecondary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitleStylev2 = TextStyle(
    fontSize: 10,
    color: Apptheme.textColorSecondary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textMuted = TextStyle(
    fontSize: 11,
    color: Colors.grey,
    fontWeight: FontWeight.normal,
  );

  // #endregions

  // #regions Inputs Style
  static InputDecoration inputDecorationPrimary(hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(
        gapPadding: 0,
        borderSide: BorderSide(color: Apptheme.grayInput),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Apptheme.grayInput, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Apptheme.grayInput),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  // #Loading color
  static CircularProgressIndicator loadingIndicator() {
    return const CircularProgressIndicator(
      color: Apptheme.primary,
      strokeWidth: 2,
    );
  }

  static CircularProgressIndicator loadingIndicatorButton() {
    return const CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2,
    );
  }
}
