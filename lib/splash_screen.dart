import 'dart:async';

import 'package:attendme/auth_services.dart';
import 'package:attendme/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color? colorBlue = Colors.blue[900];
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Wrapper()));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Container(
              child: Image.asset(
                'assets/img/Attendance.png',
                width: MediaQuery.of(context).size.width / 3.25,
                height: MediaQuery.of(context).size.width / 3.25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
