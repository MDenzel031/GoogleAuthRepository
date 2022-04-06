import 'dart:developer';

import 'package:dear_diary_fixed/services/database.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  Database db = Database();

  Future createUser(String email, String password, String username) async {
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) => {
                db.addUserInformation(username, result.user!.uid),
                auth.signInWithEmailAndPassword(
                    email: email, password: password)
              })
          .catchError((error) {
        displayToast(error.message.toString());
      });
    } catch (e) {
      displayToast(e.toString());
    }
  }

    Future signUser(String email, password, BuildContext context) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) => {
                // Navigator.pushReplacement(
                // context, MaterialPageRoute(builder: (context) => LoggedinWidget()))
                log('Successfully Login')
              });
      
    } catch (e) {
      displayToast(e.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      displayToast('Reset Password has been sent');
      return true;
    } catch (e) {
      displayToast(e.toString());
      return false;
    }
  }
}
