import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dear_diary_fixed/services/database.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  Database db = Database();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var id;
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) => {id = value.user!.uid});

      if (checkIfDocExists(_user!.id) == true) {
      } else {
        db.addUserInformation(_user!.displayName.toString(), id,
            userimage: _user!.photoUrl.toString());
      }

      notifyListeners();
    } catch (error) {
      log(error.toString());
    }
  }

  Future logout() async {
    if (googleSignIn.currentUser != null) {
      await googleSignIn.disconnect();
    }
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<bool> checkIfDocExists(String uid) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = await FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
      throw e;
    }
  }
}
