import 'dart:io';
import 'dart:ui';

import 'package:attendme/firestore_services.dart';
import 'package:attendme/student_ui/student_page.dart';
import 'package:attendme/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileStudent extends StatefulWidget {
  final dynamic data;

  const EditProfileStudent({Key? key, this.data}) : super(key: key);
  @override
  _EditProfileStudentState createState() => _EditProfileStudentState();
}

class _EditProfileStudentState extends State<EditProfileStudent> {
  Color colorBlue = Colors.blue[900]!;
  bool changePhoto = false;
  bool hasURL = false;
  bool loading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  File? image;
  var photoURL;

  bool validate = false;

  @override
  void initState() {
    firstNameController.text = widget.data.data()['first_name'];
    lastNameController.text = widget.data.data()['last_name'];
    photoURL = widget.data.data()['photo'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Future getImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    }

    if (photoURL != null) {
      hasURL = true;
    } else {
      hasURL = false;
    }

    return Stack(
      children: [
        Scaffold(
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
              'Edit Profile',
              style: TextStyle(
                color: colorBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    (hasURL && !changePhoto)
                        ? Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 100,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 100,
                                    backgroundImage: NetworkImage(photoURL),
                                  ),
                                ),
                              ),
                              TextButton(
                                child: const Text('Change Photo'),
                                onPressed: () {
                                  setState(() {
                                    changePhoto = true;
                                  });
                                },
                              ),
                            ],
                          )
                        : (image == null)
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 100,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: TextButton(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '+'.toUpperCase(),
                                            style: TextStyle(color: colorBlue),
                                          ),
                                          Icon(Icons.photo, color: colorBlue),
                                        ],
                                      ),
                                      onPressed: () {
                                        getImage();
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            image: DecorationImage(
                                              image: FileImage(image!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          image = null;
                                        });
                                      }),
                                ],
                              ),
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
                      margin: const EdgeInsets.only(bottom: 40),
                      child: buildTextField(
                        Icons.account_box,
                        'Last name',
                        'last name',
                        lastNameController,
                        validate ? "Last Name is Required!":null ,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FloatingActionButton.extended(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        onPressed: () async {
                          if(firstNameController.text.isEmpty
                              || lastNameController.text.isEmpty){
                            setState(() {
                              validate = true;
                            });
                          }else {
                            validate = false;

                            firestore
                                .collection('users')
                                .doc(widget.data.id)
                                .update({
                              'first_name': firstNameController.text,
                              'last_name': lastNameController.text,
                            });

                            if (image != null) {
                              if (photoURL != null) {
                                FirestoreService.deleteImage(photoURL);
                              }
                              setState(() {
                                loading = true;
                              });
                              var imageURL =
                              await FirestoreService.uploadImage(image!);
                              setState(() {
                                loading = false;
                              });
                              firestore
                                  .collection('users')
                                  .doc(widget.data.id)
                                  .update({'photo': imageURL});
                            }

                            firstNameController.text = '';
                            lastNameController.text = '';

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
          ),
        ),
        (loading)
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey.withOpacity(0.7),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorBlue),
                  ),
                ),
              )
            : Container()
      ],
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
