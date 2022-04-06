import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';


class displayToast{
  String message;

  displayToast(this.message){
    Fluttertoast.cancel();
    this.message = message;
    Fluttertoast.showToast(
        msg: "$message",
        backgroundColor: HexColor('#EED6D3'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
  
}