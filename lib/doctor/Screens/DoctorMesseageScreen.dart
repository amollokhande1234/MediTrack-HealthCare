import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';

import 'package:meditrack/shared/widgets/Chat/ChatList.dart';

class DoctorMesseageScreen extends StatelessWidget {
  const DoctorMesseageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return chatList(
      appBarText: "Patients",
      text: "Search Patients",
      stream:
          fireStore
              .collection('doctors')
              .doc(getCurrentUser().uid)
              .collection('chats')
              .snapshots(),
    );
  }
}
