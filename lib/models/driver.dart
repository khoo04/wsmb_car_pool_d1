import 'package:car_pool_driver/models/vehicle.dart';

class Driver {
  final String name;
  final String IC;
  final String gender;
  final String email;
  final String address;
  final String? imageUrl;
  final Vehicle vehicle;

  Driver({
    required this.IC,
    required this.name,
    required this.gender,
    required this.email,
    required this.address,
    this.imageUrl,
    required this.vehicle,
  });

  Map<String, dynamic> toJson() {
    return {
      "IC": IC,
      "name": name,
      "gender": gender,
      "email": email,
      "address": address,
      "imageUrl": imageUrl,
      "vehicle": vehicle.toJson(),
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      IC: json["IC"],
      name: json["name"],
      gender: json["gender"],
      email: json["email"],
      address: json["address"],
      imageUrl: json["imageUrl"],
      vehicle: Vehicle.fromJson(json["vehicle"]),
    );
  }
}
