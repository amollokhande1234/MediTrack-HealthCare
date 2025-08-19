import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/main_patient.dart';
import 'package:meditrack/patient/PatientApp.dart';
import 'package:meditrack/shared/widgets/DateTimeBuildBox.dart';
import 'package:meditrack/shared/widgets/custoButton.dart';
import 'package:meditrack/shared/widgets/customAppBar.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';
import 'package:meditrack/shared/widgets/datePicker.dart';
import 'package:meditrack/shared/widgets/showSnackBar.dart';

class CabinetAddScreen extends StatefulWidget {
  const CabinetAddScreen({super.key});

  @override
  State<CabinetAddScreen> createState() => _CabinetAddScreenState();
}

class _CabinetAddScreenState extends State<CabinetAddScreen> {
  final TextEditingController _pillNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

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

    // Firebase Store
    Future<bool> addCabinet(
      String cabinetName,
      String desc,
      String quantity,
    ) async {
      try {
        final _user = getCurrentUser();
        if (_user == null) return false;

        if (cabinetName.isNotEmpty && desc.isNotEmpty && quantity.isNotEmpty) {
          Timestamp remiderTime = getDateTimeAsTimestamp(
            selectedDate,
            selectedTime,
          );
          await defaultPatientDoc.collection('cabinet').add({
            'remindTime': remiderTime,
            'pillName': cabinetName,
            'desc': desc,
            'quntity': quantity,
            'createdAt': FieldValue.serverTimestamp(),
            'taken': false,
          });
          return true;
        } else {
          showCustomSnackBar(
            context,
            "All feilds are required",
            backgroundColor: Colors.redAccent,
          );
          return false;
        }
      } catch (e) {
        print("Error for Adding Reminder");
        return false;
      }
    }

    return Scaffold(
      appBar: customAppBar(context, "Add Cabinet"),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Medicine Image
            Center(
              child: Container(
                height: height * 0.2,
                // width: width * 3,
                child: Image.asset("assets/images/mediKit.png"),
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
                    "Add Description",
                    controller: _descController,
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                  textFormFeild(
                    "Add Quantity",
                    controller: _quantityController,
                    inputType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Text("Pick Date & Time "),
                  SizedBox(height: 10),
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
          ],
        ),
      ),
      bottomSheet: SafeArea(
        child: Container(
          height: 80,
          width: width,
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: customButton("Add Cabinet", () async {
            bool success = await addCabinet(
              _pillNameController.text.trim(),
              _descController.text.trim(),
              _quantityController.text.trim(),
            );
            if (success) {
              showCustomSnackBar(context, "Cabinet Successfully Added");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PatientApp()),
                (route) => false,
              );
            } else {
              Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }
}
