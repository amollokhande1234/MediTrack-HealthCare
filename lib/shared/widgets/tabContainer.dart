import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget tabBarContainer(String title, double width) {
  return Container(
    width: width,
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: CustomColors.calendarBlue,
    ),
    child: Center(
      child: Text(
        title,
        style: TextStyle(
          color: CustomColors.textDark,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
