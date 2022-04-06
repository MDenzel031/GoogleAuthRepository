import 'package:flutter/material.dart';

TextStyle signInTextStyle() {
  return TextStyle(
      fontSize: 20,
      color: Colors.black54,
      letterSpacing: -0.8,
      fontFamily: 'Lato');
}

TextStyle titleTextStyle() {
  return TextStyle(
      fontSize: 50,
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.8,
      fontFamily: 'Lato');
}


InputDecoration textFieldInputDecoration(String hintText, Icon icon) {
  return InputDecoration(
    hintText: "$hintText",
    hintStyle: TextStyle(color: Colors.grey[500]),
    prefixIcon: icon,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  );
}


TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}


Widget loadingScreen() {
  return Container(
    decoration: backgroundDecorationV2(),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(top: 10)),
          Text('Loading please be patient',
              style: TextStyle(
                  fontFamily: 'Lato', fontSize: 20, color: Colors.black))
        ],
      ),
    ),
  );
}

BoxDecoration backgroundDecorationV2() {
  return BoxDecoration(
      color: Colors.white);
}