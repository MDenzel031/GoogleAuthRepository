import 'dart:developer';

import 'package:dear_diary_fixed/authenticate.dart';
import 'package:dear_diary_fixed/pages/loginwidget.dart';
import 'package:dear_diary_fixed/pages/setup/choose.dart';
import 'package:dear_diary_fixed/pages/signupwidget.dart';
import 'package:dear_diary_fixed/pages/verifyemail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError){
              return Center(child:Text('Something went Wrong'));
            }else if(snapshot.hasData){
              log('User: ${snapshot.data}');
              return LoggedinWidget();
            }
            else {
              return Authenticate();
            }
          }),
    );
  }
}
