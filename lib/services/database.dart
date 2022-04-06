import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dear_diary_fixed/pages/loginwidget.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Database {
  final colReference = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;

  Future addUserInformation(String username, String uid,
      {String userimage =
          "https://cdn0.iconfinder.com/data/icons/user-pictures/100/unknown2-512.png"}) async {
    return await colReference.doc(uid).set({
      'username': username,
      'userimage': userimage,
    });
  }

  Future getUserData(String uid) async {
    var user = await colReference.doc(uid).get();

    return user;
  }
}
