import 'package:attendme/auth_services.dart';

import 'package:attendme/teacher_ui/teacher_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditEmailTeacher extends StatefulWidget {
  final User data;

  const EditEmailTeacher({Key? key, required this.data}) : super(key: key);
  @override
  _EditEmailTeacherState createState() => _EditEmailTeacherState();
}

class _EditEmailTeacherState extends State<EditEmailTeacher> {
  Color colorBlue = Colors.blue[900]!;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool validate = false;

  @override
  void initState() {
    emailController.text = widget.data.email!;

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
                  return const TeacherPage();
                },
              ),
            );
          },
        ),
        title: Text(
          'Edit Email',
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
                child: buildTextField(Icons.email_rounded, 'Email',
                    'your_email@email.com', emailController, false,
                validate ? "Email is Required!":null ,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: buildTextField(Icons.vpn_key, 'Confirm Password',
                    'your password', passwordController, true,
                  validate ? "Password is Required!":null ,
                ),
              ),
              Container(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  onPressed: () async {
                    if(emailController.text.isEmpty
                        || passwordController.text.isEmpty){
                      setState(() {
                        validate = true;
                      });
                    }else {
                      validate = false;

                      User? firebaseUser = await AuthServices.getCredential(
                          widget.data.email!, passwordController.text);
                      AuthServices.updateEmail(emailController.text,
                          passwordController.text, firebaseUser!);

                      emailController.text = '';
                      passwordController.text = '';

                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TeacherPage();
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
