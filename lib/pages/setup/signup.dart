import 'dart:developer';

import 'package:dear_diary_fixed/services/authentication_service.dart';
import 'package:dear_diary_fixed/services/database.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:dear_diary_fixed/widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUp extends StatefulWidget {
  // const SignUp({ Key? key }) : super(key: key);
  final Function toggle;
  SignUp(this.toggle);
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>(); // Controls the Form
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  Database db = Database();
  AuthService authService = AuthService();

  passwordValidation() {
    if (passwordController.text == repasswordController.text) {
      return true;
    } else {
      return false;
    }
  }

  void authenticateUser() async {
    setState(() {
      isLoading = true;
    });

    if (formKey.currentState!.validate()) {
      if (!passwordValidation()) {
        displayToast('Password is not match please try again');
      } else {
        await authService.createUser(emailController.text, passwordController.text,
            usernameController.text);
      }
    }

    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SignUp'),
          backgroundColor: Colors.lightBlue,
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
                        padding: EdgeInsets.symmetric(vertical: 20),
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
                                  return null;
                                } else {
                                  return 'Invalid Form';
                                }
                              },
                              controller: usernameController,
                              keyboardType: TextInputType.name,
                              style: signInTextStyle(),
                              decoration: textFieldInputDecoration(
                                "Username",
                                Icon(Icons.account_circle,
                                    color: Colors.grey[500]),
                              ),
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val != null) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Iinvalid Email Address";
                                }else{return "Invalid Email Address";}
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
                              controller: passwordController,
                              obscureText: true,
                              style: signInTextStyle(),
                              decoration: textFieldInputDecoration(
                                  "Password",
                                  Icon(Icons.password,
                                      color: Colors.grey[500])),
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val != null) {
                                  return val.length < 6
                                      ? "Password must be 6+ length"
                                      : null;
                                }
                              },
                              controller: repasswordController,
                              obscureText: true,
                              style: signInTextStyle(),
                              decoration: textFieldInputDecoration(
                                  "Retype Password",
                                  Icon(Icons.password,
                                      color: Colors.grey[500])),
                            ),
                            SizedBox(height: 20),
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
                                authenticateUser();
                              },
                              label: Text('Sign In with Email'),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already ave account? ',
                                  style: signInTextStyle(),
                                ),
                                GestureDetector(
                                  onTap: () => {widget.toggle()},
                                  child: Text(
                                    'SignIn now',
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
}
