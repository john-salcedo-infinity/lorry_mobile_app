import 'package:flutter/material.dart';

class Apptheme {
  // #regions General settings
  static const Color primary = Color.fromRGBO(242, 119, 53, 1);
  static const Color backgroundColor = Color.fromRGBO(249, 249, 252, 1);
  static const Color darkorange = Color.fromRGBO(204, 71, 0, 1);
  static const Color secondary = Color.fromRGBO(23, 100, 93, 1);
  static const Color secondaryv3 = Color.fromRGBO(50, 150, 108, 1);
  static const Color secondaryv4 = Color.fromRGBO(220, 230, 227, 1);
  static const Color grayInput = Color.fromRGBO(73, 77, 76, 0.5);
  static const Color lightGreen = Color.fromRGBO(220, 230, 227, 1);
  static const Color textColorSecondary = Color.fromRGBO(73, 77, 76, 1);
  static const Color lightOrange = Color.fromRGBO(253, 235, 225, 1);
  static const Color lightOrange2 = Color.fromRGBO(255, 224, 207, 1);

  static const Color textColorPrimary = Color.fromRGBO(23, 100, 93, 1);
  static const String textFamily = "Poppins";
  static const TextStyle textPrimary = TextStyle(fontFamily: textFamily);

  static const Color sucess_color = Color.fromRGBO(50, 150, 108, 1);
  static const Color sucess_color_v2 = Color.fromRGBO(215, 250, 236, 1);
  static const Color tireBackground = Color.fromRGBO(220, 230, 227, 1);

  static const Color AlertOrange = Color.fromRGBO(242, 100, 26, 1);
  static const Color lightAlertOrange = Color.fromRGBO(255, 224, 235, 1);

  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
  );
  // #endregion

  // #regions Variant color
  static const Color primaryopacity = Color.fromRGBO(242, 100, 26, 0.80);

  // #endregions

  // #regions Text Style
  static const TextStyle titleStyle = TextStyle(
      fontSize: 22,
      color: Apptheme.textColorSecondary,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const TextStyle titleStylev2 = TextStyle(
      fontSize: 15,
      color: Apptheme.textColorSecondary,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const TextStyle subtitleStyle = TextStyle(
      fontSize: 16,
      color: Apptheme.textColorSecondary,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const TextStyle subtitleStylev2 = TextStyle(
      fontSize: 10,
      color: Apptheme.textColorSecondary,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const TextStyle textMuted = TextStyle(
      fontSize: 11,
      color: Colors.grey,
      fontWeight: FontWeight.normal,
      fontFamily: "Poppins");

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

  static InputDecoration inputDecorationPrimaryv2(hint) {
    return InputDecoration(
        suffixIcon: Icon(Icons.search),
        suffixIconColor: Apptheme.secondary,
        hintText: hint,
        focusedBorder: const OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(color: Apptheme.darkorange, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        enabledBorder: const OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.all(Radius.circular(4))));
  }
  // #endregion

  // #regions Buttons Style

  // #endregion

  // #regions Cards Style
  static const BoxDecoration card_radius_only_top = BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      color: Colors.white);
  // #endregion

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
