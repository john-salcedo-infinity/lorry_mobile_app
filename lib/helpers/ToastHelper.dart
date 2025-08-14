import 'package:flutter/material.dart';
import 'package:app_lorry/config/configs.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void show_success(context, String message) {
    toastification.show(
      context: context,
      style: ToastificationStyle.fillColored,
      primaryColor: Apptheme.toastSucessBackground,
      backgroundColor: Apptheme.secondaryv2,
      autoCloseDuration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(4),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      description: IntrinsicWidth(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          const Icon(Icons.check_circle, color: Apptheme.secondary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Apptheme.secondaryv2,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
        ]),
      ),
      showProgressBar: true,
      showIcon: false,
      borderSide: const BorderSide(color: Apptheme.secondaryv2, width: 2),
    );
  }

  static void show_alert(context, String message, {bool orange = false}) {
    toastification.show(
      context: context,
      style: ToastificationStyle.fillColored,
      primaryColor: Apptheme.lightOrange,
      backgroundColor: Apptheme.toastAlertBorder,
      autoCloseDuration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(4),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      description: IntrinsicWidth(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Icon(Icons.cancel, color: Apptheme.toastAlertBorder),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Apptheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
        ]),
      ),
      showProgressBar: true,
      showIcon: false,
      borderSide: const BorderSide(color: Apptheme.toastAlertBorder, width: 2),
    );
  }
}
