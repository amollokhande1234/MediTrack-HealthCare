import 'package:flutter/material.dart';
import 'package:meditrack/FirebaseServices/FirebaseAuthentication.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/doctor/Auth/doctor_login.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/constants/DocConstants.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController specialistController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 👈 Load user data on screen start
  }

  final _user = getCurrentUser();

  get cloudinaryUploader => null;
  Future<void> _loadUserData() async {
    try {
      if (_user != '') {
        final docSnapshot =
            await fireStore.collection('doctors').doc(_user.uid).get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          setState(() {
            nameController.text = data?['name'];
            phoneController.text = data?['number'] ?? '';
            emailController.text = data?['email'] ?? '';
            genderController.text = data?['gender'] ?? '';
            ageController.text = data?['age'] ?? '';
            specialistController.text = data?['specialist'] ?? '';
            degreeController.text = data?['degree'] ?? '';
            addressController.text = data?['address'] ?? '';
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //   @override
  //   void dispose() {
  //     // TODO: implement dispose
  //     super.dispose();
  //     nameController
  // phoneController
  // emailController
  // genderController
  // ageController
  // specialistController
  // degreeController
  // addressController.di
  //   }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                MaterialPageRoute(builder: (context) => DocotrLoginPage()),
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
                      docProfileUrl.length == 0
                          ? Image.asset(
                            "assets/images/profile.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                          : Image.network(
                            docProfileUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      await cloudinaryUploader.pickProfileAndSave(
                        getCurrentUser().uid,
                        'doctors',
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
              "Dr. ${nameController.text}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: CustomColors.textDark,
              ),
            ),
            Text(
              emailController.text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: CustomColors.textSub,
              ),
            ),

            const SizedBox(height: 12),
            _buildProfileField(
              'Phone',
              phoneController,
              type: TextInputType.number,
            ),
            _buildProfileField('Gender', genderController),
            _buildProfileField(
              'Age',
              ageController,
              type: TextInputType.number,
            ),
            _buildProfileField('Spesialist', specialistController),
            _buildProfileField('Degree', degreeController),
            _buildProfileField('Address', addressController),
            const SizedBox(height: 6),
            // Edit / Save button
            SizedBox(
              height: 50,
              width: width * 3,
              child: OutlinedButton(
                onPressed: () async {
                  if (isEditing) {
                    final user = auth.currentUser;
                    if (user != null) {
                      await fireStore
                          .collection('doctors')
                          .doc(user.uid)
                          .update({
                            'number': phoneController.text,
                            'gender': genderController.text,
                            'age': ageController.text,
                            'specialist': specialistController.text,
                            'degree': degreeController.text,
                            'address': addressController.text,
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
