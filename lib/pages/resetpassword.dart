import 'package:dear_diary_fixed/authenticate.dart';
import 'package:dear_diary_fixed/pages/homepage.dart';
import 'package:dear_diary_fixed/pages/setup/signin.dart';
import 'package:dear_diary_fixed/services/authentication_service.dart';
import 'package:dear_diary_fixed/services/database.dart';
import 'package:dear_diary_fixed/toast.dart';
import 'package:dear_diary_fixed/widget.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  Database db = Database();
  AuthService authService = AuthService();
  bool isLoading = false;

  Widget cancelButton(BuildContext context) {
    return ElevatedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(this.context).pop();
      },
    );
  }

  Widget continueButton(BuildContext context) {
    return ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(this.context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
    );
  }

  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notice', style: TextStyle(color: Colors.red)),
            content:
                Text('Make sure you don\u0027t lose you password again :)'),
            actions: [cancelButton(context), continueButton(context)],
          );
        });
  }

  _search(String email) async {
    setState(() {
      isLoading = true;
    });
    if (formkey.currentState!.validate()) {
      var reset = await authService.resetPassword(email);
      if (reset) {
        showChoiceDialog(context);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: isLoading == true
          ? loadingScreen()
          : Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Text(
                      'Find Your Account',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Text(
                      'Pleases enter your email',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Lato'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Form(
                      key: formkey,
                      child: TextFormField(
                        controller: emailController,
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val.toString())
                              ? null
                              : "Invalid Email address";
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_rounded),
                            hintText: "Enter email",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 12),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato'),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        GestureDetector(
                          onTap: () {
                            _search(emailController.text);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent,
                            ),
                            child: Text(
                              'Search',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
