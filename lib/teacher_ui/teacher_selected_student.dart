import 'package:attendme/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectedStudent extends StatefulWidget {
  final studentData;

  const SelectedStudent({Key? key, this.studentData}) : super(key: key);
  @override
  _SelectedStudentState createState() => _SelectedStudentState();
}

class _SelectedStudentState extends State<SelectedStudent> {
  Color colorBlue = Colors.blue[900]!;
  var photoURL;
  var course_id;

  @override
  void initState() {
    if (widget.studentData.data()['photo'] != null) {
      photoURL = widget.studentData.data()['photo'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    course_id = widget.studentData.data()['course_id'];
    if (kDebugMode) {
      print(course_id);
    }
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (photoURL == null)
                          ? const AssetImage('assets/img/photo.jpg')
                          : NetworkImage(widget.studentData.data()['photo']) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: colorBlue,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const TeacherPage();
                            },
                          ),
                        );
                      }),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height / 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.studentData.data()['first_name'] +
                              ' ' +
                              widget.studentData.data()['last_name'],
                          style: TextStyle(
                              color: colorBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    (widget.studentData.data()['gender'] == 'M')
                                        ? 'Male'
                                        : 'Female',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.date_range),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    widget.studentData.data()['birth'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Student Information',
                          style: TextStyle(
                              color: colorBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text('Student Id:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    widget.studentData.data()['user_id'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text('Course:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('course')
                                          .doc(course_id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return Text(
                                            snapshot.data?.data()!['course_name'],
                                            style: const TextStyle(fontSize: 16),
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      }),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
