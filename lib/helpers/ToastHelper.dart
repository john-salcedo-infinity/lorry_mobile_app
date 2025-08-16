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
              style: Apptheme.h4HighlightBody(
                context,
                color: Apptheme.secondaryv2,
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
              style: Apptheme.h4HighlightBody(
                context,
                color: Apptheme.primary,
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

  static void show_validation_alert(context, dynamic message, {dynamic title}) {
    toastification.show(
      context: context,
      style: ToastificationStyle.flat,
      primaryColor: Colors.white,
      backgroundColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 5),
      borderRadius: BorderRadius.circular(4),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      title: title != null
          ? Row(
              children: [
                const Icon(Icons.error, color: Apptheme.primary),
                const SizedBox(width: 8),
                // Verificar si title es Widget o String
                title is Widget
                    ? title
                    : Text(
                        title.toString(),
                        style: Apptheme.h4HighlightBody(
                          context,
                          color: Apptheme.primary,
                        ),
                      ),
              ],
            )
          : null,
      description: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.only(left: 30),
          child: message is Widget
              ? message // Si es Widget, usarlo directamente
              : Text(
                  // Si es String, crear Text widget
                  message.toString(),
                  style: Apptheme.h4Body(
                    context,
                    color: Colors.black,
                  ),
                ),
        ),
      ),
      showProgressBar: false,
      showIcon: false,
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}
