import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget customButton(String title, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: BoxDecoration(
        color: CustomColors.primaryPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
