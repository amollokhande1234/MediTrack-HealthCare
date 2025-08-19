import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/main_patient.dart';
import 'package:meditrack/patient/PatientApp.dart';
import 'package:meditrack/shared/widgets/DateTimeBuildBox.dart';
import 'package:meditrack/shared/widgets/custoButton.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';
import 'package:meditrack/shared/widgets/datePicker.dart';
import 'package:meditrack/shared/widgets/doctorContainer.dart';
import 'package:meditrack/shared/widgets/showSnackBar.dart';

class ProceedScreen extends StatefulWidget {
  // Map<String, dynamic> doctor;
  Map<String, dynamic>? selectedDoctor;
  ProceedScreen({super.key, required this.selectedDoctor});

  @override
  State<ProceedScreen> createState() => _ProceedScreenState();
}

class _ProceedScreenState extends State<ProceedScreen> {
  DateTime? selectedDate;

  TimeOfDay? selectedTime;
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    // Firebase Store
    Future<bool> addAppointment(String doctorId, String desc) async {
      try {
        final _user = getCurrentUser();
        Timestamp remiderTime = getDateTimeAsTimestamp(
          selectedDate,
          selectedTime,
        );
        final currSnapshot =
            await fireStore.collection('patients').doc(_user.uid).get();
        final data = currSnapshot.data();

        final patRef =
            fireStore
                .collection('patients')
                .doc(getCurrentUser().uid)
                .collection('reminders')
                .doc('default')
                .collection('inQueue')
                .doc();
        final docRef =
            fireStore
                .collection('doctors')
                .doc(widget.selectedDoctor!['uid'])
                .collection('appointments')
                .doc('default')
                .collection('inQueue')
                .doc();
        docRef.set({
          'doctorName': widget.selectedDoctor!['name'],
          'drUid': widget.selectedDoctor!['uid'],
          'ptUid': getCurrentUser().uid,
          'ptName': data!['name'] ?? "No Name",
          'specialist': widget.selectedDoctor!['specialist'],
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'desc': desc,
          'appId': patRef.id,
          'time': remiderTime,
        });
        await docRef.update({'docId': patRef.id});
        patRef.set({
          'doctorName': widget.selectedDoctor!['name'],
          'drUid': widget.selectedDoctor!['uid'],
          'ptUid': getCurrentUser().uid,
          'specialist': widget.selectedDoctor!['specialist'],
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'desc': desc,
          'appId': patRef.id,
          'time': remiderTime,
        });
        await patRef.update({'docId': docRef.id});
        return true;
      } catch (e) {
        print("Error while Scheduling Appointment");
        return false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              doctorContainer(
                "Dr. ${widget.selectedDoctor!['name']}" ?? "NA",
                widget.selectedDoctor!['specialist'] ?? "NA",
                "https://as1.ftcdn.net/jpg/02/99/04/20/1000_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg",
                widget.selectedDoctor!['degree'] ?? "NA",
                widget.selectedDoctor!['age'] ?? "NA",
                widget.selectedDoctor!['gender'] ?? "NA",
                widget.selectedDoctor!['number'] ?? "NA",
                widget.selectedDoctor!['address'] ?? "NA",
              ),
              Divider(),
              SizedBox(height: 20),
              textFormFeild("Description", controller: descController),
              SizedBox(height: 20),
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
      ),
      bottomSheet: SafeArea(
        child: Container(
          height: 80,
          width: width,
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: customButton("Schedule Appointment", () async {
            bool sucess = await addAppointment(
              widget.selectedDoctor!['uid'],
              descController.text.trim(),
            );

            if (sucess) {
              showCustomSnackBar(
                context,
                "Appoinment Added in Queue",
                backgroundColor: Colors.greenAccent,
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PatientApp()),
                (route) => false,
              );
            } else {
              showCustomSnackBar(context, "Error while Making Apointment");
            }
          }),
        ),
      ),
    );
  }
}
