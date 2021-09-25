import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;
TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _userName = TextEditingController();
final dbRef = FirebaseDatabase.instance.reference();
final signedInUser = FirebaseAuth.instance.currentUser;

class FirebaseServices {
  // Create a new firebase user
  Future<void> createNewUser() async {
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .then((value) {
        String username = _userName.text;
        dbRef.child('users').child(value.user!.uid).set({
          'username': username,
          'email': value.user!.email,
          'id': value.user!.uid,
          'TimeStamp': DateTime.now().toString()
        });
      });
    } catch (e) {
      String errorMessage = e.toString().replaceRange(0, 14, '').split(']')[1];
      print(errorMessage);
    }
  }

  // sign out user
  Future<void> signOut() async {
    await auth.signOut();
    print('user signed out');
  }
}
