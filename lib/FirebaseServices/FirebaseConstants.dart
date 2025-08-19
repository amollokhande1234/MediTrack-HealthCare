import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meditrack/FirebaseServices/Notification.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

final FirebaseNotification firebaseNotification = FirebaseNotification();
User getCurrentUser() {
  final user = auth.currentUser;
  if (user == null) {
    throw Exception("No user is currently logged in");
  }
  return user;
}

final reminderId =
    'R${getCurrentUser().uid}_${DateTime.now().millisecondsSinceEpoch}';

final defaultPatientDoc = fireStore
    .collection('patients')
    .doc(getCurrentUser().uid)
    .collection('reminders')
    .doc('default');

final defaultDoctorDoc = fireStore
    .collection('doctors')
    .doc(getCurrentUser().uid)
    .collection('appointments')
    .doc('default');

Future<void> addPatientIfNotExists({
  required String doctorUid,
  required String path,
  required String patientUid,
}) async {
  final docRef = FirebaseFirestore.instance.collection(path).doc(doctorUid);

  final snapshot = await docRef.get();

  if (snapshot.exists) {
    List<dynamic> chatMemberList = snapshot.data()?['patients'] ?? [];
    if (!chatMemberList.contains(patientUid)) {
      await docRef.update({
        'chatMemberList': FieldValue.arrayUnion([patientUid]),
      });
    }
  } else {
    await docRef.set({
      'chatMemberList': [patientUid],
    });
  }
}

Future<void> createChatOnAccept({
  required String senderUid,
  required String senderName,
  required String receiveUid,
  required String receiverName,
  required String path,
  required String currUid,
}) async {
  final firestore = FirebaseFirestore.instance;

  // Create a consistent chatId
  final chatId = [senderUid, receiveUid]..sort();
  final chatIdStr = chatId.join('_');

  // Create or update the chat document
  await firestore
      .collection(path)
      .doc(currUid)
      .collection('chats')
      .doc(chatIdStr)
      .set({
        'chatId': chatIdStr,
        'senderUid': senderUid,
        'receiverUid': receiveUid,
        'receiverName': receiverName,
        'senderName': senderName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
      }, SetOptions(merge: true));
}
