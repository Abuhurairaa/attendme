import 'package:attendme/admin_ui/admin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  AddStudentState createState() => AddStudentState();
}

class AddStudentState extends State<AddStudent> {
  Color colorBlue = Colors.blue[900]!;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool validate = false;

  @override
  void dispose() {
    firstNameController.text = '';
    lastNameController.text = '';
    emailController.text = '';
    passwordController.text = '';
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
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: buildTextField(Icons.account_box, 'First name',
                    'first name',
                    firstNameController,
                  validate ? "First Name is Required!":null ,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: buildTextField(
                  Icons.account_box,
                  'Last name',
                  'last name',
                  lastNameController,
                  validate ? "Last Name is Required!":null ,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: buildTextField(
                  Icons.email,
                  'Email address',
                  'email@email.com',
                  emailController,
                  validate ? "Email is Required!":null ,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: buildTextField(
                  Icons.vpn_key,
                  'Password',
                  'password',
                  passwordController,
                  validate ? "Password is Required!":null ,
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                onPressed: () async {
                  if(firstNameController.text.isEmpty || lastNameController.text.isEmpty ||
                      emailController.text.isEmpty
                      || passwordController.text.length <7){
                    setState(() {
                      validate = true;
                    });
                  }else {
                    validate = false;
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    CollectionReference users = firestore.collection('users');
                    users.add({
                      'first_name': firstNameController.text,
                      'last_name': lastNameController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                      'role': 'student',
                    });

                    // firstNameController.text = '';
                    // lastNameController.text = '';
                    // emailController.text = '';
                    // passwordController.text = '';

                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AdminPage();
                        },
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add student'),
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
        errorText: validate,
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
