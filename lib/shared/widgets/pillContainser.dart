import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/shared/constants/Colors.dart';

Widget pillContainer({
  required String pillName,
  required String subtitle,
  required bool value,
  required String docId,
  required BuildContext context,
}) {
  return Container(
    height: 90,
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: CustomColors.cardLightPink,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Image(image: AssetImage("assets/icons/capsule.png")),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pillName,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: CustomColors.textDark,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(fontSize: 18, color: CustomColors.textSub),
            ),
          ],
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: value,
              onChanged: (_) {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Confirm"),
                        content: Text("Did you take this medicine?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await fireStore
                                  .collection('patients')
                                  .doc(getCurrentUser().uid)
                                  .collection('reminders')
                                  .doc('default')
                                  .collection('medicine')
                                  .doc(docId)
                                  .update({'status': true});
                            },
                            child: Text("Yes"),
                          ),
                        ],
                      ),
                );
              },
            ),
            Icon(Icons.more_vert_outlined),
          ],
        ),
      ],
    ),
  );
}
