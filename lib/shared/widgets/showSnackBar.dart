import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = Colors.black,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}
