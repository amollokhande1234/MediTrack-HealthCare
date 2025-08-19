import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseAuthentication.dart';
import 'package:meditrack/doctor/Auth/doctor_signUp.dart';
import 'package:meditrack/doctor/DoctorApp.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/custoButton.dart';
import 'package:meditrack/shared/widgets/customTextFormFeild.dart';
import 'package:meditrack/shared/widgets/showSnackBar.dart';

class DocotrLoginPage extends StatelessWidget {
  const DocotrLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController pass = TextEditingController();

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
                    "MediTrack - Doctor",
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
                  textFormFeild("Email", controller: email),
                  const SizedBox(height: 16),
                  textFormFeild(
                    "Password",
                    controller: pass,
                    obsecureText: true,
                  ),
                  const SizedBox(height: 16),
                  // textFormFeild("Number"),
                  customButton("Login", () async {
                    var _email = email.text.trim();
                    var _password = pass.text.trim();
                    bool loginSucsess;
                    if (_email != '' &&
                        _password != '' &&
                        _email.isNotEmpty &&
                        _password.isNotEmpty) {
                      loginSucsess = await loginUser(email.text, pass.text);

                      // Yes Navigate to Next Screen

                      if (loginSucsess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => DoctorApp()),
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
                              builder: (context) => DoctorSignUpPage(),
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
