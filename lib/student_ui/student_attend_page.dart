import 'package:attendme/student_ui/student_scan.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:attendme/auth_services.dart';
import 'package:attendme/location_services.dart';
import 'package:attendme/student_ui/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AttendClass extends StatefulWidget {
  final String data;

  const AttendClass({Key? key, required this.data}) : super(key: key);
  @override
  _AttendClassState createState() => _AttendClassState();
}

class _AttendClassState extends State<AttendClass> {
  Color colorBlue = Colors.blue[900]!;
  var dataValue;
  var attendance;
  var user;
  LocationService locationService = LocationService();
  double latitude = 0;
  double longitude = 0;
  String? dateStartString;
  String? dateEndString;
  bool noClass = false;
  bool validate = false;

  @override
  void dispose() {
    locationService.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    locationService.locationStream.listen((userLocation) {
      setState(() {
        latitude = userLocation.latitude!;
        longitude = userLocation.longitude!;
      });
    });
  }

  GlobalKey qrKey = GlobalKey();
  late Barcode result;
  late QRViewController controller;

  late String keyCode;
  late DateTime dateNow;

  @override
  Widget build(BuildContext context) {
    keyCode = widget.data;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: colorBlue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const StudentPage();
                  },
                ),
              );
            },
          ),
          title: Text(
            'Attend Class',
            style: TextStyle(
              color: colorBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder(
          stream: AuthServices.firebaseUserStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              user = snapshot.data;
              return afterScan();
            }
          },
        ));
  }

  Container afterScan() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: colorBlue,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('attendance')
                        .doc(keyCode)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        if (snapshot.data!.data() == null) {
                          noClass = true;

                          return const Center(
                            child: Text(
                              'No class found!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          noClass = false;

                          attendance = snapshot.data!.data();
                          dateStartString = DateFormat('MMM d, yyyy | kk:mm')
                              .format(attendance['dateStart'].toDate());
                          dateEndString = DateFormat('MMM d, yyyy | kk:mm')
                              .format(attendance['dateEnd'].toDate());

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                attendance['class_name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                attendance['lecturer_name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                              ),
                              Text(
                                dateStartString!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                dateEndString!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  child: const Text(
                    'Please check the class data before submit!',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )),
              Divider(
                color: Colors.grey[800],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Wrong class?',
                      style: TextStyle(color: colorBlue),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Scan();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: colorBlue,
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10))),
                              child: const Icon(
                                Icons.qr_code,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => enterCode());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: colorBlue,
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10))),
                              child: const Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          (!noClass)
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      onPressed: () async {
                        var student;
                        dateNow = DateTime.now();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .get()
                            .then((value) async {
                          student = value.data();
                          await FirebaseFirestore.instance
                              .collection('presence')
                              .where('attendance_id', isEqualTo: keyCode)
                              .where('student_id',
                                  isEqualTo: student['user_id'])
                              .get()
                              .then((value) async {
                            for (int i = 0; i < value.docs.length; i++) {
                              DocumentSnapshot dataPresence = value.docs[i];
                              if ((dataPresence.data() as dynamic)!['status'] != 0) {
                                showDialog(
                                    context: context,
                                    builder: (context) => alreadyAttend());
                              } else {
                                if (dateNow
                                    .isAfter(attendance['dateEnd'].toDate())) {
                                  await FirebaseFirestore.instance
                                      .collection('presence')
                                      .doc(dataPresence.id)
                                      .update({
                                    'status': 2,
                                    'dateAttend': dateNow,
                                    'latitude': latitude,
                                    'longitude': longitude,
                                  });
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('presence')
                                      .doc(dataPresence.id)
                                      .update({
                                    'status': 1,
                                    'dateAttend': dateNow,
                                    'latitude': latitude,
                                    'longitude': longitude
                                  });
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const StudentPage();
                                    },
                                  ),
                                );
                              }
                            }
                          });
                        });
                      },
                      child: const Text('Attend Class!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  AlertDialog alreadyAttend() {
    return AlertDialog(
      elevation: 10,
      content: StatefulBuilder(builder: (context, setState) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text('You already attend this class!'));
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
              errorText: validate ? "Class Attendance Code is required!":null,
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
            if(keyCode.isEmpty){
              setState(() {
                validate = true;
              });
            }else {
              validate = false;
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
            }
          },
          child: Text(
            'ENTER',
            style: TextStyle(color: colorBlue),
          ),
        ),
      ],
    );
  }
}
