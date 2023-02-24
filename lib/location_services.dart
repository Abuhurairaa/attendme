import 'dart:async';

import 'package:attendme/student_ui/student_location.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  final StreamController<StudentLocation> _locationStreamController =
      StreamController<StudentLocation>();
  Stream<StudentLocation> get locationStream =>
      _locationStreamController.stream;

  LocationService() {
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        location.requestService();
        location.getLocation().then((locationData) {
          if (locationData != null) {
            _locationStreamController.add(
                StudentLocation(locationData.latitude, locationData.longitude));
          }
        });
      }
    });
  }

  void dispose() => _locationStreamController.close();
}
