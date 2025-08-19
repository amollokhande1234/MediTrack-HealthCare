import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/doctor/Pages/Appointments/AppointmentScreen.dart';
import 'package:meditrack/patient/Screens/AddScreen.dart';
import 'package:meditrack/patient/Screens/AppointmentScreen.dart';
import 'package:meditrack/patient/Screens/PatientHomePage.dart';
import 'package:meditrack/patient/Screens/PatientMessegesScreen.dart';
import 'package:meditrack/patient/Screens/PatientProfileScreen.dart';
import 'package:meditrack/shared/constants/Colors.dart';

class PatientApp extends StatefulWidget {
  PatientApp({super.key});

  @override
  State<PatientApp> createState() => _PatientAppState();
}

class _PatientAppState extends State<PatientApp> {
  final List<Widget> _screens = [
    const PatitenHomeScreen(),
    const PatientMessagesScreen(),
    const AddScreen(),
    const PatientAppointmentScreen(),
    const PatientProfilePage(),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    final _items = [
      Icon(Icons.home, size: 30),
      Icon(Icons.chat, size: 30),
      Icon(Icons.add, size: 30),
      Icon(Icons.calendar_today, size: 30),
      Icon(Icons.person, size: 30),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediTrack - Patient',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: _screens[index],

        // Bottom Nav Bar
        bottomNavigationBar: CurvedNavigationBar(
          onTap:
              (index) => setState(() {
                this.index = index;
              }),
          items: _items,
          index: index,
          color: CustomColors.calendarBlue,
          // animationCurve: Curve.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.white,
          height: 60,
          buttonBackgroundColor: CustomColors.primaryPurple,
        ),
      ),
    );
  }
}
