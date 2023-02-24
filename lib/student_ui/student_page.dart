import 'package:attendme/auth_services.dart';
import 'package:attendme/student_ui/student_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StudentHomePage(),
      ),
    );
  }
}
