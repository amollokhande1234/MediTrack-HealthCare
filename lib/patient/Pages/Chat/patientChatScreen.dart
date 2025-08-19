// import 'package:flutter/material.dart';

// class PatientChatScreen extends StatefulWidget {
//   final String doctorName;

//   const PatientChatScreen({super.key, required this.doctorName});

//   @override
//   State<PatientChatScreen> createState() => _PatientChatScreenState();
// }

// class _PatientChatScreenState extends State<PatientChatScreen> {
//   final List<Map<String, dynamic>> _messages = [
//     {'text': 'Hello Doctor!', 'isMe': true},
//     {'text': 'Hello! How can I help you?', 'isMe': false},
//   ];

//   final TextEditingController _controller = TextEditingController();

//   void _sendMessage() {
//     final text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         _messages.add({'text': text, 'isMe': true});
//         _controller.clear();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat with ${widget.doctorName}')),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 return Align(
//                   alignment:
//                       message['isMe']
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color:
//                           message['isMe']
//                               ? Colors.blue.shade100
//                               : Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(message['text']),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
