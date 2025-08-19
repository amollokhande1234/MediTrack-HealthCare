// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class DateTimeSelector extends StatefulWidget {
//   final String pillName;
//   final String desc;

//   const DateTimeSelector({Key? key, required this.pillName, required this.desc})
//     : super(key: key);
//   @override
//   _DateTimeSelectorState createState() => _DateTimeSelectorState();
// }

// class _DateTimeSelectorState extends State<DateTimeSelector> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Date Picker Row
//         GestureDetector(
//           onTap: _pickDate,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildBox(day, "Day"),
//               SizedBox(width: 10),
//               _buildBox(month, "Month"),
//               SizedBox(width: 10),
//               _buildBox(year, "Year"),
//             ],
//           ),
//         ),
//         SizedBox(height: 20),
//         // Time Picker Row
//         GestureDetector(
//           onTap: _pickTime,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildBox(hour, "Hour"),
//               SizedBox(width: 10),
//               _buildBox(minute, "Min"),
//               SizedBox(width: 10),
//               _buildBox(period, "AM/PM"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
