import 'package:dear_diary_fixed/pages/setup/signin.dart';
import 'package:dear_diary_fixed/pages/setup/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleView);
    }else{
      return SignUp(toggleView);
    }
  }
}