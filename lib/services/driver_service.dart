import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/driver.dart';

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
}
