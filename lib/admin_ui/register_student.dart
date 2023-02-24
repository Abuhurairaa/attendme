import 'dart:math';

import 'package:attendme/admin_ui/admin_page.dart';
import 'package:attendme/auth_services.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterStudent extends StatefulWidget {
  final admin;
  const RegisterStudent({Key? key, this.admin}) : super(key: key);
  @override
  _RegisterStudentState createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  Color colorBlue = Colors.blue[900]!;
  String? valueButton;
  String? course_name;
  String? course_id;

  DateTime selectedDate = DateTime.now();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var formattedDate = DateFormat.yMMMd().format(selectedDate);

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
          'Add Student',
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
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: buildTextField(
                    Icons.account_box,
                    'First name',
                    'first name',
                    firstNameController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: buildTextField(
                    Icons.account_box,
                    'Last name',
                    'last name',
                    lastNameController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: "M",
                            activeColor: colorBlue,
                            groupValue: valueButton,
                            onChanged: handleChange,
                          ),
                          Text(
                            "Male",
                            style: TextStyle(
                              color: colorBlue,
                            ),
                          ),
                          Radio<String>(
                            value: "F",
                            activeColor: colorBlue,
                            groupValue: valueButton,
                            onChanged: handleChange,
                          ),
                          Text(
                            "Female",
                            style: TextStyle(
                              color: colorBlue,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: colorBlue,
                        thickness: 1.3,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Text(
                              "Date of Birth -",
                              style: TextStyle(
                                color: colorBlue,
                              ),
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: colorBlue,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: colorBlue,
                        thickness: 1.3,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: buildTextField(
                    Icons.email,
                    'Email address',
                    'email@email.com',
                    emailController,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: buildTextField(
                    Icons.vpn_key,
                    'Password',
                    'password',
                    passwordController,
                  ),
                ),
                StreamBuilder(
                  initialData: null,
                  stream: FirebaseFirestore.instance
                      .collection('course')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      final List<DropdownMenuItem> data = [];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data?.docs[i] as DocumentSnapshot;
                        course_name = (snap.data() as dynamic)['course_name'] ?? '';
                        data.add(
                          DropdownMenuItem(
                            value: (snap.data() as dynamic)['course_id'] ?? '',
                            child: Text(
                              (snap.data() as dynamic)['course_name'] ?? '',
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
                FloatingActionButton.extended(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  onPressed: () async {
                    var adminUser;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.admin.uid)
                        .get()
                        .then((value) {
                      adminUser = value.data();
                    });
                    var result = await AuthServices.signUp(
                        emailController.text, passwordController.text);

                    String userId = 'S$valueButton$course_id${1000 + Random().nextInt(999)}';

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(result?.uid)
                        .set({
                      'user_id': userId,
                      'first_name': firstNameController.text,
                      'last_name': lastNameController.text,
                      'gender': valueButton,
                      'birth': formattedDate,
                      'email': emailController.text,
                      'password': passwordController.text,
                      'role': 'student',
                      'course_id': course_id,
                      'course_name': course_name,
                    });
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return UploadImage();
                    //     },
                    //   ),
                    // );
                    await AuthServices.signOut();
                    await AuthServices.signIn(
                        adminUser['email'], adminUser['password']);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1945, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TextField buildTextField(icon, label, hint, controllerName) {
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
        labelStyle: TextStyle(color: colorBlue),
        hintText: hint,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorBlue),
        ),
      ),
    );
  }
}
