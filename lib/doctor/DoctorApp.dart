import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/doctor/Screens/DoctorHomeScreen.dart';
import 'package:meditrack/doctor/Screens/DoctorMesseageScreen.dart';
import 'package:meditrack/doctor/Screens/DoctorProfileScreen.dart';
import 'package:meditrack/shared/constants/Colors.dart';

class DoctorApp extends StatefulWidget {
  const DoctorApp({super.key});

  @override
  State<DoctorApp> createState() => _DoctorAppState();
}

class _DoctorAppState extends State<DoctorApp> {
  final List<Widget> _screens = [
    const DoctorHomePage(),
    const DoctorMesseageScreen(),
    const DoctorProfilePage(),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    final _items = [
      Icon(Icons.home, size: 30),
      Icon(Icons.chat, size: 30),
      Icon(Icons.person, size: 30),
    ];
    return Scaffold(
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
    );
  }
}
