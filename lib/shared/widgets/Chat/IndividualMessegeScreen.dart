import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/customAppBar.dart';

class IndividualMessageScreen extends StatefulWidget {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String receiverName;

  const IndividualMessageScreen({
    Key? key,
    required this.chatId,
    required this.senderName,
    required this.receiverName,
    required this.senderId,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<IndividualMessageScreen> createState() =>
      _IndividualMessageScreenState();
}

class _IndividualMessageScreenState extends State<IndividualMessageScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    await firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
          'senderUid': widget.senderId, // ✅ fixed naming
          'receiverUid': widget.receiverId,
          'senderName': widget.senderName,
          'receiverName': widget.receiverName,
          'text': text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

    _messageController.clear();

    // ✅ Auto-scroll to latest message
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, widget.receiverName),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  firestore
                      .collection('chats')
                      .doc(widget.chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var data = messages[index].data() as Map<String, dynamic>;
                    bool isMe = data['senderUid'] == widget.senderId;

                    // Decide name to display
                    String displayName =
                        isMe
                            ? "You"
                            : (widget.receiverName ?? widget.receiverName);

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft:
                                isMe
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                            bottomRight:
                                isMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              displayName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: isMe ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Message text
                            Text(
                              data['text'] ?? '',
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Timestamp
                            Text(
                              formatTime(data['timestamp']),
                              style: TextStyle(
                                fontSize: 10,
                                color: isMe ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          buildMessageInput(_messageController),
        ],
      ),
    );
  }

  Widget buildMessageInput(TextEditingController _messageController) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: CustomColors.cardLightPink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => sendMessage(_messageController.text),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CustomColors.primaryPurple,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
