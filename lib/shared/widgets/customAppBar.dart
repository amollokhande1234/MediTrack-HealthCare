import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';

PreferredSizeWidget customAppBar(BuildContext context, String title) {
  return AppBar(
    centerTitle: true,
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColors.primaryPurple),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w600,
        color: CustomColors.primaryPurple,
      ),
    ),
  );
}
