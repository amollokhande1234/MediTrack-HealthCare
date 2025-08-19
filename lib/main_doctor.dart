import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/FirebaseServices/MedicationReminderServices.dart';
import 'package:meditrack/doctor/Auth/doctor_login.dart';
import 'package:meditrack/doctor/DoctorApp.dart';
import 'package:meditrack/firebase_options.dart';
import 'package:meditrack/main_patient.dart';

import 'package:meditrack/patient/Auth/patient_login.dart';
import 'package:meditrack/shared/constants/UserConstants.dart';

Future<void> _backgroundMessaging(RemoteMessage msg) async {}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseMessaging.onBackgroundMessage(_backgroundMessaging);
  // final notificationService = NotificationService();
  // await notificationService.initNotification();

  // ***********************
  // runApp(const MediTrackPatient());
  runApp(const MediTrackDoctor());
}

class MediTrackDoctor extends StatefulWidget {
  const MediTrackDoctor({super.key});

  @override
  State<MediTrackDoctor> createState() => _MediTrackDoctorState();
}

class _MediTrackDoctorState extends State<MediTrackDoctor> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTrack - Doctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWrapper(), // ✅ Navigation controller
      // home: DocotrLoginPage(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = getCurrentUser();
    // NotificationService().scheduleFirebaseReminders(getCurrentUser().uid);

    // If logged in -> show main screen with bottom nav
    if (user != null) {
      return DoctorApp(); // ✅ Show bottom nav here
    } else {
      return DocotrLoginPage(); // ✅ No bottom nav here
    }
  }
}
