import 'package:dear_diary_fixed/authenticate.dart';
import 'package:dear_diary_fixed/pages/homepage.dart';
import 'package:dear_diary_fixed/provider/counter.dart';
import 'package:dear_diary_fixed/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => GoogleSigninProvider()),
      ChangeNotifierProvider(create: (_) => Counter())
    ],
    child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GoogleAuthService",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145c9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
      ),
      home: HomePage(),
    );
  }
}