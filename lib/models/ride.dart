import 'package:cloud_firestore/cloud_firestore.dart';

import 'driver.dart';

class Ride {
  final String origin;
  final String destination;
  final DateTime startDateTime;
  final double fare;
  late DocumentReference? driverRef;
  late Driver? driver;
  late List<DocumentReference> riderRefs;

  Ride({
    required this.fare,
    required this.origin,
    required this.destination,
    required this.startDateTime,
    this.driverRef,
    this.driver,
    this.riderRefs = const <DocumentReference>[],
  });

  Map<String, dynamic> toJson() {
    return {
      "origin": origin,
      "destination": destination,
      "startDateTime": startDateTime,
      "fare": fare,
      "driver": driverRef,
      "riders": riderRefs,
    };
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      origin: json["origin"],
      destination: json["destination"],
      startDateTime: (json["startDateTime"] as Timestamp).toDate(),
      driver: json["driver"],
      fare: json["fare"] as double,
    );
  }
}
