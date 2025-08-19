import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseAuthentication.dart';

import 'package:meditrack/patient/Auth/patient_login.dart';
import 'package:meditrack/patient/PatientApp.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/custoButton.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';
import 'package:meditrack/shared/widgets/showSnackBar.dart';

class PatientSignUpPage extends StatelessWidget {
  const PatientSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _passController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "MediTrack - Patient",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primaryPurple,
                    ),
                  ),
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 16),
                  textFormFeild("Username", controller: _nameController),
                  const SizedBox(height: 16),
                  textFormFeild("Email", controller: _emailController),
                  const SizedBox(height: 16),
                  textFormFeild(
                    "Password",
                    controller: _passController,
                    obsecureText: true,
                  ),
                  const SizedBox(height: 16),
                  textFormFeild(
                    "Phone Number",
                    controller: _phoneController,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  customButton("Sign In", () async {
                    String _name = _nameController.text.trim();
                    String _pass = _passController.text;
                    String _email = _emailController.text;
                    String _number = _phoneController.text.trim();
                    bool success;

                    if (_name.isNotEmpty &&
                        _pass.isNotEmpty &&
                        _email.isNotEmpty &&
                        _number.isNotEmpty) {
                      success = await signUpPatient(
                        // ✅ NOT signInUser
                        _name,
                        _email,
                        _pass,
                        _number,
                      );
                      if (success) {
                        showCustomSnackBar(
                          context,
                          "Sign Up Successful",
                          backgroundColor: Colors.greenAccent,
                        );

                        // await createPatientWithReminderStructure(
                        //   getCurrentUser().uid,
                        // );

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => PatientApp()),
                          (route) => false,
                        );
                      } else {
                        showCustomSnackBar(
                          context,
                          "Sign Up Failed",
                          backgroundColor: Colors.redAccent,
                        );
                      }
                    } else {
                      showCustomSnackBar(
                        context,
                        "All Fields Required",
                        backgroundColor: Colors.red,
                      );
                    }
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientLoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
