import 'dart:async';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:flutter/material.dart';

class ValidationToastHelper {
  static Timer? _debounceTimer;
  static dynamic _lastShownMessage;
  static dynamic _lastTitle;

  static void showValidationToast({
    required BuildContext context,
    required dynamic message,
    dynamic title,
    Duration delay = const Duration(milliseconds: 500),
    bool forceShow = false,
  }) {
    String messageStr =
        message is Widget ? message.toString() : message.toString();
    String titleStr =
        title is Widget ? title.toString() : (title?.toString() ?? '');
    String lastMessageStr = _lastShownMessage is Widget
        ? _lastShownMessage.toString()
        : (_lastShownMessage?.toString() ?? '');
    String lastTitleStr = _lastTitle is Widget
        ? _lastTitle.toString()
        : (_lastTitle?.toString() ?? '');

    if (lastMessageStr == messageStr &&
        lastTitleStr == titleStr &&
        !forceShow) {
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      _lastShownMessage = message;
      _lastTitle = title;
      _showToast(context, message, title);
    });
  }

  static void cancelPendingToasts() {
    _debounceTimer?.cancel();
    _lastShownMessage = null;
    _lastTitle = null;
  }

  static void showImmediateToast(
      BuildContext context, dynamic message, dynamic title) {
    cancelPendingToasts();
    _lastShownMessage = message;
    _lastTitle = title;
    _showToast(context, message, title);
  }

  static void _showToast(BuildContext context, dynamic message, dynamic title) {
    ToastHelper.show_validation_alert(context, message, title: title);
  }
}
