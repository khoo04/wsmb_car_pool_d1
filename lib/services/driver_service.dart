import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/driver.dart';

class DriverService {
  static Future<bool> createNewDriver(Driver driver) async {
    try {
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
