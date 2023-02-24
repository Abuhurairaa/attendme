import 'dart:math';

import 'package:attendme/admin_ui/admin_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class UpdateCourse extends StatefulWidget {

  final QueryDocumentSnapshot data;

  const UpdateCourse({super.key, required this.data});

  @override
  UpdateCourseState createState() => UpdateCourseState();
}

class UpdateCourseState extends State<UpdateCourse> {
  Color colorBlue = Colors.blue[900]!;
  // final formKey = GlobalKey<FormState>();
  TextEditingController courseNameController = TextEditingController();
  bool validate = false;

  @override
  void initState() {
    courseNameController.text = (widget.data.data() as dynamic)['course_name'] ?? '';
    super.initState();
  }

  @override
  void dispose() {
    courseNameController.text ="";
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
          'Update Course',
          style: TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          // key: formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: buildTextField(
                  Icons.bookmark,
                  'Course Name',
                  'enter a course name',
                  courseNameController,
                  validate
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                onPressed: () async {
                  if(courseNameController.text.isEmpty){
                    setState(() {
                      validate = true;
                    });
                  }else {
                    // setState(() async {
                      validate = false;
                      await FirebaseFirestore.instance
                          .collection('course')
                          .doc(widget.data.id)
                          .update({
                        'course_name': courseNameController.text,
                      });
                      courseNameController.text = '';

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

                },
                icon: const Icon(Icons.save_as_outlined),
                label: const Text('Update Course'),
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
        errorText: validate ? "Course Name is required!": null,
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
