import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/completAndCacelAppointment.dart';

class PatientAppointmentScreen extends StatelessWidget {
  const PatientAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Appointments",
            style: TextStyle(
              color: CustomColors.textDark,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: TabBar(
            indicator: BoxDecoration(
              color: CustomColors.primaryPurple,
              borderRadius: BorderRadius.circular(5),
            ),
            labelColor: Colors.black,
            labelPadding: EdgeInsets.only(left: 2),
            tabs: [
              tabBarContainer("InQueue"),
              tabBarContainer("Schedule"),
              tabBarContainer("Complete"),
              tabBarContainer("Cancel"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // In Queue
            StreamBuilder(
              stream: defaultPatientDoc.collection('inQueue').snapshots(),
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
                    var doc = data[index];
                    Timestamp timestamp = doc['time'];
                    DateTime time = timestamp.toDate();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: completAndCancelAppointmentContainer(
                        width: width / 1.5,
                        height: height,
                        drName: "Dr. ${doc['doctorName']}",
                        subtitle: doc['desc'],
                        bgColor: CustomColors.cardLightPink,
                        dateTime: time,
                        checkText: "Pending",
                      ),
                    );
                  },
                );
              },
            ),

            // Sheduled
            StreamBuilder(
              // stream: defaultPatientDoc.collection('scheduled').snapshots(),
              stream:
                  fireStore
                      .collection('patients')
                      .doc(getCurrentUser().uid)
                      .collection('reminders')
                      .doc('default')
                      .collection('scheduled')
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
                    var doc = data[index];
                    Timestamp timestamp = doc['time'];
                    DateTime time = timestamp.toDate();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: scheduledAppointmentContainer(
                        width: width / 1.5,
                        height: height,
                        drName: doc['doctorName'],
                        drSpecification: 'NA',
                        dateTime: time,
                      ),
                    );
                  },
                );
              },
            ),

            // Completed
            StreamBuilder(
              stream: defaultPatientDoc.collection('complete').snapshots(),
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
                    var doc = data[index];
                    Timestamp timestamp = doc['time'];
                    DateTime time = timestamp.toDate();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: completAndCancelAppointmentContainer(
                        width: width / 1.5,
                        height: height,
                        drName: doc['doctorName'],
                        subtitle: "NA",
                        bgColor: CustomColors.cardLightPink,
                        dateTime: time,
                        checkText: "Pending",
                      ),
                    );
                  },
                );
              },
            ),

            // Cancel
            StreamBuilder(
              stream: defaultPatientDoc.collection('cancel').snapshots(),
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
                    var doc = data[index];
                    Timestamp timestamp = doc['time'];
                    DateTime time = timestamp.toDate();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: completAndCancelAppointmentContainer(
                        width: width / 1.5,
                        height: height,
                        drName: doc['doctorName'],
                        subtitle: doc['description'] ?? "NA",
                        bgColor: CustomColors.cardLightPink,
                        dateTime: time,
                        checkText: "Pending",
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget tabBarContainer(String title) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        // color: Colors.amber,
        color: CustomColors.calendarBlue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: CustomColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Scheduled Appointment Container
  Widget scheduledAppointmentContainer({
    required double width,
    required double height,
    required String drName,
    required String drSpecification,
    required DateTime dateTime,
  }) {
    String dayName = DateFormat('EEEE').format(dateTime); // Monday
    String monthDay = DateFormat('MMM d').format(dateTime); // Aug 29
    String startTime = DateFormat('HH:mm').format(dateTime); // 11:00
    String endTime = DateFormat(
      'HH:mm',
    ).format(dateTime.add(Duration(hours: 1))); // 12:00

    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.cardLightPink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor info
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/profile.jpg",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: CustomColors.textDark,
                    ),
                  ),
                  Text(
                    drSpecification,
                    style: TextStyle(color: CustomColors.textSub, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),

          // Appointment time and date row
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  '$dayName, $monthDay',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.textDark,
                  ),
                ),
                Spacer(),
                Icon(Icons.access_time, size: 18, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  '$startTime - $endTime WIB',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Cancel and Reschedule buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textDark,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Reschedule",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textDark,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Color(0xFF3DC3F5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
