import 'package:attendme/admin_ui/admin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateTeacher extends StatefulWidget {
  final QueryDocumentSnapshot data;

  const UpdateTeacher({Key? key, required this.data}) : super(key: key);
  @override
  _UpdateTeacherState createState() => _UpdateTeacherState();
}

class _UpdateTeacherState extends State<UpdateTeacher> {
  Color colorBlue = Colors.blue[900]!;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool validate = false;

  @override
  void initState() {
    firstNameController.text = (widget.data.data() as dynamic)['first_name'];
    lastNameController.text = (widget.data.data() as dynamic)['last_name'];
    emailController.text = (widget.data.data() as dynamic)['email'];
    passwordController.text = (widget.data.data() as dynamic)['password'];

    super.initState();
  }

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
    FirebaseFirestore firestore = FirebaseFirestore.instance;

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
          'Edit Lecturer',
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
                  onPressed: () {
                    if(firstNameController.text.isEmpty || lastNameController.text.isEmpty
                        || emailController.text.isEmpty || passwordController.text.isEmpty){
                      setState(() {
                        validate = true;
                      });
                    }else {
                      validate = false;
                      firestore.collection('users').doc(widget.data.id).update({
                        'first_name': firstNameController.text,
                        'last_name': lastNameController.text,
                        'email': emailController.text,
                        'password': passwordController.text,
                      });

                      firstNameController.text = '';
                      lastNameController.text = '';
                      emailController.text = '';
                      passwordController.text = '';

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
                  label: const Text('Update lecturer'),
                ),
              ],
            ),
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
