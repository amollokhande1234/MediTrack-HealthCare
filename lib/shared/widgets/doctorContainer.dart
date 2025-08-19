import 'package:flutter/material.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget doctorContainer(
  String drName,
  String drSpecialist,
  String imgUrl,
  String drEdu,
  String age,
  String gender,
  String number,
  String address,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircleAvatar(
              backgroundColor: Colors.grey[200], // optional background
              child: ClipOval(
                child: Image.network(
                  imgUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover, // 👈 this makes it fit the circle
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                drName,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontSize: 25, // 👈 size of entered text
                  fontWeight: FontWeight.w800,
                  color: CustomColors.textDark, // change as needed
                ),
              ),
              Text(
                drSpecialist,
                style: const TextStyle(
                  fontSize: 23, // 👈 size of entered text
                  fontWeight: FontWeight.w700,
                  color: CustomColors.textSub, // change as needed
                ),
              ),
              Text(
                drEdu,
                style: const TextStyle(
                  fontSize: 20, // 👈 size of entered text
                  fontWeight: FontWeight.w500,
                  color: CustomColors.textDark, // change as needed
                ),
              ),
            ],
          ),
        ],
      ),

      SizedBox(height: 20),
      Divider(),

      Text(
        "Age : ${age}",
        style: const TextStyle(
          fontSize: 20, // 👈 size of entered text
          fontWeight: FontWeight.w500,
          color: CustomColors.textSub, // change as needed
        ),
      ),

      Text(
        "Gender : ${gender}",
        style: const TextStyle(
          fontSize: 20, // 👈 size of entered text
          fontWeight: FontWeight.w500,
          color: CustomColors.textSub, // change as needed
        ),
      ),
      Divider(),
      InkWell(
        onTap: () {},
        child: Row(
          children: [
            Icon(Icons.call),
            SizedBox(width: 10),
            Text(
              number,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20, // 👈 size of entered text
                fontWeight: FontWeight.w400,
                color: CustomColors.textSub, // change as needed
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      Row(
        children: [
          Icon(Icons.location_on),
          SizedBox(width: 10),
          Text(
            address,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20, // 👈 size of entered text
              fontWeight: FontWeight.w400,
              color: CustomColors.textSub, // change as needed
            ),
          ),
        ],
      ),
    ],
  );
}
