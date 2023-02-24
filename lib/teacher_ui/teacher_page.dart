import 'package:attendme/auth_services.dart';
import 'package:attendme/teacher_ui/teacher_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TeacherHomePage(),
      ),
    );
  }
}
