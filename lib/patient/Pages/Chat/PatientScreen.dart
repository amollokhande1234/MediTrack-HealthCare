// import 'package:flutter/material.dart';

// class PatientScreen extends StatelessWidget {
//   final List<Map<String, String>> patients = [
//     {'name': 'John Doe', 'age': '30', 'issue': 'Fever'},
//     {'name': 'Jane Smith', 'age': '25', 'issue': 'Migraine'},
//     {'name': 'David Johnson', 'age': '40', 'issue': 'Diabetes'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Patients")),
//       body: ListView.builder(
//         itemCount: patients.length,
//         itemBuilder: (context, index) {
//           final patient = patients[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: ListTile(
//               leading: const Icon(Icons.person),
//               title: Text(patient['name'] ?? 'Unknown'),
//               subtitle: Text(
//                 "Age: ${patient['age']} • Issue: ${patient['issue']}",
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 // Navigate to detailed patient info screen (optional)
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
