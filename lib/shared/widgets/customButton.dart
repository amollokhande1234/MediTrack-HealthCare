import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget customButton(String name, VoidCallback onTap) {
  return Container(
    height: 60,
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: CustomColors.primaryPurple,
    ),
    child: Center(child: Text(name)),
  );
}
