import 'package:flutter/material.dart';

Widget chatMemberTile({
  required String name,
  required String lastMessage,
  required String time,
  String? avatarUrl,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 25,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child:
                avatarUrl == null
                    ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : "?",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    )
                    : null,
          ),
          const SizedBox(width: 12),

          // Name & last message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Time
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    ),
  );
}
