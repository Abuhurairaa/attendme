import 'package:attendme/admin_ui/admin_home_page.dart';
import 'package:attendme/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminHomePage(),
      ),
    );
  }
}
