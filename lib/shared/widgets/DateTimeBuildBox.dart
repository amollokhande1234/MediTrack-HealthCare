import 'package:flutter/material.dart';

Widget buildBox(String value, String label) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.shade300),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade900,
          ),
        ),
      ),
      SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
    ],
  );
}
