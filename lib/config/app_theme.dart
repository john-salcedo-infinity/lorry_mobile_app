import 'package:app_lorry/helpers/responsiveText.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static const Color darkSecondary = Color.fromRGBO(16, 61, 66, 1);
  static const Color secondaryv2 = Color.fromRGBO(50, 150, 108, 1);
  static const Color secondaryv3 = Color.fromRGBO(220, 230, 227, 1);
  static const Color lightGreen = Color.fromRGBO(220, 230, 227, 1);
  static const Color tireBackground = Color.fromRGBO(220, 230, 227, 1);
  static const Color textColorPrimary = Color.fromRGBO(23, 100, 93, 1);
  static const Color toastSucessBackground = Color.fromRGBO(235, 255, 241, 1);

  // Other colors
  static const Color backgroundColor = Color.fromRGBO(249, 249, 252, 1);
  static const Color gray = Color.fromRGBO(112, 112, 112, 1);
  static const Color grayInput = Color.fromRGBO(73, 77, 76, 0.5);
  static const Color lightGray = Color.fromRGBO(148, 148, 148, .5);
  static const Color textColorSecondary = Color.fromRGBO(73, 77, 76, 1);
  static const Color alarmYellow = Color.fromRGBO(230, 189, 28, 1);
  static const Color unReadNotificationBackground = Color.fromRGBO(255, 255, 255, 1);
  static const Color unReadNotificationBorder =  Color.fromRGBO(205, 221, 219, 1);

  // Alerts Backgrounds
  static const Color highAlertBackground = Color.fromRGBO(255, 242, 235, 1);
  static const Color mediumAlertBackground = Color.fromRGBO(255, 252, 235, 1);
  static const Color lowAlertBackground = Color.fromRGBO(235, 255, 241, 1);

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

  static TextStyle h1Title(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 22),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h2Body(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 18),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h2Title(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 18),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h3Subtitle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 16),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h4Body(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 14),
      fontWeight: FontWeight.w400,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h4Medium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 14),
      fontWeight: FontWeight.w500,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h4HighlightBody(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 14),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h5Body(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 12),
      fontWeight: FontWeight.w400,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h5HighlightBody(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 12),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h6Title(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: ResponsiveText.fontSize(context, 10),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h1TitleDecorative(BuildContext context, {Color? color}) {
    return GoogleFonts.redHatMono(
      fontSize: ResponsiveText.fontSize(context, 22),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h4TitleDecorative(BuildContext context, {Color? color}) {
    return GoogleFonts.redHatMono(
      fontSize: ResponsiveText.fontSize(context, 14),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }

  static TextStyle h5TitleDecorative(BuildContext context, {Color? color}) {
    return GoogleFonts.redHatMono(
      fontSize: ResponsiveText.fontSize(context, 12),
      fontWeight: FontWeight.w700,
      color: color ?? Apptheme.textColorPrimary,
    );
  }
  // #endregions

  // #regions Inputs Style
  static InputDecoration inputDecorationPrimary(hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(
        gapPadding: 0,
        borderSide: BorderSide(color: Apptheme.lightGray),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Apptheme.lightGray, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Apptheme.lightGray),
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
