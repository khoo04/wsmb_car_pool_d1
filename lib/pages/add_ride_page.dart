import 'package:car_pool_driver/helper.dart';
import 'package:car_pool_driver/models/ride.dart';
import 'package:car_pool_driver/services/ride_service.dart';
import 'package:flutter/material.dart';

class AddRidePage extends StatefulWidget {
  const AddRidePage({super.key});

  @override
  State<AddRidePage> createState() => _AddRidePageState();
}

class _AddRidePageState extends State<AddRidePage> {
  final _addRideFormKey = GlobalKey<FormState>();
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final fareController = TextEditingController();
  final rideDateController = TextEditingController();

  DateTime rideDate = DateTime.now();

  Future<void> _chooseDate() async {
    final pickedDate = await showDatePicker(
        context: context, firstDate: DateTime(1800), lastDate: DateTime(2200));

    if (pickedDate == null) {
      return;
    }

    final pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime == null) {
      return;
    }
    rideDate =
        pickedDate.copyWith(hour: pickedTime.hour, minute: pickedTime.minute);
    setState(() {
      rideDateController.text =
          "${rideDate.day}/${rideDate.month}/${rideDate.year} ${rideDate.hour.toString().padLeft(2, '0')}:${rideDate.minute.toString().padLeft(2, '0')}";
    });
  }

  void addRide() async {
    if (_addRideFormKey.currentState!.validate()) {
      Ride rideModel = Ride(
        origin: originController.text.trim(),
        destination: destinationController.text.trim(),
        startDateTime: rideDate,
        fare: double.parse(fareController.text.trim()),
      );
      bool isSuccess = await RideService.createNewRide(rideModel);
      if (isSuccess) {
        Navigator.pop(context);
        Helper.showSnackBar(context, "Ride added Successfully");
      } else {
        Helper.showSnackBar(context, "Error occurred in adding ride");
      }
    } else {
      debugPrint("Add Ride Form not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Ride")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Form(
          key: _addRideFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: originController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Origin",
                  labelText: "Origin",
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Origin is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: destinationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Destination",
                  labelText: "Destination",
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Destination is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onTap: () async {
                  _chooseDate();
                },
                readOnly: true,
                controller: rideDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ride Date and Time",
                  labelText: "Ride Date and Time",
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Date and time is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: fareController,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Ride Fare",
                  labelText: "Ride Fare",
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ride Fare is required";
                  }
                  if (double.tryParse(value) == null) {
                    return "Only number and decimal is allowed";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    addRide();
                  },
                  label: const Text("Add new ride"),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
