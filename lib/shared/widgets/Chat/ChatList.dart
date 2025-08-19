import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/patient/Pages/Chat/MessegesScreen.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/Chat/IndividualMessegeScreen.dart';
import 'package:meditrack/shared/widgets/Chat/chatMemberTile.dart';
import 'package:meditrack/shared/widgets/Chat/messageBubble.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';

class chatList extends StatefulWidget {
  final Stream stream;
  final String appBarText;
  final String text;
  const chatList({
    super.key,
    required this.appBarText,
    required this.text,
    required this.stream,
  });

  @override
  State<chatList> createState() => _chatListState();
}

class _chatListState extends State<chatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.chat, color: CustomColors.accentPurple),
        title: Text(
          'Chat with ${widget.appBarText}',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: CustomColors.primaryPurple,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: textFormFeild("Search ${widget.text}"),
            ),

            // Showing the scheduled chat
            Expanded(
              child: StreamBuilder(
                stream: widget.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("No chats available"));
                  }

                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,

                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      return chatMemberTile(
                        name: data['receiverName'],
                        lastMessage: data['lastMessage'],
                        time: TimeOfDay.now().toString(),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => IndividualMessageScreen(
                                    chatId: data['chatId'],
                                    senderName: data['senderName'],
                                    receiverName: data['receiverName'],
                                    senderId: data['senderUid'],
                                    receiverId: data['receiverUid'],
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getChatid(String sender, String rec) {
    return sender + rec;
  }
}
