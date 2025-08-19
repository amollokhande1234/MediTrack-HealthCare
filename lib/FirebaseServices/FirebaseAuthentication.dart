import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';

Future<bool> loginUser(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print('Login Error: $e');
    return false;
  }
}

Future<bool> signUpDoctor(
  String name,
  String email,
  String pass,
  String number,
) async {
  try {
    // make creadential first
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );

    // stores the data in firestore
    await fireStore.collection('doctors').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'name': name,
      'email': email,
      'number': number,
      'createdAt': Timestamp.now(),
    });
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> signUpPatient(
  String name,
  String email,
  String pass,
  String number,
) async {
  try {
    // make creadential first
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );

    // stores the data in firestore
    await fireStore.collection('patients').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'name': name,
      'email': email,
      'number': number,
      'createdAt': Timestamp.now(),
    });
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

void logOut() async {
  await auth.signOut();
}
