import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseAuthentication.dart';

import 'package:meditrack/patient/Auth/patient_signUp.dart';
import 'package:meditrack/patient/PatientApp.dart';

import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/custoButton.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';
import 'package:meditrack/shared/widgets/showSnackBar.dart';

class PatientLoginPage extends StatelessWidget {
  const PatientLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passController = TextEditingController();
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
                    "Login",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  textFormFeild("Username", controller: _emailController),
                  const SizedBox(height: 16),
                  textFormFeild(
                    "Password",
                    controller: _passController,
                    obsecureText: true,
                  ),
                  const SizedBox(height: 16),
                  // textFormFeild("Number"),
                  customButton("Login", () async {
                    var _email = _emailController.text.trim();
                    var _pass = _passController.text.trim();
                    bool loginSucsess;
                    if (_emailController != null && _passController != null) {
                      loginSucsess = await loginUser(_email, _pass);

                      // Yes Navigate to Next Screen

                      if (loginSucsess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => PatientApp()),
                          (route) => false,
                        );
                      } else {
                        Center(child: CircularProgressIndicator());
                      }
                    } else {
                      showCustomSnackBar(
                        context,
                        "Please Enter Valid Email and Passoword",
                        backgroundColor: Colors.red,
                      );
                    }
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientSignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
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
