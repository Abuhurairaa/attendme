import 'dart:math';

import 'package:attendme/admin_ui/admin_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class RegisterClass extends StatefulWidget {
  const RegisterClass({super.key});

  @override
  RegisterClassState createState() => RegisterClassState();
}

class RegisterClassState extends State<RegisterClass> {
  Color colorBlue = Colors.blue[900]!;
  String? valueButton;
  String? course_id;
  String? course_name;
  String? lecturer_name;
  String? lecturer_id;
  String? class_id;
  final TextEditingController? classNameController = TextEditingController();
  bool validate = false;

  @override
  void dispose() {
    classNameController!.text = "";
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
          'Add Class',
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                  initialData: null,
                  stream:
                      FirebaseFirestore.instance.collection('course').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      final List<DropdownMenuItem> data = [];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        course_name = (snap.data() as dynamic)['course_name'];
                        // course_name;
                        data.add(
                          DropdownMenuItem(
                            // value: course_id,
                            value: (snap.data() as dynamic)['course_id'],
                            child: Text(
                              // course_name!,
                             (snap.data() as dynamic)['course_name'],
                              style: TextStyle(color: colorBlue),
                            ),
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Course',
                              style: TextStyle(color: colorBlue, fontSize: 14),
                            ),
                            DropdownButton(
                              hint: Text(
                                'Select a course',
                                style: TextStyle(color: colorBlue),
                              ),
                              value: course_id,
                              items: data,
                              focusColor: colorBlue,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  course_id = value;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text('Data not found!');
                    }
                  },
                ),
                SingleChildScrollView(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'lecturer')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        final List<DropdownMenuItem> data = [];
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data!.docs[i];

                          // String lecturerId2 = (snap.data() as dynamic)['user_id'];

                          lecturer_name = '${(snap.data() as dynamic)['first_name']}  ${(snap.data() as dynamic)['last_name']}';
                          data.add(
                            DropdownMenuItem( //lecturerId2
                              value: (snap.data() as dynamic)['user_id'],
                              child: Text(
                                // lecturer_name!,
                                '${(snap.data() as dynamic)['first_name']}  ${(snap.data() as dynamic)['last_name']}',
                                style: TextStyle(color: colorBlue),
                              ),
                            ),
                          );
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Lecturer',
                                style: TextStyle(color: colorBlue, fontSize: 14),
                              ),
                              DropdownButton(
                                hint: Text(
                                  'Select a lecturer',
                                  style: TextStyle(color: colorBlue),
                                ),
                                value: lecturer_id,
                                items: data,
                                focusColor: colorBlue,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    lecturer_id = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Text('Data not found!');
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: buildTextField(
                    Icons.meeting_room,
                    'Class name',
                    'please enter a class name',
                    classNameController,
                    validate
                  ),
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  onPressed: () async {
                    if(classNameController!.text.isEmpty) {
                      setState(() {
                        validate = true;
                      });
                    }else {
                      // setState(() async {
                        validate = false;
                        class_id = (course_id! + ( Random().nextInt(299)).toString());
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(lecturer_id)
                            .get()
                            .then((value) {
                          Map<String, dynamic>? document = value.data(); // make some changes
                          lecturer_name! ==
                              '${document?['first_name']}  ${document?['last_name']} ';
                        });
                        await FirebaseFirestore.instance
                            .collection('class')
                            .doc(class_id)
                            .set({
                          'class_name': classNameController?.text,
                          'class_id': class_id,
                          'lecturer_name': lecturer_name,
                          'lecturer_id': lecturer_id,
                          'course_id': course_id,
                          'course_name': course_name,
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

                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleChange(String? value) {
    setState(() {
      valueButton = value!;
    });
  }

  TextField buildTextField(icon, label, hint, controllerName,  validate) {
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
        errorText: validate ? "Class Name is required!": null,
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
