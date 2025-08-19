import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/FirebaseServices/MedicationReminderServices.dart';
import 'package:meditrack/doctor/Screens/DoctorHomeScreen.dart';
import 'package:meditrack/main_patient.dart';
import 'package:meditrack/patient/PatientApp.dart';
import 'package:meditrack/patient/Screens/PatientHomePage.dart';
import 'package:meditrack/shared/widgets/DateTimeBuildBox.dart';
import 'package:meditrack/shared/widgets/custoButton.dart';
import 'package:meditrack/shared/widgets/customAppBar.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';
import 'package:meditrack/shared/widgets/datePicker.dart';
import 'package:meditrack/shared/widgets/showSnackBar.dart';
import 'package:timezone/timezone.dart' as tz;

class MedicineAddScreen extends StatefulWidget {
  const MedicineAddScreen({super.key});

  @override
  State<MedicineAddScreen> createState() => _MedicineAddScreenState();
}

class _MedicineAddScreenState extends State<MedicineAddScreen> {
  final TextEditingController _pillNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Future<void> _pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
      );
      if (picked != null) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    Future<void> _pickTime() async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() {
          selectedTime = picked;
        });
      }
    }

    // Date and Time Data
    final day =
        selectedDate == null
            ? "00"
            : selectedDate!.day.toString().padLeft(2, '0');
    final month =
        selectedDate == null
            ? "00"
            : selectedDate!.month.toString().padLeft(2, '0');
    final year = selectedDate == null ? "----" : selectedDate!.year.toString();

    final hour =
        selectedTime == null
            ? "00"
            : (selectedTime!.hourOfPeriod == 0
                    ? 12
                    : selectedTime!.hourOfPeriod)
                .toString()
                .padLeft(2, '0');

    final minute =
        selectedTime == null
            ? "00"
            : selectedTime!.minute.toString().padLeft(2, '0');

    final period =
        selectedTime == null
            ? "--"
            : selectedTime!.period == DayPeriod.am
            ? "AM"
            : "PM";

    // Convert Data to the TimeStamp
    Timestamp getDateTimeAsTimestamp(
      DateTime? selectedDate,
      TimeOfDay? selectedTime,
    ) {
      if (selectedDate == null || selectedTime == null) {
        // Return current timestamp or a default timestamp
        showCustomSnackBar(
          context,
          "Date & Time Required",
          backgroundColor: Colors.redAccent,
        );
      }

      final hour =
          selectedTime!.period == DayPeriod.pm && selectedTime.hour < 12
              ? selectedTime.hour + 12
              : selectedTime.period == DayPeriod.am && selectedTime.hour == 12
              ? 0
              : selectedTime.hour;

      final dateTime = DateTime(
        selectedDate!.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        selectedTime.minute,
      );

      return Timestamp.fromDate(dateTime);
    }

    //
    Future<bool> addReminderMedicine(String pillName, String desc) async {
      try {
        if (getCurrentUser() != null) {
          final _user = getCurrentUser();
          if (_user.uid != null) {
            await defaultPatientDoc.collection('medicine').add({
              'pillName': pillName,
              'desc': desc,
              'status': false,
              'time': getDateTimeAsTimestamp(selectedDate, selectedTime),
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }

    final notificationService = NotificationService();
    initState() {
      firebaseNotification.firebaseMesseging(context, widget);
      // localReminderServices.initialize();
      notificationService.initNotification();

      super.initState();
    }

    return Scaffold(
      appBar: customAppBar(context, "Add Medicine"),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Medicine Image
            Center(
              child: Container(
                height: height * 0.3,
                // width: width * 3,
                child: Image.asset("assets/images/medicine.png"),
              ),
            ),

            // Pill Name, desc, time,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textFormFeild(
                    "Enter the Pill Name",
                    controller: _pillNameController,
                  ),
                  SizedBox(height: 10),
                  textFormFeild(
                    "Enter Description",
                    controller: _descController,
                  ),
                  SizedBox(height: 10),
                  Text("Time"),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Date Picker Row
                      GestureDetector(
                        onTap: _pickDate,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildBox(day, "Day"),
                            SizedBox(width: 10),
                            buildBox(month, "Month"),
                            SizedBox(width: 10),
                            buildBox(year, "Year"),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Time Picker Row
                      GestureDetector(
                        onTap: _pickTime,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildBox(hour, "Hour"),
                            SizedBox(width: 10),
                            buildBox(minute, "Min"),
                            SizedBox(width: 10),
                            buildBox(period, "AM/PM"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // btn
          ],
        ),
      ),
      bottomSheet: SafeArea(
        child: Container(
          height: 80,
          width: width,
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: customButton("Add Reminder ", () async {
            // 1. Save to Firestore (or local DB)
            bool success = await addReminderMedicine(
              _pillNameController.text.trim(),
              _descController.text.trim(),
            );

            if (success) {
              showCustomSnackBar(
                context,
                "Medicine Added",
                backgroundColor: Colors.green,
              );

              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MediTrackPatient()),
              );
            } else {
              showCustomSnackBar(context, "Failed to add medicine");
            }
          }),
        ),
      ),
    );
  }
}
