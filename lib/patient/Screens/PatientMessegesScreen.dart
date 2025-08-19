import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/patient/Pages/Chat/patientChatScreen.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/Chat/ChatList.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';

class PatientMessagesScreen extends StatelessWidget {
  const PatientMessagesScreen({super.key});

  // final List<Map<String, String>> doctors = const [
  //   {'name': 'Dr. Smith', 'specialty': 'Cardiologist'},
  //   {'name': 'Dr. Sharma', 'specialty': 'Dermatologist'},
  //   {'name': 'Dr. Patel', 'specialty': 'Pediatrician'},
  //   {'name': 'Dr. Aisha', 'specialty': 'Psychiatrist'},
  // ];

  @override
  Widget build(BuildContext context) {
    final user = getCurrentUser();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Patients")),
        body: const Center(child: Text("You are not logged in.")),
      );
    }

    return chatList(
      appBarText: "Doctors",
      text: "Patients",
      stream:
          fireStore
              .collection('patients')
              .doc(user.uid!)
              .collection('chats')
              .snapshots()!,
    );
  }
}
