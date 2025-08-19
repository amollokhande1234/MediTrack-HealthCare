import 'package:flutter/material.dart';

Widget messageBubble({
  required String senderName,
  required String message,
  bool isMe = false,
}) {
  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[200] : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
          bottomRight: isMe ? Radius.zero : const Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            senderName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(message, style: const TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );
}
