import 'package:attendme/student_ui/student_attend_page.dart';
import 'package:attendme/student_ui/student_scan.dart';
import 'package:attendme/student_ui/student_selected_class.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:intl/intl.dart';
import 'package:attendme/auth_services.dart';
import 'package:attendme/main.dart';

import 'package:attendme/student_ui/student_edit_email.dart';
import 'package:attendme/student_ui/student_edit_password.dart';
import 'package:attendme/student_ui/student_edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  Color colorBlue = Colors.blue[900]!;
  late String dateStartString;
  late String dateEndString;
  List<String> id = <String>[];
  List<String> attendance_id = <String>[];
  var dataValue;
  var photo;
  var photoURL;

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = Provider.of<User?>(context);
    var user;
    if (firebaseUser == null) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              user = snapshot.data;
              if (user.data()['photo'] != null) {
                photoURL = user.data()['photo'];
              }
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    toolbarHeight: 0.0,
                    elevation: 0,
                  ),
                  bottomNavigationBar: Container(
                    height: MediaQuery.of(context).size.height / 10,
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: -5,
                          blurRadius: 30,
                          offset: const Offset(0, -20),
                        ),
                      ],
                    ),
                    child: const TabBar(
                      unselectedLabelColor: Colors.white54,
                      indicatorColor: Colors.transparent,
                      tabs: [
                        Tab(
                          text: "Home",
                          icon: Icon(Icons.home),
                        ),
                        Tab(
                          text: "Attendance",
                          icon: Icon(Icons.menu_book),
                        ),
                        Tab(
                          text: "Profile",
                          icon: Icon(Icons.account_circle),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      SafeArea(
                          child: LayoutBuilder(
                              builder: (context, constraints) =>
                                  homeBar(context, user))),
                      SafeArea(
                          child: LayoutBuilder(
                              builder: (context, constraints) =>
                                  attendanceBar(context, user))),
                      SafeArea(
                          child: LayoutBuilder(
                              builder: (context, constraints) =>
                                  profileBar(context, user, firebaseUser))),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          });
    }
  }

  Container profileBar(context, user, firebaseUser) {
    if (user != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (photoURL == null)
                                ? const AssetImage('assets/img/photo.jpg')
                                : NetworkImage(user.data()['photo']) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Text(
                            user.data()['first_name'] +
                                ' ' +
                                user.data()['last_name'],
                            style: TextStyle(
                                fontSize: 22,
                                color: colorBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.data()['role'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditProfileStudent(data: user);
                        },
                      ),
                    );
                  },
                  leading: Icon(Icons.account_box, color: colorBlue),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: colorBlue,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditEmailStudent(data: firebaseUser);
                        },
                      ),
                    );
                  },
                  leading: Icon(Icons.email_rounded, color: colorBlue),
                  title: Text(
                    'Change Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: colorBlue,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditPasswordStudent(data: firebaseUser);
                        },
                      ),
                    );
                  },
                  leading: Icon(Icons.vpn_key, color: colorBlue),
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: colorBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Container homeBar(context, user) {
    if (user != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        color: Colors.white,
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (photoURL == null)
                                  ? const AssetImage('assets/img/photo.jpg')
                                  : NetworkImage(user.data()['photo']) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              child: Text(
                                'Welcome, ' " ${user.data()['first_name']}",
                                style: TextStyle(
                                    color: colorBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              user.data()['role'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: colorBlue),
                    onPressed: () {
                      AuthServices.logout(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MyApp();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              Card(
                color: colorBlue,
                margin: const EdgeInsets.only(top: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 15,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          "Let's go attend a class",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildButton(
                              100.0,
                              60.0,
                              Colors.grey[800],
                              Icons.qr_code_rounded,
                              Colors.white,
                              10.0,
                              'Scan QR',
                              const Scan()),
                          const SizedBox(width: 16),
                          buildButtonCode(
                              100.0,
                              60.0,
                              Colors.grey[800],
                              Icons.vpn_key_rounded,
                              Colors.white,
                              10.0,
                              'Enter Code',
                              const Scan()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  'My Presence',
                  style: TextStyle(
                      color: colorBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: Colors.green[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 15,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.23,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Text(
                              'Present',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('presence')
                                    .where('student_id',
                                        isEqualTo: user.data()['user_id'])
                                    .where('status', isEqualTo: 1)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      return Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      return const Text(
                                        '0',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.orange[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 15,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.23,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Text(
                              'Late',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('presence')
                                    .where('student_id',
                                        isEqualTo: user.data()['user_id'])
                                    .where('status', isEqualTo: 2)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      return Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      return const Text(
                                        '0',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.red[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 15,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Column(
                          children: [
                            const Text(
                              'Absent',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('presence')
                                    .where('student_id',
                                        isEqualTo: user.data()['user_id'])
                                    .where('status', isEqualTo: 0)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      return Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      return const Text(
                                        '0',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  'On Going Class',
                  style: TextStyle(
                      color: colorBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('presence')
                        .where('student_id', isEqualTo: user.data()['user_id'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return Column(
                            children: snapshot.data!.docs.map<Widget>((e) {
                              return buildGoingClass(e);
                            }).toList(),
                          );
                        } else {
                          return const Text(
                            'No on going class!',
                            textAlign: TextAlign.start,
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Container buildGoingClass(QueryDocumentSnapshot e) {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('attendance')
                  .doc((e.data() as dynamic)['attendance_id'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  var dateNow = DateTime.now();

                  var attendance = snapshot.data!.data();

                  if (dateNow.isBefore(attendance!['dateEnd'].toDate())) {
                    dateEndString = DateFormat('MMM d, yyyy | kk:mm')
                        .format(attendance['dateEnd'].toDate());

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  attendance['class_name'],
                                  style: TextStyle(
                                    color: colorBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  attendance['lecturer_name'],
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 14),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Text(
                                      ((e.data() as dynamic)['status'] == 1)
                                          ? 'Present'
                                          : ((e.data() as dynamic)['status'] == 2)
                                              ? 'Late'
                                              : 'Absent',
                                      style: TextStyle(
                                          color: ((e.data() as dynamic)['status'] == 1)
                                              ? Colors.green
                                              : ((e.data() as dynamic)['status'] == 2)
                                                  ? Colors.yellow[800]
                                                  : Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                            ((e.data() as dynamic)['status'] == 0)
                                ? Container(
                                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: colorBlue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          ((e.data() as dynamic)['message'] == null)
                                              ? showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      leaveMessage(e))
                                              : showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      seeMessage(e));
                                        });
                                      },
                                      child: Text(
                                        ((e.data() as dynamic)['message'] == null)
                                            ? 'Leave Absent Message'
                                            : 'See Message',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Divider(
                              color: Colors.grey[800],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'TIME LEFT',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                CountdownTimer(
                                  endTime: attendance['dateEnd']
                                      .toDate()
                                      .millisecondsSinceEpoch,
                                  widgetBuilder: (context, time) {
                                    if (time == null) {
                                      return const Text('Class over!');
                                    } else {
                                      if (time.days != null) {
                                        return Text(
                                          '${time.days} DAY',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        );
                                      } else if (time.hours != null) {
                                        return Text(
                                          '${time.hours} : ${time.min} : ${time.sec}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        );
                                      } else if (time.min != null) {
                                        return Text(
                                          '00 : ${time.min} : ${time.sec}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          '${time.sec} Second',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }

  Container attendanceBar(context, user) {
    User firebaseUser = Provider.of<User>(context);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userClass =
        firestore.collection('users').doc(firebaseUser.uid).collection('class');

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Colors.white,
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
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
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  child: Text(
                    'Join class',
                    style: TextStyle(color: colorBlue, fontSize: 14),
                  ),
                  onPressed: () {
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (context) => alertDialog(user));
                    });
                  },
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.topLeft,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(firebaseUser.uid)
                    .collection('takenClass')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Row(
                          children: snapshot.data!.docs
                              .map<Widget>((e) => buildCard(e, userClass))
                              .toList(),
                        ),
                      );
                    } else {
                      return const Text('Have not taken a class');
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Attendance',
                    style: TextStyle(
                        color: colorBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('presence')
                    .where('student_id', isEqualTo: user.data()['user_id'])
                     .orderBy('created_at', descending: false)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          children: snapshot.data!.docs
                              .map<Widget>(
                                (e) => buildAttendanceCard(e),
                              )
                              .toList(),
                        ),
                      );
                    } else {
                      return const Text('No attendance found!');
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildButton(width, height, splashColor, buttonIcon, buttonColor,
      borderRadius, buttonText, routePage) {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    buttonIcon,
                    color: colorBlue,
                    size: 32,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    buttonText,
                    style: TextStyle(color: colorBlue, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildButtonCode(width, height, splashColor, buttonIcon, buttonColor,
      borderRadius, buttonText, routePage) {
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
              setState(() {
                showDialog(context: context, builder: (context) => enterCode());
              });
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    buttonIcon,
                    color: colorBlue,
                    size: 32,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    buttonText,
                    style: TextStyle(color: colorBlue, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card buildCard(e, deleteData) {
    return Card(
      color: colorBlue,
      margin: const EdgeInsets.only(right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(12),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('class')
                .doc(e.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                var classData = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classData?.data()?['class_name'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            child: Text(
                              classData?.data()?['lecturer_name'] ?? '',
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 5),
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
                                return SelectedClass(
                                  sendedData: classData,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          'See Class',
                          style: TextStyle(
                            color: colorBlue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  AlertDialog alertDialog(user) {
    User? firebaseUser = Provider.of<User?>(context);

    return AlertDialog(
      elevation: 10,
      title: const Text('Join a class'),
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('class').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  final List<DropdownMenuItem> data = [];
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    DocumentSnapshot snap = snapshot.data!.docs[i];

                    data.add(
                      DropdownMenuItem(
                        value: (snap.data() as dynamic)['class_id'],
                        child: Text((snap.data() as dynamic)['class_name']),
                      ),
                    );
                  }

                  return DropdownButton(
                    hint: const Text('Select a class'),
                    value: dataValue,
                    items: data,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        dataValue = value;
                      });
                    },
                  );
                } else {
                  return const Text('Data not found!');
                }
              },
            ),
          ],
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'CANCEL',
            style: TextStyle(color: colorBlue),
          ),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser?.uid)
                .collection('takenClass')
                .doc(dataValue)
                .set({'class_id': dataValue});

            await FirebaseFirestore.instance
                .collection('class')
                .doc(dataValue)
                .collection('joinedStudent')
                .doc(firebaseUser?.uid)
                .set({'student_id': user.data()['user_id']});

            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'JOIN',
            style: TextStyle(color: colorBlue),
          ),
        ),
      ],
    );
  }

  AlertDialog leaveMessage(e) {
    final TextEditingController messageController = TextEditingController();
    if ((e.data()['message'] != null)) {
      messageController.text = e.data()['message'];
    }
    return AlertDialog(
      elevation: 10,
      title: const Text('Leave Message for Absent'),
      content: StatefulBuilder(builder: (context, setState) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            maxLines: 4,
            controller: messageController,
            onChanged: (value) {},
            decoration: InputDecoration(
              labelStyle: TextStyle(color: colorBlue),
              hintText: 'message for absent...',
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
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'CANCEL',
            style: TextStyle(color: colorBlue),
          ),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('presence')
                .doc(e.id)
                .update({'message': messageController.text});
            setState(() {
              Navigator.of(context, rootNavigator: true).pop();
            });
          },
          child: Text(
            'SAVE',
            style: TextStyle(color: colorBlue),
          ),
        ),
      ],
    );
  }

  AlertDialog enterCode() {
    final TextEditingController codeController = TextEditingController();

    return AlertDialog(
      elevation: 10,
      title: const Text('Enter Code'),
      content: StatefulBuilder(builder: (context, setState) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            maxLength: 6,
            controller: codeController,
            onChanged: (value) {},
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelStyle: TextStyle(color: colorBlue),
              hintText: '000000',
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
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            'CANCEL',
            style: TextStyle(color: colorBlue),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AttendClass(
                    data: codeController.text,
                  );
                },
              ),
            );
          },
          child: Text(
            'ENTER',
            style: TextStyle(color: colorBlue),
          ),
        ),
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
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            setState(() {
              showDialog(
                  context: context, builder: (context) => leaveMessage(e));
            });
          },
          child: Text(
            'EDIT',
            style: TextStyle(color: colorBlue),
          ),
        ),
      ],
    );
  }

  Card buildAttendanceCard(QueryDocumentSnapshot e) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('attendance')
                  .doc((e.data() as dynamic)['attendance_id'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  var attendance = snapshot.data!.data();
                  dateStartString = DateFormat('MMM d, yyyy | kk:mm')
                      .format(attendance!['dateStart'].toDate());
                  dateEndString = DateFormat('MMM d, yyyy | kk:mm')
                      .format(attendance['dateEnd'].toDate());
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        attendance['class_name'],
                        style: TextStyle(
                          color: colorBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        attendance['lecturer_name'],
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      Text(
                        'Start : $dateStartString',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        'End : $dateEndString',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                            ((e.data() as dynamic)['status'] == 1)
                                ? 'Present'
                                : ((e.data() as dynamic)['status'] == 2)
                                    ? 'Late'
                                    : 'Absent',
                            style: TextStyle(
                                color: ((e.data() as dynamic)['status'] == 1)
                                    ? Colors.green
                                    : ((e.data() as dynamic)['status'] == 2)
                                        ? Colors.yellow[800]
                                        : Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                      ((e.data() as dynamic)['status'] == 0)
                          ? Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: colorBlue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showDialog(
                                        context: context,
                                        builder: (context) => seeMessage(e));
                                  });
                                },
                                child: const Text(
                                  'See message',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
