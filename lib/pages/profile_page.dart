import 'package:car_pool_driver/services/driver_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helper.dart';
import '../models/driver.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController icTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController addressTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  String? gender;
  ImageProvider? userProfileImage;
  XFile? fileSelected;

  final TextEditingController carModelController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController specialFeaturesController =
      TextEditingController();

  Future<bool> checkPermission() async {
    var cameraPermission = await Permission.camera.status;
    var galleryPermission = await Permission.manageExternalStorage.status;

    if (cameraPermission.isDenied) {
      cameraPermission = await Permission.camera.request();
    }
    if (galleryPermission.isDenied) {
      cameraPermission = await Permission.manageExternalStorage.request();
    }
    if (cameraPermission.isGranted || galleryPermission.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void showBottomSheetOption() async {
    if (await checkPermission()) {
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 80,
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    fileSelected = await _pickImage(ImageSource.camera);
                    if (fileSelected != null) {
                      Navigator.pop(context);
                      setState(() {});
                    } else {
                      Navigator.pop(context);
                      Helper.showSnackBar(context, "Action cancel");
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  onPressed: () async {
                    fileSelected = await _pickImage(ImageSource.gallery);
                    if (fileSelected != null) {
                      Navigator.pop(context);
                      setState(() {});
                    } else {
                      Navigator.pop(context);
                      Helper.showSnackBar(context, "Action cancel");
                    }
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                ),
              ],
            ),
          );
        },
      );
    } else {
      Navigator.pop(context);
      Helper.showSnackBar(context, "Permission denied");
    }
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    return image;
  }

  void initPage() async {
    Driver? driver = await DriverService.getCurrentLoginUser();
    if (driver == null) {
      return;
    } else {
      icTextController.text = driver.IC;
      nameTextController.text = driver.name;
      phoneTextController.text = driver.phone;
      emailTextController.text = driver.email;
      addressTextController.text = driver.address;
      carModelController.text = driver.vehicle.carModel;
      capacityController.text = driver.vehicle.capacity.toString();
      specialFeaturesController.text = driver.vehicle.specialFeatures;

      if (driver.imageUrl != null) {
        userProfileImage = NetworkImage(driver.imageUrl!);
      }

      if (mounted) {
        setState(() {
          gender = driver.gender;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            Column(
              children: [
                const Text(
                  "Driver Profile",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Stack(
                  children: [
                    userProfileImage == null
                        ? const CircleAvatar(
                            radius: 60,
                            child: Icon(
                              Icons.person,
                              size: 60,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: userProfileImage,
                            radius: 60,
                          ),
                    //Not implement
                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   child: InkWell(
                    //     radius: 20,
                    //     borderRadius: BorderRadius.circular(20),
                    //     onTap: () {
                    //       showBottomSheetOption();
                    //     },
                    //     child: CircleAvatar(
                    //       backgroundColor: Colors.blue[600],
                    //       radius: 20,
                    //       child: const Icon(
                    //         Icons.edit,
                    //         size: 20,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //IC
                TextFormField(
                  controller: icTextController,
                  readOnly: true,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "IC Number",
                    labelText: "IC Number",
                    isDense: true,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                //Name
                TextFormField(
                  controller: nameTextController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Name",
                    labelText: "Name",
                    isDense: true,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                //Gender Dropdown
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Gender",
                    labelText: "Gender",
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Gender is required";
                    }
                    return null;
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "male",
                      child: Text("Male"),
                    ),
                    DropdownMenuItem(
                      value: "female",
                      child: Text("Female"),
                    ),
                  ],
                  value: gender,
                  onChanged: null,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                //Email
                TextFormField(
                  readOnly: true,
                  controller: emailTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Email",
                    labelText: "Email",
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.isEmail()) {
                      return 'Please provide a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                //Phone
                TextFormField(
                  controller: phoneTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Phone Number",
                    labelText: "Phone Number",
                    isDense: true,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    }
                    if (!RegExp(r'\d{3}-\d{7,9}').hasMatch(value)) {
                      return 'Please provide a phone number. Ex: 012-36202024';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                //Address
                TextFormField(
                  controller: addressTextController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Address",
                    labelText: "Address",
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Address is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      Helper.showSnackBar(
                          context, "This function not implement yet");
                      // Driver driver = Driver(
                      //     IC: icTextController.text.trim(),
                      //     name: nameTextController.text.trim(),
                      //     gender: gender!,
                      //     email: emailTextController.text.trim(),
                      //     address: addressTextController.text.trim(),
                      //     vehicle: Vehicle(
                      //       carModel: carModelController.text.trim(),
                      //       capacity: int.parse(carModelController.text.trim()),
                      //     ),
                      //     phone: phoneTextController.text.trim());
                      //
                      // if (driver == null) {
                      //   return;
                      // }
                      // bool isSuccess =
                      //     await DriverService.updateDriverDetails(driver);
                      // if (isSuccess) {
                      //   Helper.showSnackBar(
                      //       context, "Update driver successfully");
                      // } else {
                      //   Helper.showSnackBar(context,
                      //       "Error occurred in updating driver details");
                      // }
                    },
                    child: const Text("Update Profile"),
                  ),
                ),
              ],
            ),
            const Divider(),
            Column(
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
                  controller: carModelController,
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
                  controller: capacityController,
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
                  controller: specialFeaturesController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        "State any special features, e.g. wheelchair accessible",
                    labelText: "Special Features",
                    isDense: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Helper.showSnackBar(
                          context, "This function not implement yet");
                    },
                    child: const Text("Update Vehicle Details"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
