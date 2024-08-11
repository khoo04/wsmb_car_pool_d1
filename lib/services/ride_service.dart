import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/driver.dart';
import '../models/ride.dart';
import 'driver_service.dart';

class RideService {
  static final rideRef = FirebaseFirestore.instance.collection('rides');

  static get driverRef => null;

  static Future<bool> createNewRide(Ride ride) async {
    try {
      //Get current driver doc ref
      String? uId = FirebaseAuth.instance.currentUser?.uid;
      final driverRef = DriverService.driverRef.doc(uId);
      //Attach driver ref to ride
      ride.driverRef = driverRef;
      rideRef.add(ride.toJson());
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getUserRide() async {
    List<Map<String, dynamic>> rideList = [];
    String? uId = FirebaseAuth.instance.currentUser?.uid;
    final driverRef = DriverService.driverRef.doc(uId);
    final driverDetails = (await driverRef.get()).data();
    if (driverDetails == null) {
      throw Exception("Unable to get driver info");
    }
    Driver driver = Driver.fromJson(driverDetails);

    //Get current driver ride
    final querySnapshot =
        await rideRef.where("driver", isEqualTo: driverRef).get();
    for (var doc in querySnapshot.docs) {
      final rideData = doc.data();

      //Change ref to model
      rideData["driver"] = driver;
      Ride rideModel = Ride.fromJson(rideData);
      rideList.add({
        "id": doc.id,
        "data": rideModel,
      });
    }
    return rideList;
  }

  static Future<bool> deleteRide(String docId) async {
    try {
      await rideRef.doc(docId).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
