import 'package:flutter/material.dart';

class VehicleRegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController carModelTextController;
  final TextEditingController capacityTextController;
  final TextEditingController specialFeaturesTextController;

  const VehicleRegisterForm({
    super.key,
    required this.formKey,
    required this.carModelTextController,
    required this.capacityTextController,
    required this.specialFeaturesTextController,
  });

  @override
  State<VehicleRegisterForm> createState() => _VehicleRegisterFormState();
}

class _VehicleRegisterFormState extends State<VehicleRegisterForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            children: [
              const Text(
                "Vehicle Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              //Car Model
              TextFormField(
                controller: widget.carModelTextController,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Car Model",
                  labelText: "Car Model",
                  isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Car Model is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              //Car Capacity
              TextFormField(
                controller: widget.capacityTextController,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Car Capacity",
                  labelText: "Car Capacity",
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Car Capacity is required";
                  }
                  if (int.tryParse(value) == null) {
                    return "Only number is allowed";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              //Address
              TextFormField(
                controller: widget.specialFeaturesTextController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      "State any special features, e.g. wheelchair accessible",
                  labelText: "Special Features",
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
