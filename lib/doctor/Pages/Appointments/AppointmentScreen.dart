import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('appointments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text("No Appointments"));

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final data = appointments[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(data['patientName'] ?? 'Unknown Patient'),
                  subtitle: Text("Time: ${data['time'] ?? 'N/A'}"),
                  trailing: Icon(
                    data['approved'] == true
                        ? Icons.check_circle
                        : Icons.pending,
                    color:
                        data['approved'] == true ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
