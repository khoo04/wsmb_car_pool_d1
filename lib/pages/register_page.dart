import 'package:car_pool_driver/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  late XFile image;

  //Vehicle Register Form
  void _setGender(String? value) {
    gender = value;
  }

  void _setUploadImage(XFile imageToUpload) {
    image = imageToUpload;
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
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () {}, child: const Text("Back")),
                ElevatedButton(onPressed: () {}, child: const Text("Next"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
