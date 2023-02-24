import 'package:attendme/admin_ui/admin_page.dart';

import 'package:attendme/login_page.dart';
import 'package:attendme/student_ui/student_page.dart';
import 'package:attendme/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.lazyPut(() => DataClass());
    User? firebaseUser = Provider.of<User?>(context);

    if ((firebaseUser == null)) {
      return const LoginPage();
    } else {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.data()!['role'] == 'admin') {
              return const AdminPage();
            } else if (snapshot.data?.data()!['role'] == 'student') {
              return const StudentPage();
            } else if (snapshot.data?.data()!['role'] == 'lecturer') {
              return const TeacherPage();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }
}
