import 'dart:io';

import 'package:car_pool_driver/helper.dart';
import 'package:car_pool_driver/services/auth_service.dart';
import 'package:car_pool_driver/services/driver_service.dart';
import 'package:car_pool_driver/widgets/register_form.dart';
import 'package:car_pool_driver/widgets/vehicle_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/driver.dart';
import '../models/vehicle.dart';
import '../services/storage_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Initiate State
  int currentPageIndex = 0;

  //Driver Register Form
  final _driverRegisterFormKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _icTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  String? gender;
  final _emailTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  XFile? image;

  //Vehicle Register Form
  void _setGender(String? value) {
    gender = value;
  }

  void _setUploadImage(XFile imageToUpload) {
    image = imageToUpload;
  }

  //Validate Driver Register Form
  Future<void> validateDriverRegisterForm() async {
    if (_driverRegisterFormKey.currentState!.validate()) {
      _pageController.nextPage(
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
      // String? downloadUrl;
      // if (image != null) {
      //   downloadUrl =
      //       await StorageService.uploadImageToStorage(File(image!.path));
      // }else{
      //   downloadUrl = null;
      // }
      //
      // Driver registerDriverModel = Driver(
      //     IC: _icTextController.text.trim(),
      //     name: '',
      //     gender: '',
      //     email: '',
      //     address: '',
      //     imageUrl: downloadUrl,
      //     vehicle: );
    } else {
      debugPrint("Driver register form is not valid");
    }
  }

  //Vehicle Register Form
  final _vehicleRegisterFormKey = GlobalKey<FormState>();
  final _carModelTextController = TextEditingController();
  final _capacityTextController = TextEditingController();
  final _specialFeaturesTextController = TextEditingController();

  Future<void> validateVehicleForm() async {
    if (_vehicleRegisterFormKey.currentState!.validate()) {
      try {
        Vehicle vehicleModel = Vehicle(
          carModel: _carModelTextController.text.trim(),
          capacity: int.parse(_capacityTextController.text.trim()),
          specialFeatures: _specialFeaturesTextController.text.trim(),
        );

        bool isDuplicated = await DriverService.checkIsDuplicated(
            _emailTextController.text.trim(), _icTextController.text.trim());

        if (isDuplicated) {
          Helper.showSnackBar(context, "User is already exist");
          return;
        }

        bool isSuccess = await AuthService.registerUser(
            _emailTextController.text.trim(),
            _passwordTextController.text.trim());

        if (isSuccess) {
          String? downloadUrl;
          if (image != null) {
            downloadUrl =
                await StorageService.uploadImageToStorage(File(image!.path));
          } else {
            throw Exception(
                "Unable to upload file. Please check internet connection!");
          }

          Driver registerDriverModel = Driver(
              IC: _icTextController.text.trim(),
              name: _nameTextController.text.trim(),
              gender: gender!,
              email: _emailTextController.text.trim(),
              address: _addressTextController.text.trim(),
              phone: _phoneTextController.text.trim(),
              imageUrl: downloadUrl,
              vehicle: vehicleModel);

          bool isSuccess =
              await DriverService.createNewDriver(registerDriverModel);
          if (isSuccess) {
            Helper.showSnackBar(context, "Driver registered successfully");
            Navigator.pop(context);
          } else {
            throw Exception("Unable to create driver in database!");
          }
        } else {
          throw Exception("Unable to register user!");
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      debugPrint("Driver register form is not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register as a Driver"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.black)),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    DriverRegisterForm(
                      formKey: _driverRegisterFormKey,
                      icTextController: _icTextController,
                      nameTextController: _nameTextController,
                      phoneTextController: _phoneTextController,
                      emailTextController: _emailTextController,
                      addressTextController: _addressTextController,
                      passwordTextController: _passwordTextController,
                      setGender: _setGender,
                      setImageToUpload: _setUploadImage,
                    ),
                    VehicleRegisterForm(
                      formKey: _vehicleRegisterFormKey,
                      carModelTextController: _carModelTextController,
                      capacityTextController: _capacityTextController,
                      specialFeaturesTextController:
                          _specialFeaturesTextController,
                    ),
                  ],
                  onPageChanged: (index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                    print(currentPageIndex);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: currentPageIndex == 1 ? () {} : null,
                  child: currentPageIndex == 1
                      ? const Text("Back")
                      : const SizedBox(),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (currentPageIndex == 0) {
                        await validateDriverRegisterForm();
                      } else if (currentPageIndex == 1) {
                        try {
                          await validateVehicleForm();
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      } else {
                        debugPrint("Invalid Page");
                      }
                    },
                    child: currentPageIndex == 0
                        ? const Text("Next")
                        : const Text("Register"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
