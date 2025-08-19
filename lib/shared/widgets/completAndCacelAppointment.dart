// Complete and Cansel
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget completAndCancelAppointmentContainer({
  required double width,
  required double height,
  required String drName,
  String? subtitle,
  required DateTime dateTime,
  required String checkText,
  required Color bgColor,
}) {
  String dayName = DateFormat('EEEE').format(dateTime); // Monday
  String monthDay = DateFormat('MMM d').format(dateTime); // Aug 29
  String startTime = DateFormat('HH:mm').format(dateTime); // 11:00
  String endTime = DateFormat(
    'HH:mm',
  ).format(dateTime.add(Duration(hours: 1))); // 12:00

  return Container(
    margin: EdgeInsets.all(12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      // color: Colors.white,
      color: CustomColors.backgroundGradientRight,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 10,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Doctor info
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                "assets/images/profile.jpg",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: CustomColors.textDark,
                  ),
                ),
                if (subtitle != null && subtitle.isNotEmpty)
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 14, color: CustomColors.textSub),
                  ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),

        // Appointment time and date row
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                '$dayName, $monthDay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.textDark,
                ),
              ),
              Spacer(),
              Icon(Icons.access_time, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                '$startTime - $endTime WIB',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.textDark,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),
        // Cancel and Reschedule buttons
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              checkText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomColors.textDark,
              ),
            ),
            style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
              side: BorderSide(color: Colors.grey),
              backgroundColor: bgColor,
            ),
          ),
        ),
      ],
    ),
  );
}
