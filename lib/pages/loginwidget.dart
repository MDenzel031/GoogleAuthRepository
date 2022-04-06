import 'dart:async';
import 'dart:developer';

import 'package:dear_diary_fixed/authenticate.dart';
import 'package:dear_diary_fixed/provider/counter.dart';
import 'package:dear_diary_fixed/provider/google_sign_in.dart';
import 'package:dear_diary_fixed/services/database.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:dear_diary_fixed/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoggedinWidget extends StatefulWidget {
  const LoggedinWidget({Key? key}) : super(key: key);

  @override
  State<LoggedinWidget> createState() => _LoggedinWidgetState();
}

class _LoggedinWidgetState extends State<LoggedinWidget> {
  Database db = Database();
  bool isLoading = false;

  var user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;

  late Timer timer;

  var userData = null, isVerified = false;

  displayUserInformation() async {
    db.getUserData(user!.uid).then((value) => {
          userData = value,
          if (mounted)
            {
              setState(() {
                isLoading = false;
              })
            }
        });
  }

  checkIfVerified() async {
    if (mounted) {
      isVerified = user!.emailVerified;
    }
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    checkIfVerified();
    
    if (isVerified == false) {
      user!.sendEmailVerification();
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        checkEmailVerified();
      });
    }

    super.initState();
    displayUserInformation();
  }

  Future<void> checkEmailVerified() async {
    // await user!.reload();
    try {
      await user!.reload();
      user = await auth.currentUser;

      if (user!.emailVerified) {
        timer.cancel();
        setState(() {
          isVerified = true;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isVerified ? IsVerified() : IsNotVerified();
  }

  Widget IsVerified() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logged In'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSigninProvider>(context, listen: false);
              provider.logout();

              // FirebaseAuth.instance.signOut();
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => Authenticate()));
            },
            style: TextButton.styleFrom(primary: Colors.white),
            child: Text('Logout'),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<Counter>().decrement(),
            key: Key('decrement_floatingActionButton'),
            child: Icon(Icons.remove),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => context.read<Counter>().reset(),
            key: Key('reset_floatingActionButton'),
            child: Icon(Icons.exposure_zero),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => {context.read<Counter>().increment()},
            key: Key('increment_floatingActionButton'),
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: isLoading
          ? loadingScreen()
          : Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('${userData['userimage']}'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Name: ${userData['username']}',
                    style: simpleTextStyle(),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: ${user!.email}',
                    style: simpleTextStyle(),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Counter: ${context.watch<Counter>().count}',
                    style: simpleTextStyle(),
                  )
                ],
              ),
            ),
    );
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
