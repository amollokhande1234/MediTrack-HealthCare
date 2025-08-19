import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget customAddMCAContainer(
  String title,
  String path,
  VoidCallback onTap,
  double height,
  double width,
) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: BoxDecoration(
        color: CustomColors.cardLightPink,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: Image.asset("assets/images/$path"),
          ),
          SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center, // ← center alig
            title,
            style: const TextStyle(
              color: CustomColors.primaryPurple,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
