import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:attendme/admin_ui/admin_update_major.dart';
import 'package:attendme/admin_ui/admin_update_student.dart';
import 'package:attendme/admin_ui/admin_update_teacher.dart';
import 'package:attendme/admin_ui/register_class.dart';
import 'package:attendme/admin_ui/register_lecturer.dart';
import 'package:attendme/admin_ui/register_major.dart';
import 'package:attendme/admin_ui/register_student.dart';
import 'package:attendme/auth_services.dart';
import 'package:attendme/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'admin_update_class.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  Color colorBlue = Colors.blue[900]!;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: Container(
          color: Colors.blue.shade900,
          child: const TabBar(
            unselectedLabelColor: Colors.white54,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5),
            indicatorColor: Colors.white30,
            tabs: [
              Tab(
                text: "Home",
                icon: Icon(Icons.home),
              ),
              Tab(
                text: "Courses",
                icon: Icon(Icons.menu_book),
              ),
              Tab(
                text: "Classes",
                icon: Icon(Icons.library_books),
              ),
              Tab(
                text: "Lecturers",
                icon: Icon(Icons.person),
              ),
              Tab(
                text: "Students",
                icon: Icon(Icons.people),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            homeBar(context),
            courseBar(context),
            classBar(context),
            lecturerBar(context),
            studentBar(context),
          ],
        ),
      ),
    );
  }

  Container courseBar(context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query course = firestore.collection('course');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      // color: Colors.white,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Course',
                  style: TextStyle(
                      color: colorBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const RegisterCourse();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Add Course',
                    style: TextStyle(
                      color: colorBlue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: course.snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: snapshot.data!.docs
                                .map(
                                  (e) => buildCourseCard(
                                      e, UpdateCourse(data: e), course),
                                )
                                .toList(),
                          );
                        } else {
                          return const Text('Data not found!');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Container classBar(context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query classes = firestore.collection('class');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Class',
                style: TextStyle(
                    color: colorBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RegisterClass();
                      },
                    ),
                  );
                },
                child: Text(
                  'Add Class',
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  StreamBuilder<QuerySnapshot?>(
                    stream: classes.snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!.docs
                              .map(
                                (e) => buildClassCard(
                                    e, UpdateClass(data: e), classes),
                              )
                              .toList(),
                        );
                      } else {
                        return const Text('Data not found!');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container studentBar(context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? firebaseUser = Provider.of<User?>(context);
    Query students =
        firestore.collection('users').where('role', isEqualTo: 'student');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student',
                style: TextStyle(
                    color: colorBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterStudent(
                          admin: firebaseUser,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Add Student',
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  StreamBuilder<QuerySnapshot?>(
                    stream: students.snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!.docs
                              .map(
                                (e) => buildCard(
                                    e, UpdateStudent(data: e), students),
                              )
                              .toList(),
                        );
                      } else {
                        return const Text('Data not found!');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container lecturerBar(context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? firebaseUser = Provider.of<User?>(context);
    Query lecturer =
        firestore.collection('users').where('role', isEqualTo: 'lecturer');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lecturer',
                style: TextStyle(
                    color: colorBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterLecturer(
                          admin: firebaseUser,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Add Lecturer',
                  style: TextStyle(
                    color: colorBlue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  StreamBuilder<QuerySnapshot?>(
                    stream: lecturer.snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!.docs
                              .map(
                                (e) => buildCard(
                                    e, UpdateTeacher(data: e), lecturer),
                              )
                              .toList(),
                        );
                      } else {
                        return const Text('Data not found!');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card buildCard(QueryDocumentSnapshot e, updateData, deleteData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return updateData;
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 5, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(e.data() as dynamic)['first_name']}  ${(e.data() as dynamic)['last_name']} ',
                      style: TextStyle(
                        color: colorBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      (e.data() as dynamic) ['course_name'],
                      style: TextStyle(color: colorBlue, fontSize: 14),
                    ),
                    Text(
                      (e.data() as dynamic)['user_id'],
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  deleteUsers(e);
                  // showDialog(context: context, builder: (context)=>
                  // deleteDialog(e),
                  // );
                  // FirebaseFirestore.instance
                  // .collection('users')
                  //     .doc(e.id).delete();
                  // deleteData.doc(e.id).delete();
                },
                child: const Text(
                  'X',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildClassCard(QueryDocumentSnapshot e, updateData, deleteData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return updateData;
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (e.data() as dynamic)['class_name'],
                      style: TextStyle(
                          color: colorBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (e.data() as dynamic)['course_name'],
                      style: TextStyle(color: colorBlue, fontSize: 14),
                    ),
                    Text(
                      (e.data() as dynamic)['lecturer_name'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  deleteClass(e);
                  // showDialog(context: context, builder: (context) =>
                  // deleteClassDialog(e),
                  // );
                  // deleteData.doc(e.id).delete();
                },
                child: const Text(
                  'X',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildCourseCard(QueryDocumentSnapshot e, updateData, deleteData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return updateData;
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (e.data() as dynamic)['course_name'] ,
                        style: TextStyle(color: colorBlue, fontSize: 14,),
                      ),
                      Text(
                        (e.data() as dynamic)['course_id'] ,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    deleteCourse(e);
                  },
                  child: const Text(
                    'X',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  Container homeBar(context) {
    User? firebaseUser = Provider.of<User?>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      color: Colors.white,
      // width: 30,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          color: colorBlue,
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(firebaseUser?.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              final user = snapshot;

                              return Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome,  ${user.data?.data()!['first_name']}' ?? '',
                                      style: TextStyle(
                                          color: colorBlue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      user.data?.data()!['role'] ?? '',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14, fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.logout, color: colorBlue),
                  onPressed: () {
                    // AuthServices.signOut();
                    AuthServices.logout(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Wrapper();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            Card(
              margin: const EdgeInsets.only(top: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 15,
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Students',
                          style: TextStyle(
                            color: colorBlue,
                            fontSize: 16,
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'student')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              var total = snapshot.data!.docs.length.toString();
                              return Text(
                                total,
                                style: TextStyle(
                                  color: colorBlue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 1,
                      height: 40,
                      child: Container(
                        color: Colors.grey[800],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Total Lecturers',
                          style: TextStyle(
                            color: colorBlue,
                            fontSize: 16,
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'lecturer')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              var total = snapshot.data!.docs.length.toString();
                              return Text(
                                total,
                                style: TextStyle(
                                  color: colorBlue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(top: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 15,
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Courses',
                          style: TextStyle(
                            color: colorBlue,
                            fontSize: 16,
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('course')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              var total = snapshot.data!.docs.length.toString();
                              return Text(
                                total,
                                style: TextStyle(
                                  color: colorBlue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 1,
                      height: 40,
                      child: Container(
                        color: Colors.grey[800],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Total Classes',
                          style: TextStyle(
                            color: colorBlue,
                            fontSize: 16,
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('class')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              var total = snapshot.data!.docs.length.toString();
                              return Text(
                                total,
                                style: TextStyle(
                                  color: colorBlue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildButton(width, height, splashColor, buttonText, buttonColor,
      borderRadius, routePage) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: buttonColor,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: splashColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return routePage;
                  },
                ),
              );
            },
            child: Center(
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // //Delete users AlertDialog
  // AlertDialog deleteDialog(QueryDocumentSnapshot snapshot) {
  //   return  AlertDialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     title: const Text('Are you sure you want to delete this data?'),
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           FirebaseFirestore.instance
  //           .collection('users')
  //               .doc(snapshot.id).delete();
  //           Navigator.of(context, rootNavigator: true).pop();
  //         },
  //         child: const Text(
  //           'DELETE',
  //           style: TextStyle(color: Colors.red),
  //         ),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //         },
  //         child: const Text(
  //           'CANCEL',
  //           style: TextStyle(color: Colors.blue),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  //Delete Users (Students & Lecturers) Using ArtSweetAlert
  Future<void> deleteUsers(QueryDocumentSnapshot snapshot) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          denyButtonText: "Cancel",
          title: "Delete "
              "${(snapshot.data() as dynamic)['first_name']} "
            "${(snapshot.data() as dynamic)['last_name']} ?",
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
          .collection('users')
          .doc(snapshot.id)
          .delete();

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

  //Delete Course Using ArtSweetAlert
  Future<void> deleteCourse(QueryDocumentSnapshot snapshot) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          denyButtonText: "Cancel",
          title: "Delete " "${(snapshot.data() as dynamic)['course_name']} ?",
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
          .collection('course')
          .doc(snapshot.id)
          .delete();

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

  //Delete Class Using ArtSweetAlert
  Future<void> deleteClass(QueryDocumentSnapshot snapshot) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          denyButtonText: "Cancel",
          title: "Delete " "${(snapshot.data() as dynamic)['class_name']} ?",
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
          .collection('class')
          .doc(snapshot.id)
          .delete();

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

}
