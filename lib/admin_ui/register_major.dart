import 'dart:math';

import 'package:attendme/admin_ui/admin_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../custom_form_field.dart';

class RegisterCourse extends StatefulWidget {
  const RegisterCourse({super.key});

  @override
  _RegisterCourseState createState() => _RegisterCourseState();
}

class _RegisterCourseState extends State<RegisterCourse> {
  // final formKey = GlobalKey<FormState>();
  Color colorBlue = Colors.blue[900]!;
  String? course_id;
  final TextEditingController? courseNameController = TextEditingController();
  bool validate = false;

  @override
  void dispose() {
    courseNameController!.text = "";
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: colorBlue,
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const AdminPage();
                },
              ),
            );
          },
        ),
        title: Text(
          'Add Course',
          style: TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Container(
          // key: formKey,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child:buildTextField(
                  Icons.bookmark,
                  'Course Name',
                  'enter a Course Name',
                  courseNameController,
                  validate
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                onPressed: () async {
                  if(courseNameController!.text.isEmpty){
                    setState(() {
                      validate = true;
                    });
                  }else{
                    // setState(() async {
                      validate = false;
                      course_id = (Random().nextInt(299).toString());
                      await FirebaseFirestore.instance
                          .collection('course')
                          .doc(course_id)
                          .set({
                        'course_id': course_id,
                        'course_name': courseNameController!.text,
                      });
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const AdminPage();
                          },
                        ),
                      );
                    // });
                  }


                  // }
                },
                icon: const Icon(Icons.add),
                label: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildTextField(icon, label, hint, controllerName, validate) {
    return TextField(
      controller: controllerName,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: colorBlue,
        ),
        prefixStyle: TextStyle(color: colorBlue),
        labelText: label,
        errorText: validate ? 'Course Name is required!' : null,
        labelStyle: TextStyle(color: colorBlue),
        hintText: hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
      ),
    );
  }
}
