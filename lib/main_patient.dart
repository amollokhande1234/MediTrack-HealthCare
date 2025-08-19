import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/firebase_options.dart';
import 'package:meditrack/patient/Auth/patient_login.dart';
import 'package:meditrack/patient/PatientApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MediTrackPatient());
}

class MediTrackPatient extends StatefulWidget {
  const MediTrackPatient({super.key});

  @override
  State<MediTrackPatient> createState() => _MediTrackPatientState();
}

class _MediTrackPatientState extends State<MediTrackPatient> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTrack - Doctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPatientAuthWrapper(), // ✅ Navigation controller
      // home: DemoNotification(),
    );
  }
}

class MainPatientAuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    // If logged in -> show main screen with bottom nav
    if (user != null) {
      return PatientApp(); // ✅ Show bottom nav here
    } else {
      return PatientLoginPage(); // ✅ No bottom nav here
    }
  }
}
