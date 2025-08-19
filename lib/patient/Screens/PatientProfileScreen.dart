import 'package:flutter/material.dart';
import 'package:meditrack/CloudinaryServices/cludinary.dart';
import 'package:meditrack/FirebaseServices/FirebaseAuthentication.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/FirebaseServices/MedicationReminderServices.dart';
import 'package:meditrack/patient/Auth/patient_login.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/constants/UserConstants.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  bool isEditing = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // String profileUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 👈 Load user data on screen start
  }

  final _user = getCurrentUser();
  Future<void> _loadUserData() async {
    try {
      final userData = await UserLocalStorage.getUserData();

      final notificationService = NotificationService();
      await notificationService.initNotification();
      await notificationService.scheduleFirebaseReminders(getCurrentUser().uid);

      profileUrl = userData['profileUrl'] ?? '';
      userName = userData['userName'] ?? '';
      userEmail = userData['userEmail'] ?? '';
      if (_user != null) {
        final docSnapshot =
            await fireStore.collection('patients').doc(_user.uid).get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          setState(() {
            profileUrl = data?['profileUrl'] ?? '';
            userName = data?['name'];
            _phoneController.text = data?['number'] ?? '';
            userEmail = data?['email'] ?? '';
            _genderController.text = data?['gender'] ?? 'Not Mentioned';
            _ageController.text = data?['age'] ?? 'Not Mentioned';
            _weightController.text = data?['weight'] ?? 'Not Mentioned';
            _bloodGroupController.text = data?['bloodGroup'] ?? 'Not Mentioned';
            _addressController.text = data?['address'] ?? 'Not Mentioned';
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    CloudinaryUploader cloudinaryUploader = CloudinaryUploader();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: CustomColors.primaryPurple,
          ),
        ),
        actions: [
          IconButton(
            color: CustomColors.primaryPurple,
            icon: Icon(Icons.logout),
            onPressed: () {
              // Add logout logic here
              logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PatientLoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Stack(
              children: [
                ClipOval(
                  child:
                      profileUrl == null || profileUrl.length == 0
                          ? Image.asset(
                            "assets/images/profile.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                          : Image.network(
                            profileUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      cloudinaryUploader.pickProfileAndSave(
                        getCurrentUser().uid,
                        'patients',
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            Text(
              userName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: CustomColors.textDark,
              ),
            ),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: CustomColors.textSub,
              ),
            ),
            const SizedBox(height: 12),
            _buildProfileField(
              'Phone',
              _phoneController,
              type: TextInputType.number,
            ),
            _buildProfileField('Gender', _genderController),
            _buildProfileField(
              'Age',
              _ageController,
              type: TextInputType.number,
            ),
            _buildProfileField(
              'Weight',
              _weightController,
              type: TextInputType.number,
            ),
            _buildProfileField('Blood Group', _bloodGroupController),
            _buildProfileField('Address', _addressController),
            const SizedBox(height: 6),
            // Edit / Save button
            SizedBox(
              height: 50,
              width: width * 3,
              child: OutlinedButton(
                onPressed: () async {
                  if (isEditing) {
                    if (_user != null) {
                      await fireStore
                          .collection('patients')
                          .doc(_user.uid)
                          .update({
                            'number': _phoneController.text,
                            'gender': _genderController.text,
                            'age': _ageController.text,
                            'bloodGroup': _bloodGroupController.text,
                            'weight': _weightController.text,
                            'address': _addressController.text,
                          });
                    }
                  }

                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Text(
                  isEditing ? 'Save' : 'Edit',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.primaryPurple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller, {
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 17,
            color: CustomColors.textSub,
          ),
          fillColor: CustomColors.accentPurple,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
