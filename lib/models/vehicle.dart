import 'dart:core';

class Vehicle {
  final String carModel;
  final int capacity;
  final String specialFeatures;

  Vehicle({
    required this.carModel,
    required this.capacity,
    this.specialFeatures = "",
  });
}
