import 'package:attendme/admin_ui/admin_page.dart';
import 'package:attendme/auth_services.dart';
import 'package:attendme/student_ui/student_page.dart';
import 'package:attendme/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color colorBlue = Colors.blue[900]!;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool exist = false;
  bool email = false;
  bool password = false;

  void toggleObscure() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/img/circle_blur.png', fit: BoxFit.cover),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ //Image
                    Image.asset(
                      'assets/img/login-page.gif',
                      // fit: BoxFit.cover,
                      // width: 200,
                      // height: 300,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: buildTextField(
                                Icons.email,
                                'Email',
                                'youremail@email.com',
                                emailController,
                                'email'),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 60),
                            child: buildPasswordField(
                                Icons.vpn_key,
                                'Password',
                                'your password',
                                obscureText,
                                passwordController,
                                'password'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: buildButton(colorBlue, 'Login', Colors.blue[700],
                          colorBlue, 15.0, emailController, passwordController),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox buildButton(splashColor, buttonText, buttonColorBegin,
      buttonColorEnd, borderRadius, emailController, passwordController) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
              colors: [buttonColorBegin, buttonColorEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: splashColor,
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: emailController.text)
                  .get()
                  .then((value) async {
                if (value.docs.isNotEmpty) {
                  email = true;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .where('password', isEqualTo: passwordController.text)
                      .get()
                      .then((value) {
                    if (value.docs.isNotEmpty) {
                      password = true;
                      exist = true;
                    } else {
                      password = false;
                    }
                  });
                } else {
                  email = false;
                }
              });

              if (!email) {
                ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.danger,
                        title: "Oops...",
                        text: "Email is Invalid / not Found!"
                    )
                );
                // return WidgetsBinding.instance.addPostFrameCallback((_) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Email is invalid / not found!'),
                //     backgroundColor: Colors.red,
                //   ),
                // );
                // });//
              }

              if (!password) {
                ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.danger,
                        title: "Oops...",
                        text: "Password is Invalid!"
                    )
                );
                // return WidgetsBinding.instance.addPostFrameCallback((_) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Password is invalid!'),
                //     backgroundColor: Colors.red,
                //   ),
                // );
                // });//
              }

              if (exist) {
                ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.success,
                        title: "Great!",
                        text: "Login successfully! Please wait..."
                    )
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Login successfully! Please wait...'),
                //     backgroundColor: Colors.green,
                //   ),
                // );
                await AuthServices.signIn(
                    emailController.text, passwordController.text);

                 StreamBuilder(
                    stream: AuthServices.firebaseUserStream,
                    builder: (context, snapshot) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(snapshot.data!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final user = snapshot.data!.data();
                            if (user!['role'] == 'admin') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const AdminPage();
                                  },
                                ),
                              );
                            } else if (user['role'] == 'student') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const StudentPage();
                                  },
                                ),
                              );
                            } else if (user['role'] == 'lecturer') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const TeacherPage();
                                  },
                                ),
                              );
                            }
                          }
                          return Container(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );
                    });
              }
            },
            child: Center(
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextField(icon, label, hint, controllerName, validator) {
    return TextFormField(
      controller: controllerName,
      onChanged: (value) {},
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: colorBlue,
        ),
        prefixStyle: TextStyle(color: colorBlue),
        labelText: label,
        // errorText: validator,
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

  TextFormField buildPasswordField(
      icon, label, hint, obscureText, controllerName, validator) {
    return TextFormField(
      controller: controllerName,
      onChanged: (value) {},
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: colorBlue,
        ),
        suffixIcon: IconButton(
            icon: (obscureText)
                ? Icon(Icons.visibility_off, color: colorBlue)
                : Icon(Icons.visibility, color: colorBlue),
            onPressed: () {
              toggleObscure();
            }),
        prefixStyle: TextStyle(color: colorBlue),
        labelText: label,
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
