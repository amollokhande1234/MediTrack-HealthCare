import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/main_patient.dart';
import 'package:meditrack/patient/Pages/Appointment/ProceddScreen.dart';
import 'package:meditrack/patient/PatientApp.dart';
import 'package:meditrack/shared/widgets/custoButton.dart';
import 'package:meditrack/shared/widgets/customAppBar.dart';
import 'package:meditrack/shared/widgets/customDoctorTile.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';
import 'package:meditrack/shared/widgets/showSnackBar.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  const ScheduleAppointmentScreen({super.key});

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  int? selectedIndex;
  Map<String, dynamic>? selectedDoctor;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: customAppBar(context, "Schedule Appointment"),
      body: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Medicine Image
                Center(
                  child: Container(
                    height: height * 0.2,
                    // width: width * 3,
                    child: Image.asset("assets/images/doctorAppointment.jpeg"),
                  ),
                ),
                SizedBox(height: 10),
                textFormFeild("Search Doctor ", controller: searchController),
                SizedBox(height: 10),

                Expanded(
                  child: StreamBuilder(
                    stream: fireStore.collection('doctors').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error While Fetching Doctors"),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No Doctor Available"));
                      } else {
                        final data = snapshot.data!.docs;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.length,
                          padding: const EdgeInsets.only(bottom: 90),
                          itemBuilder: (context, index) {
                            final doctor = data[index];
                            // selectedDoctorUid = doctor[index]['uid'];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: customDoctorTile(
                                'Dr. ${doctor['name'] ?? 'No Name'}',
                                doctor['specialist'] ?? 'Specialist',
                                "https://as1.ftcdn.net/jpg/02/99/04/20/1000_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg",
                                selected: selectedIndex == index,
                                onChanged: (value) {
                                  setState(() {
                                    selectedIndex = index;
                                    selectedDoctor =
                                        doctor.data() as Map<String, dynamic>;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        height: 80,
        width: width,
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: customButton("Proceed", () {
          print(selectedDoctor);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProceedScreen(selectedDoctor: selectedDoctor),
            ),
          );
        }),
      ),
    );
  }
}
