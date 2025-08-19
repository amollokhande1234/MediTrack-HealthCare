// import 'package:flutter/material.dart';

// class MessagesScreen extends StatelessWidget {
//   const MessagesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Messages")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(12),
//               children: const [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: ChatBubble(text: "Hello!"),
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ChatBubble(text: "Hi! How are you?"),
//                 ),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: ChatBubble(text: "I'm good, thanks!"),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(icon: const Icon(Icons.send), onPressed: () {}),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String text;

//   const ChatBubble({super.key, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(text),
//     );
//   }
// }
