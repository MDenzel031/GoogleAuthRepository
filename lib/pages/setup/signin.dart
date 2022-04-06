import 'dart:convert';

import 'package:dear_diary_fixed/authenticate.dart';
import 'package:dear_diary_fixed/pages/resetpassword.dart';
import 'package:dear_diary_fixed/provider/google_sign_in.dart';
import 'package:dear_diary_fixed/services/authentication_service.dart';
import 'package:dear_diary_fixed/services/database.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:dear_diary_fixed/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:developer';

import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  // const SignIn({Key? key}) : super(key: key);
  final Function toggle;
  SignIn(this.toggle);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = '', password = '';
  bool isLoading = false;
  final formKey = GlobalKey<FormState>(); // Controls the Form
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Database db = Database();
  AuthService authService = AuthService();

  void authenticateUser(BuildContext context) async {
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
      if (formKey.currentState!.validate()) {
        await authService.signUser(
            emailController.text, passwordController.text, context);
      }

      if(mounted){
        setState(() {
        isLoading = false;
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dear Diary'),
          backgroundColor: Colors.lightBlue,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {log("asdaddasdsadsad")},
          tooltip: 'This is a tooltip',
        ),
        body: isLoading
            ? loadingScreen()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Colors.white30,
                          Colors.white30,
                        ]),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: FlutterLogo(
                          size: 100,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                if (val != null) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Iinvalid Email Address";
                                }
                              },
                              onSaved: (val) {
                                if (val != null) {
                                  email = val;
                                }
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: [AutofillHints.email],
                              style: signInTextStyle(),
                              decoration: textFieldInputDecoration(
                                "Email",
                                Icon(Icons.email_rounded,
                                    color: Colors.grey[500]),
                              ),
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val != null) {
                                  return val.length < 6
                                      ? "Password must be 6+ length"
                                      : null;
                                }
                              },
                              onSaved: (val) {
                                if (val != null) {
                                  password = val;
                                }
                              },
                              controller: passwordController,
                              obscureText: true,
                              style: signInTextStyle(),
                              decoration: textFieldInputDecoration(
                                  "Password",
                                  Icon(Icons.password,
                                      color: Colors.grey[500])),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              width: size.width,
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ResetPassword()))
                                },
                                child: Text(
                                  'Forgot Password?',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  onPrimary: Colors.white,
                                  minimumSize: Size(double.infinity, 50)),
                              icon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                authenticateUser(context);
                              },
                              label: Text('Sign In with Email'),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: HexColor('#386FEC'),
                                  onPrimary: Colors.white,
                                  minimumSize: Size(double.infinity, 50)),
                              icon: FaIcon(FontAwesomeIcons.google,
                                  color: Colors.orange),
                              onPressed: () {
                                final provider =
                                    Provider.of<GoogleSigninProvider>(context,
                                        listen: false);
                                provider.googleLogin();
                                // context.read<GoogleSigninProvider>().googleLogin();
                                displayToast('User has login');
                                log('Google Sign In');
                              },
                              label: Text('Sign In with Google'),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Dont have account? ',
                                  style: signInTextStyle(),
                                ),
                                GestureDetector(
                                  onTap: () => {widget.toggle()},
                                  child: Text(
                                    'Register now',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
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
                  ],
                ),
              ),
      ),
    );
  }

  void signInMe() {
    if (formKey.currentState!.validate()) {
      log('Form key is: ' + formKey.currentState!.validate().toString());
      var obj = {
        email: emailController.text,
        password: passwordController.text
      };
      log('Email: ${emailController.text}');
      log('Password: ${passwordController.text}');
      displayToast('${emailController.text} has been authenticated');
    }
  }

  void navigateToRegistration() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
  }
}
