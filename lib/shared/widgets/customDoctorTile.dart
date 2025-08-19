import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget customDoctorTile(
  String name,
  String specialist,
  String imgUrl, {
  required bool selected,
  required ValueChanged<bool?> onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: CustomColors.calendarBlue,
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: Image.network(
            imgUrl,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: CustomColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        specialist,
        style: TextStyle(
          color: CustomColors.textSub,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Checkbox(value: selected, onChanged: onChanged),
      onTap: () => onChanged(!selected), // tap on tile selects checkbox too
    ),
  );
}
