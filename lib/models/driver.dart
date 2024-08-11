import 'package:car_pool_driver/models/vehicle.dart';

class Driver {
  final String name;
  final String IC;
  final String gender;
  final String email;
  final String address;
  final String imageUrl;
  final Vehicle vehicle;

  Driver(
      {required this.IC,
      required this.name,
      required this.gender,
      required this.email,
      required this.address,
      required this.imageUrl,
      required this.vehicle});
}
