import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:attendme/auth_services.dart';
import 'package:attendme/teacher_ui/teacher_map.dart';
import 'package:attendme/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class ListAttendance extends StatefulWidget {
  final attendance;

  const ListAttendance({Key? key, this.attendance}) : super(key: key);
  @override
  _ListAttendanceState createState() => _ListAttendanceState();
}

class _ListAttendanceState extends State<ListAttendance> {
  Color colorBlue = Colors.blue[900]!;
  late String dateStartString;
  late String dateEndString;
  late int valueButton;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dateStartString = DateFormat('MMM d, yyyy | kk:mm')
        .format(widget.attendance.data()['dateStart'].toDate());
    dateEndString = DateFormat('MMM d, yyyy | kk:mm')
        .format(widget.attendance.data()['dateEnd'].toDate());
    return StreamBuilder(
      stream: AuthServices.firebaseUserStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.attendance.id,
                    style: TextStyle(
                      color: colorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      deleteAttendance(context);
                      // showDialog(context: context, builder: (context) =>
                      // deleteAttendanceDialog(context),
                      // );
                      // await FirebaseFirestore.instance
                      //     .collection('attendance')
                      //     .doc(widget.attendance.id)
                      //     .delete();
                      // await FirebaseFirestore.instance
                      //     .collection('presence')
                      //     .where('attendance_id',
                      //         isEqualTo: widget.attendance.id)
                      //     .get()
                      //     .then((value) async {
                      //   for (int i = 0; i < value.docs.length; i++) {
                      //     var attendanceId = value.docs[i].id;
                      //     await FirebaseFirestore.instance
                      //         .collection('presence')
                      //         .doc(attendanceId)
                      //         .delete();
                      //   }
                      // });
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const TeacherPage();
                          },
                        ),
                      );
                    },
                    child: Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red[400],
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
              color: Colors.white,
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
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
                                      widget.attendance.data()['class_name'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.attendance.id,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      widget.attendance.data()['lecturer_name'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.white,
                                    ),
                                    Text(
                                      dateStartString,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      dateEndString,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Student Presence',
                            style: TextStyle(
                                color: colorBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('presence')
                              .where('attendance_id',
                                  isEqualTo: widget.attendance.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Column(
                                children: snapshot.data!.docs.map<Widget>((e) {
                                  return buildListTile(e, context);
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ],
                    )),
              ),
            ),
          );
        } else {
          return const Scaffold();
        }
      },
    );
  }

  Column buildListTile(e, BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.data()['student_name'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                e.data()['student_id'],
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          subtitle: Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                (e.data()['status'] != 0)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SeeMap(
                                  latitude: e.data()['latitude'],
                                  longitude: e.data()['longitude'],
                                  studentName: e.data()['student_name'],
                                  studentId: e.data()!['student_id'],
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'View Location',
                              style: TextStyle(color: colorBlue),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: colorBlue,
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (context) => seeMessage(e));
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'See Message',
                              style: TextStyle(color: colorBlue),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: colorBlue,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          trailing: ClipRRect(
            borderRadius: BorderRadius.circular(7.5),
            child: Container(
              width: 15,
              height: 15,
              color: (e.data()['status'] == 0)
                  ? Colors.red
                  : (e.data()['status'] == 1)
                      ? Colors.green
                      : Colors.yellow[800],
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
        )
      ],
    );
  }

  AlertDialog seeMessage(e) {
    return AlertDialog(
      elevation: 10,
      title: const Text('Absent Message'),
      content: StatefulBuilder(builder: (context, setState) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text((e.data()['message'] != null)
                ? e.data()['message']
                : 'No leave message!'));
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'CLOSE',
            style: TextStyle(color: colorBlue),
          ),
        ),
      ],
    );
  }

  //Delete Attendance Using ArtSweetAlert
  Future<void> deleteAttendance(BuildContext context) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          denyButtonText: "Cancel",
          title: "Are you sure you want to delete this Attendance?",
          text: "This action cannot be undone.",
          confirmButtonText: "yes,Delete it",
          type: ArtSweetAlertType.warning
      ),
    );

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(widget.attendance.id)
          .delete();
      await FirebaseFirestore.instance
          .collection('presence')
          .where('attendance_id',
          isEqualTo: widget.attendance.id)
          .get()
          .then((value) async {
        for (int i = 0; i < value.docs.length; i++) {
          var attendanceId = value.docs[i].id;
          await FirebaseFirestore.instance
              .collection('presence')
              .doc(attendanceId)
              .delete();
        }
      });

      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.success,
          title: "Deleted!",
        ),
      );
    }
  }
  //End

  AlertDialog deleteAttendanceDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure you want to delete this Attendance?'),
      actions: [
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('attendance')
                .doc(widget.attendance.id)
                .delete();
            await FirebaseFirestore.instance
                .collection('presence')
                .where('attendance_id',
                isEqualTo: widget.attendance.id)
                .get()
                .then((value) async {
              for (int i = 0; i < value.docs.length; i++) {
                var attendanceId = value.docs[i].id;
                await FirebaseFirestore.instance
                    .collection('presence')
                    .doc(attendanceId)
                    .delete();
              }
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text(
            'DELETE',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'CLOSE',
            style: TextStyle(color: colorBlue),
          ),
        ),
      ],
    );
  }
}
