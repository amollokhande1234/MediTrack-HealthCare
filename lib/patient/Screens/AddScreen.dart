import 'package:flutter/material.dart';
import 'package:meditrack/patient/Pages/AISymptomsChecker/aiSymptomsModelPage.dart';
import 'package:meditrack/patient/Pages/CabinetAddScreen.dart';
import 'package:meditrack/patient/Pages/MedicineAddScreen.dart';
import 'package:meditrack/patient/Pages/Appointment/ScheduleAppointmentScreen.dart';
import 'package:meditrack/patient/Pages/prescriptionPage.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/customAddMCAContainer.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Widget> values = [
      customAddMCAContainer(
        "Add Medicine",
        "medicine.png",
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MedicineAddScreen()),
          );
        },
        height * 0.4,
        width * 0.1,
      ),
      customAddMCAContainer(
        "Add Cabinet",
        "mediKit.png",
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CabinetAddScreen()),
          );
        },
        height * 0.4,
        width * 0.1,
      ),
      customAddMCAContainer(
        "Schedule Appointment",
        "appointment.png",
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleAppointmentScreen(),
            ),
          );
        },
        height * 0.4,
        width * 0.1,
      ),

      customAddMCAContainer(
        "Add Recipts",
        "recipt.png",
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => prescriptionPage()),
          );
        },
        height * 0.4,
        width * 0.1,
      ),
      customAddMCAContainer(
        "AI Simptoms Check",
        "deepseekIcon.png",
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        height * 0.4,
        width * 0.1,
      ),
    ];
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              "Hey Amol\nAdd Your Reminders here",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25, // 👈 size of entered text
                fontWeight: FontWeight.w800,
                color: CustomColors.textDark, // change as needed
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              itemCount: values.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: values[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
