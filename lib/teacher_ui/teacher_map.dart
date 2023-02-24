import 'dart:typed_data';

import 'package:attendme/teacher_ui/teacher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SeeMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String studentName;
  final String studentId;


  const SeeMap({Key? key, required this.latitude, required this.longitude, required this.studentName, required this.studentId})
      : super(key: key);

  @override
  State<SeeMap> createState() => _SeeMapState();
}

class _SeeMapState extends State<SeeMap> {
  late Set<Marker> marker = {};
  late BitmapDescriptor customIcon;

  @override
  void initState() {
    marker = Set.from([]);
    super.initState();
  }

  createMarker(context){
    // if(customIcon == null){
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/img/location.png')
          .then((icon) {
          setState(() {
            customIcon = icon;
          });
      }) ;
    // }
  }

  @override
  Widget build(BuildContext context)   {
    createMarker(context);
    // final Set<Marker> marker = {};
    final LatLng currentPosition = LatLng(widget.latitude, widget.longitude);
    // late BitmapDescriptor customIcon;

        marker.add(
          Marker(
            markerId: MarkerId('${widget.latitude},${widget.longitude}'),
            position: currentPosition,
            icon: customIcon,
            //   icon: imageUrl != null
            //       ? BitmapDescriptor.fromBytes(
            //       await getBytesFromImageUrl(imageUrl!),
            // )
            // icon : BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: widget.studentName,
              snippet: 'ID: ${widget.studentId}',
            ),
          ),
        );

    Color colorBlue = Colors.blue[900]!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
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
          widget.studentName,
          style: TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GoogleMap(
        // myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller){
          // controller.setMapStyle(Utils.mapStyle);
        },
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: currentPosition,
          zoom: 16,
        ),
        markers: marker,
      ),
    );
  }

  // Function to retrieve the bytes from an image URL
  Future<Uint8List> getBytesFromImageUrl(String url) async {
    final ByteData bytes = await rootBundle.load(url);
    return bytes.buffer.asUint8List();
  }

}

class Utils{
  static String mapStyle = '''
  
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
  
  ''';
}

// To use a custom marker to retrieve a user's photo from a Firestore document collection in Flutter, you can follow these steps:
//
// Create a custom marker class that implements the Marker interface and contains the properties required to display the marker on the map.
// Retrieve the data from the Firestore document collection using the Firestore API in Flutter.
// Convert the data into instances of the custom marker class.
// Use the Marker class from the google_maps_flutter package to display the markers on a Google Map.
// Here is some example code to get you started:

// 1. Create a custom marker class
// class CustomMarker {
// final String photoUrl;
// final LatLng position;
//
// CustomMarker({required this.photoUrl, required this.position});
// }
//
// // 2. Retrieve the data from Firestore
// final CollectionReference usersCollection = FirebaseFirestore.instance
//     .collection('users');
// final QuerySnapshot usersSnapshot = await usersCollection.getDocuments();
// final List<CustomMarker> markers = [];
//
// for (var user in usersSnapshot.documents) {
// final String photoUrl = user.data['photoUrl'];
// final LatLng position = LatLng(user.data['latitude'], user.data['longitude']);
// markers.add(CustomMarker(photoUrl: photoUrl, position: position));
// }
//
// // 3. Convert the data into instances of the custom marker class
// final Set<Marker> mapMarkers = markers.map((m) => Marker(
// markerId: MarkerId(m.photoUrl),
// position: m.position,
// // add additional properties or customizations here
// )).toSet();
//
// // 4. Display the markers on a Google Map
// GoogleMap(
// markers: mapMarkers,
// // add additional properties or customizations here
// )
//Note that you will need to install the google_maps_flutter and cloud_firestore packages in your Flutter project in order to use the Google Maps and Firestore APIs, respectively.
