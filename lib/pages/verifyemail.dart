import 'dart:async';

import 'package:dear_diary_fixed/pages/loginwidget.dart';
import 'package:dear_diary_fixed/provider/google_sign_in.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;

  late Timer timer;

  Future<void> checkEmailVerified() async {
    await user!.reload();
    if (user!.emailVerified) {
      timer.cancel();
      Route route = MaterialPageRoute(builder: (_) => LoggedinWidget());
      Navigator.pushReplacement(context, route);
    }
  }

    @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    user!.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds:5), (timer){
      checkEmailVerified();
    });
    super.initState();
  }

  

 

  @override
  Widget build(BuildContext context) {
    return IsNotVerified();
  }

  Widget IsNotVerified() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Not Verified'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSigninProvider>(context, listen: false);
              provider.logout();
            },
            style: TextButton.styleFrom(primary: Colors.white),
            child: Text('Logout'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.email),
          onPressed: () {
            displayToast('Email has been sent');
          }),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 8,
            ),
            Text('Email has been sent!'),
            SizedBox(
              height: 8,
            ),
            Text('Please verify you email before using the app'),
          ],
        ),
      ),
    );
  }
}
