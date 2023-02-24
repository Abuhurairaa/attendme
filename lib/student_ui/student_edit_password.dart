import 'package:attendme/auth_services.dart';
import 'package:attendme/student_ui/student_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPasswordStudent extends StatefulWidget {
  final User data;

  const EditPasswordStudent({Key? key, required this.data}) : super(key: key);
  @override
  _EditPasswordStudentState createState() => _EditPasswordStudentState();
}

class _EditPasswordStudentState extends State<EditPasswordStudent> {
  Color colorBlue = Colors.blue[900]!;
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordNewController = TextEditingController();

  bool validate = false;

  @override
  void initState() {
    super.initState();
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
                  return const StudentPage();
                },
              ),
            );
          },
        ),
        title: Text(
          'Edit Password',
          style: TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        color: Colors.white,
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: buildTextField(Icons.email_rounded, 'Old Password',
                    'your old password', passwordController, true,
                  validate ? "Password is Required!":null ,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: buildTextField(Icons.vpn_key, 'New Password',
                    'your new password', passwordNewController, true,
                  validate ? "Password is Required!":null ,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  onPressed: () async {
                    if(passwordController.text.length <7
                        || passwordNewController.text.length <7){
                      setState(() {
                        validate = true;
                      });
                    }else {
                      validate = false;

                      User? firebaseUser = await AuthServices.getCredential(
                          widget.data.email!, passwordController.text);
                      AuthServices.updatePassword(
                          passwordNewController.text, firebaseUser!);

                      passwordController.text = '';
                      passwordNewController.text = '';

                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const StudentPage();
                          },
                        ),
                      );
                    }
                  },
                  label: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildTextField(icon, label, hint, controllerName, obscure, validate) {
    return TextField(
      obscureText: obscure,
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
        errorText: validate,
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
