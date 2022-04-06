import 'dart:developer';

import 'package:dear_diary_fixed/pages/homepage.dart';
import 'package:dear_diary_fixed/provider/google_sign_in.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:dear_diary_fixed/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Choose extends StatefulWidget {
  const Choose({Key? key}) : super(key: key);

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  @override
  Widget build(BuildContext context){
    // Size size = MediaQuery.of(context).size;
    return HomePage();
  }
}


class ChoosePage extends StatelessWidget {
  const ChoosePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: HexColor('#67595E'),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 80),
                  child: FlutterLogo(size: 120),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hey There,\nWelcome Back',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login to your account to continue',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(double.infinity, 50)),
                  icon: Icon(
                    Icons.email,
                    color: Colors.brown,
                  ),
                  onPressed: () {
                    log('Email Sign In');
                  },
                  label: Text('Sign Up with Email'),
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(double.infinity, 50)),
                  icon: FaIcon(FontAwesomeIcons.google, color: Colors.orange),
                  onPressed: () {
                    final provider = Provider.of<GoogleSigninProvider>(context,listen: false); 
                    provider.googleLogin();
                    // context.read<GoogleSigninProvider>().googleLogin();
                    displayToast('User has login');
                    log('Google Sign In');
                  },
                  label: Text('Sign Up with Google'),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already ave account? ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: -0.8,
                          fontFamily: 'Lato'),
                    ),
                    GestureDetector(
                      onTap: () => {},
                      child: Text(
                        'SignIn now',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}