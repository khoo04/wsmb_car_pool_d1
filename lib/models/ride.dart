import 'package:cloud_firestore/cloud_firestore.dart';

import 'driver.dart';

class Ride {
  final String origin;
  final String destination;
  final DateTime startDateTime;
  late DocumentReference driverRef;
  late Driver driver;
  late List<DocumentReference> riderRefs;

  Ride(
      {required this.origin,
      required this.destination,
      required this.startDateTime});
}
