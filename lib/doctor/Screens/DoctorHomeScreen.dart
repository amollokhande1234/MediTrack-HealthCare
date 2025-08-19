import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';

import 'package:meditrack/doctor/Pages/Appointments/PaitientContainer.dart';

import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/completAndCacelAppointment.dart';

import 'package:meditrack/shared/widgets/tabContainer.dart';

// ========== doctor_home.dart ==========

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Scaffold(
          appBar: AppBar(
            leading: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: Image.asset(
                  "assets/images/profile.jpg",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Nav Bar values
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello Doctor!",
                  style: TextStyle(fontSize: 25, color: CustomColors.textDark),
                ),
                Text(
                  "How was your day Going?",
                  style: TextStyle(fontSize: 16, color: CustomColors.textSub),
                ),
              ],
            ),
            actions: [
              Icon(Icons.menu, color: CustomColors.primaryPurple, size: 30),
            ],

            // Tabs
            bottom: TabBar(
              tabs: [
                tabBarContainer("InQueue", width * 3),
                tabBarContainer("Schedule", width * 3),
                tabBarContainer("Complete", width * 3),
                tabBarContainer("Cancel", width * 3),
              ],
            ),
          ),

          // Home Tab Start
          body: TabBarView(
            children: [
              // In Queue
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Expanded(
                  child: StreamBuilder(
                    stream:
                        fireStore
                            .collection('doctors')
                            .doc(getCurrentUser().uid)
                            .collection('appointments')
                            .doc('default')
                            .collection('inQueue')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No chats available"));
                      }

                      final data = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final patient = data[index];
                          Timestamp timestamp =
                              patient['time']; // from Firestore
                          DateTime dateTime = timestamp.toDate();
                          return ProfileCard(
                            dateTime: dateTime,
                            acceptTap: () async {
                              try {
                                final appointmentId =
                                    patient.id; // real appointment ID

                                // Get the inQueue appointment data
                                final _inQueueSnapshot =
                                    await defaultDoctorDoc
                                        .collection('inQueue')
                                        .doc(appointmentId)
                                        .get();

                                final _appointmentData =
                                    _inQueueSnapshot.data();
                                if (_appointmentData == null) {
                                  print(
                                    "No appointment data for ID: $appointmentId",
                                  );
                                  return;
                                }

                                // References
                                final _doctorAppRef = await fireStore
                                    .collection('doctors')
                                    .doc(patient['drUid'])
                                    .collection('appointment')
                                    .doc('default')
                                    .collection('scheduled')
                                    .doc(appointmentId);

                                final _patientAppRef = fireStore
                                    .collection('patients')
                                    .doc(patient['ptUid'])
                                    .collection('reminders')
                                    .doc('default')
                                    .collection('scheduled')
                                    .doc(appointmentId);

                                // Add to Doctor Scheduled
                                await _doctorAppRef.set({
                                  ..._appointmentData,
                                  'status': 'scheduled',
                                  'time': FieldValue.serverTimestamp(),
                                });

                                // Add to Patient Scheduled
                                await _patientAppRef.set({
                                  ..._appointmentData,
                                  'status': 'scheduled',
                                  'time': FieldValue.serverTimestamp(),
                                });

                                // Remove from both inQueue
                                await fireStore
                                    .collection('patients')
                                    .doc(patient['ptUid'])
                                    .collection('reminders')
                                    .doc('default')
                                    .collection('inQueue')
                                    .doc(appointmentId)
                                    .delete();

                                await fireStore
                                    .collection('doctors')
                                    .doc(patient['drUid'])
                                    .collection('appointments')
                                    .doc('default')
                                    .collection('inQueue')
                                    .doc(appointmentId)
                                    .delete();

                                // Doctors
                                createChatOnAccept(
                                  currUid: patient['drUid'],
                                  path: 'doctors',
                                  senderName: patient['doctorName'],
                                  senderUid: patient['drUid'],
                                  receiveUid: patient['ptUid'],
                                  receiverName: patient['ptName'],
                                );

                                // Patients
                                createChatOnAccept(
                                  currUid: patient['ptUid'],
                                  path: 'patients',
                                  senderName: patient['ptUid'],
                                  senderUid: patient['ptUid'],
                                  receiveUid: patient['drUid'],
                                  receiverName: patient['doctorName'],
                                );

                                print(
                                  "Appointment moved to scheduled successfully!",
                                );
                              } catch (e) {
                                print("Error moving appointment: $e");
                              }
                            },

                            // Cansel Button
                            declineTap: () async {
                              try {
                                final appointmentId =
                                    patient.id; // real appointment ID

                                // Get the inQueue appointment data
                                final _inQueueSnapshot =
                                    await fireStore
                                        .collection('doctors')
                                        .doc(patient['drUid'])
                                        .collection('appointments')
                                        .doc('default')
                                        .collection('inQueue')
                                        .doc(appointmentId)
                                        .get();

                                final _appointmentData =
                                    _inQueueSnapshot.data();
                                if (_appointmentData == null) {
                                  print(
                                    "No appointment data for ID: $appointmentId",
                                  );
                                  return;
                                }

                                // References
                                final _doctorAppRef = await fireStore
                                    .collection('patients')
                                    .doc(patient['drUid'])
                                    .collection('appointments')
                                    .doc('default')
                                    .collection('cansel')
                                    .doc(appointmentId);

                                final _patientAppRef = fireStore
                                    .collection('patients')
                                    .doc(patient['ptUid'])
                                    .collection('reminders')
                                    .doc('default')
                                    .collection('cansel')
                                    .doc(appointmentId);

                                // Add to Doctor Scheduled
                                await _doctorAppRef.set({
                                  ..._appointmentData,
                                  'status': 'canceled',
                                  'time': FieldValue.serverTimestamp(),
                                });

                                // Add to Patient Scheduled
                                await _patientAppRef.set({
                                  ..._appointmentData,
                                  'status': 'canceled',
                                  'time': FieldValue.serverTimestamp(),
                                });

                                // Remove from both inQueue
                                await fireStore
                                    .collection('patients')
                                    .doc(patient['ptUid'])
                                    .collection('reminders')
                                    .doc('default')
                                    .collection('inQueue')
                                    .doc(appointmentId)
                                    .delete();

                                await fireStore
                                    .collection('doctors')
                                    .doc(patient['drUid'])
                                    .collection('appointments')
                                    .doc('default')
                                    .collection('inQueue')
                                    .doc(appointmentId)
                                    .delete();

                                print(
                                  "Appointment moved to Casel successfully!",
                                );
                              } catch (e) {
                                print("Error moving appointment: $e");
                              }
                            },
                            imgUrl:
                                "https://as1.ftcdn.net/jpg/02/99/04/20/1000_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg",
                            // pName: patient['ptName'] ?? "NO Name",
                            pName: patient['ptName'],
                            pNumber: patient['desc'],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Scheduled
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Expanded(
                  child: StreamBuilder(
                    stream:
                        defaultDoctorDoc.collection('scheduled').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No chats available"));
                      }

                      final data = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final patient = data[index];
                          Timestamp timestamp =
                              patient['time']; // from Firestore
                          DateTime dateTime = timestamp.toDate();
                          return completAndCancelAppointmentContainer(
                            width: width / 1.5,
                            height: 250,
                            drName: patient['patientName'],
                            dateTime: dateTime,
                            checkText: "Scheduled",
                            bgColor: Colors.greenAccent,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Completed
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Expanded(
                  child: StreamBuilder(
                    stream: defaultDoctorDoc.collection('complete').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No chats available"));
                      }

                      final data = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: completAndCancelAppointmentContainer(
                              // width: MediaQuery.of(context).size.width,
                              width: width / 1.5,
                              height: 250,
                              drName: "Anastasya Syahid",
                              // drSpecification: "Dental Specialist",
                              dateTime: DateTime(2025, 8, 29, 11, 0),
                              checkText: "Canceled",
                              bgColor: Colors.redAccent.shade100,
                              // Aug 29, 11:00
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Cancel
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Expanded(
                  child: StreamBuilder(
                    stream:
                        fireStore
                            .collection('doctors')
                            .doc(getCurrentUser().uid)
                            .collection('appointments')
                            .doc('default')
                            .collection('cansel')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("No chats available"));
                      }

                      final data = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final patient = data[index];
                          Timestamp timestamp =
                              patient['time']; // from Firestore
                          DateTime dateTime = timestamp.toDate();
                          return completAndCancelAppointmentContainer(
                            // width: MediaQuery.of(context).size.width,
                            width: width / 1.5,
                            height: 250,
                            drName: patient['patientName'],
                            // drSpecification: "Dental Specialist",
                            dateTime: dateTime,
                            checkText: "Completed", // Aug 29, 11:00
                            bgColor: Colors.redAccent.shade100,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
