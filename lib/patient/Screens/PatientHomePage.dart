import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/patient/Screens/AppointmentScreen.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/constants/UserConstants.dart';
import 'package:meditrack/shared/widgets/appointmentContainer.dart';
import 'package:meditrack/shared/widgets/cabinateContainer.dart';
import 'package:meditrack/shared/widgets/pillContainser.dart';

class PatitenHomeScreen extends StatelessWidget {
  const PatitenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String day = DateFormat('d').format(DateTime.now());
    String month = DateFormat('MMM').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Scaffold(
        appBar: AppBar(
          leading: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child:
                  (profileUrl == null || profileUrl.isEmpty)
                      ? Image.asset(
                        "assets/images/profile.jpg",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                      : Image.network(
                        profileUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
            ),
          ),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi ${userName.split(' ')[0]}!",
                style: TextStyle(fontSize: 25, color: CustomColors.textDark),
              ),
              Text(
                "How are you feel today?",
                style: TextStyle(fontSize: 20, color: CustomColors.textSub),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 5, right: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 1,
                Text(
                  " " + day + " " + month,
                  style: TextStyle(
                    color: CustomColors.textSub,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Pill Container
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Next Pill",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 23,
                      color: CustomColors.textSub,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                SizedBox(
                  // height: 200
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.maxFinite,
                  child: StreamBuilder(
                    stream:
                        defaultPatientDoc.collection('medicine').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Error while fetching data"),
                        ); // ✅ Add return
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No medicines found"));
                      } else {
                        final pills = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: pills.length,
                          itemBuilder: (context, index) {
                            final pill = pills[index];
                            final title = pill['pillName'] ?? 'No name';
                            final subtitle = pill['desc'] ?? '';
                            final value = pill['status'] ?? false;
                            final docId = pill.id;

                            return pillContainer(
                              pillName: title,
                              subtitle: subtitle,
                              value: value,
                              docId: docId,
                              context: context,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),

                // Appoint ment
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Scheduled Appointments",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientAppointmentScreen(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15,
                        color: CustomColors.textSub,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.maxFinite * 2.5,
                  height: 100,
                  child: StreamBuilder(
                    stream:
                        defaultPatientDoc.collection('scheduled').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Failed to fetch appointments"),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No appointments are scheduled"),
                        );
                      } else {
                        final data = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final doc = data[index];
                            final doctorName =
                                doc['doctorName'] ?? 'Unknown Doctor';
                            final reason = doc['desc'] ?? '';
                            final timestamp = doc['time'];
                            final DateTime dateTime = timestamp.toDate();
                            final width = MediaQuery.of(context).size.width;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              PatientAppointmentScreen(),
                                    ),
                                  );
                                },
                                child: appointmentContainer(
                                  doctorName,
                                  reason,
                                  dateTime,
                                  width,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 15),

                // Cabinate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Cabinet",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Your logic here
                      },
                      child: Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                              fontSize: 15,
                              color: CustomColors.textSub,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                            color: CustomColors.textSub,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  width:
                      150, // Important to give fixed height for horizontal ListView
                  child: StreamBuilder(
                    stream: defaultPatientDoc.collection('cabinet').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error if Fetching Cabinets"),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No Cabinet Added"));
                      } else {
                        final data = snapshot.data!.docs;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final cabinet = data[index];
                              return cabinateContainer(
                                cabinet['pillName'],
                                10,
                                50,
                                cabinet['desc'],
                              );
                            },
                          ),
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
    );
  }
}
