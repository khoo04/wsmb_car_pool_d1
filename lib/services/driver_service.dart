import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';

class DriverService {
  static final driverRef = FirebaseFirestore.instance.collection('drivers');

  static Future<bool> createNewDriver(Driver driver) async {
    try {
      String? uId = FirebaseAuth.instance.currentUser?.uid;
      await driverRef.doc(uId).set(driver.toJson());
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<Driver?> getCurrentLoginUser() async {
    try {
      String? uId = FirebaseAuth.instance.currentUser?.uid;
      final snapshot = await driverRef.doc(uId).get();
      final userData = snapshot.data();
      if (userData != null) {
        Driver driver = Driver.fromJson(userData);
        return driver;
      } else {
        throw Exception("Driver does not exist");
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<bool> checkIsDuplicated(String email, String ic) async {
    final snapshotEmail =
        await driverRef.where("email", isEqualTo: email).get();
    final snapshotIC = await driverRef.where("IC", isEqualTo: ic).get();
    if (snapshotEmail.docs.isEmpty && snapshotIC.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> updateDriverDetails(Driver driver) async {
    try {
      String? uId = FirebaseAuth.instance.currentUser?.uid;
      await driverRef.doc(uId).update({
        "name": driver.name,
        "address": driver.address,
        "phone": driver.phone,
      });
      return true;
    } catch (e) {
      debugPrint("Error occurred in updating driver details");
      return false;
    }
  }

  static Future<bool> updateDriverVehicle(Vehicle vehicle) async {
    try {
      String? uId = FirebaseAuth.instance.currentUser?.uid;
      await driverRef.doc(uId).update({"vehicle": vehicle.toJson()});
      return true;
    } catch (e) {
      debugPrint("Error occurred in updating vehicle details");
      return false;
    }
  }
}
