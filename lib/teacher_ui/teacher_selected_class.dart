import 'package:attendme/auth_services.dart';
import 'package:attendme/teacher_ui/teacher_list_attendance.dart';
import 'package:attendme/teacher_ui/teacher_page.dart';
import 'package:attendme/teacher_ui/teacher_student_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SelectedClass extends StatefulWidget {
  final QueryDocumentSnapshot sendedData;

  const SelectedClass({Key? key, required this.sendedData}) : super(key: key);

  @override
  _SelectedClassState createState() => _SelectedClassState();
}

class _SelectedClassState extends State<SelectedClass> {
  Color colorBlue = Colors.blue[900]!;
  late String dateStartString;
  late String dateEndString;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference studentData = firestore.collection('users');

    return StreamBuilder(
      stream: AuthServices.firebaseUserStream,
      builder: (context, snapshot) {
        if (snapshot != null) {
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
                (widget.sendedData.data() as dynamic)['class_name'],
                style: TextStyle(
                  color: colorBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              color: Colors.white,
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: colorBlue,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  (widget.sendedData.data() as dynamic)['class_name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.sendedData.id,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  (widget.sendedData.data() as dynamic)['lecturer_name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ListStudent(
                                                classData: widget.sendedData);
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'See student',
                                      style: TextStyle(
                                        color: colorBlue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Text(
                        'Attendance',
                        style: TextStyle(
                            color: colorBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('attendance')
                          .where('class_id', isEqualTo: widget.sendedData.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          if (snapshot.data!.docs.isEmpty) {
                            return const Text('No attendance found!');
                          } else {
                            return Column(
                              children: snapshot.data!.docs
                                  .map<Widget>((e) => buildCard(e, studentData))
                                  .toList(),
                            );
                          }
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }

  Card buildCard(QueryDocumentSnapshot e, deleteData) {
    dateStartString = DateFormat('MMM d, yyyy | kk:mm')
        .format((e.data() as dynamic)['dateStart'].toDate());
    dateEndString =
        DateFormat('MMM d, yyyy | kk:mm').format((e.data() as dynamic)['dateEnd'].toDate());
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (e.data() as dynamic)['class_name'],
                style: TextStyle(
                  color: colorBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                (e.data() as dynamic)['lecturer_name'],
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              Text(
                'Start : $dateStartString',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                'End : $dateEndString',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: () {
                          var dataValue = (e.data() as dynamic)['class_id'];
                          var keyCode = (e.data() as dynamic)['attendance_id'];
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  alertDialogQR(dataValue, keyCode));
                        },
                        child: const Text(
                          'See QR Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: colorBlue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ListAttendance(attendance: e);
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'See attendance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog alertDialogQR(dataValue, keyCode) {
    return AlertDialog(
      backgroundColor: colorBlue,
      elevation: 10,
      content: Container(
        padding: const EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('attendance')
                      .doc(keyCode)
                      .snapshots(),
                  builder: (context, snapshot) {
                    dateStartString = DateFormat('MMM d, yyyy | kk:mm')
                        .format(snapshot.data?.data()!['dateStart'].toDate());
                    dateEndString = DateFormat('MMM d, yyyy | kk:mm')
                        .format(snapshot.data?.data()!['dateEnd'].toDate());
                    if (snapshot.data == null) {
                      return const CircularProgressIndicator();
                    } else {
                      return Column(children: [
                        Text(
                          snapshot.data?.data()!['class_name'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          snapshot.data?.data()!['lecturer_name'],
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Text(
                          dateStartString,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const Text(
                          '-',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          dateEndString,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ]);
                    }
                  },
                ),
              ),
              Center(
                child: QrImage(
                  data: keyCode,
                  padding: const EdgeInsets.all(15),
                  foregroundColor: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.5,
                  version: QrVersions.auto,
                ),
              ),
              const Text(
                'Key Code',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                keyCode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text(
            'CLOSE',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
