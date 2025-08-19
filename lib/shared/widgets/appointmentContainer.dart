import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget appointmentContainer(
  String drName,
  String subtitle,
  DateTime dateTime,
  double width,
) {
  String day = DateFormat('d').format(dateTime);
  String month = DateFormat('MMM').format(dateTime);
  String time = DateFormat('h:mm a').format(dateTime);
  return Container(
    height: 90,
    width: width * 1,
    decoration: BoxDecoration(
      color: CustomColors.calendarBlue,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            child: Image(image: AssetImage("assets/icons/mediKit.png")),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.textDark,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: CustomColors.textSub,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3),
          VerticalDivider(indent: 1),
          SizedBox(width: 3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day + " " + month,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CustomColors.textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
              Text(
                time,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CustomColors.textSub,
                  fontWeight: FontWeight.normal,
                  fontSize: 19,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
