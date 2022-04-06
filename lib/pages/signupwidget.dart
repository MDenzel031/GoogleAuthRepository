import 'package:flutter/material.dart';

class SignupWidget extends StatelessWidget {
  const SignupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Signin'),
          )
        ],
      ),
    );
  }
}
