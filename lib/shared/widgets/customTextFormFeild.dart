import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget textFormFeild(
  String label, {
  TextInputType? inputType,
  TextEditingController? controller,
  bool? obsecureText,
}) {
  return TextFormField(
    textAlign: TextAlign.center,
    controller: controller,
    keyboardType: inputType,
    obscureText: obsecureText ?? false,
    style: const TextStyle(
      fontSize: 20, // 👈 size of entered text
      fontWeight: FontWeight.w500,
      color: CustomColors.textDark, // change as needed
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: CustomColors.textSub,
      ),
      fillColor: CustomColors.accentPurple,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
