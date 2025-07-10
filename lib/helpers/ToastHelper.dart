import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_lorry/config/configs.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void show_success(context, String message) {
    toastification.show(
        backgroundColor: Apptheme.sucess_color_v2,
        borderRadius:BorderRadius.circular(10),
        context: context, // optional if you use ToastificationWrapper
        title: Text(
          message,
          style:const TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Apptheme.sucess_color,
        showProgressBar: false,
        icon: const Image(image: AssetImage('assets/icons/Icon-verificazion.png')),
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.flatColored,
        borderSide: const BorderSide(
          color: Apptheme.sucess_color,
          width:2.5
        ));
  }

    static void show_alert(context, String message, {bool orange = false}) {
    Color primary = Colors.white;
    if (orange) {
      primary = Apptheme.primary;
    }
    toastification.show(
        backgroundColor: primary,
        borderRadius:BorderRadius.circular(10),
        context: context, // optional if you use ToastificationWrapper
        title: Text(
          message,
          style:const TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Apptheme.darkorange,
        showProgressBar: false,
        icon: const Image(image: AssetImage('assets/icons/Alert_Icon.png')),
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.flatColored,
        borderSide: const BorderSide(
          color: Apptheme.darkorange,
          width:2.5
        ));
  }
}
