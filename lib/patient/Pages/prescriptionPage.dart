import 'package:flutter/material.dart';
import 'package:meditrack/CloudinaryServices/cludinary.dart';
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:meditrack/patient/Pages/prescriptionPreview.dart';
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/customAppBar.dart';

class prescriptionPage extends StatefulWidget {
  const prescriptionPage({super.key});

  @override
  State<prescriptionPage> createState() => prescriptionPageState();
}

class prescriptionPageState extends State<prescriptionPage> {
  CloudinaryUploader uploader = CloudinaryUploader();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Prescription Storage"),
      body: StreamBuilder(
        stream:
            fireStore
                .collection('patients')
                .doc(getCurrentUser().uid)
                .collection('medical_images')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No images found"));
          }

          var images = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 5, right: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 images per row for less space
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75, // A
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              var imageUrl = images[index]['imageUrl'];
              var imageName = images[index]['imageName'];
              var uploadTime =
                  images[index]['uploadedAt']; // Firestore Timestamp

              // Convert Timestamp to readable format
              String formattedTime = '';
              if (uploadTime != null) {
                DateTime dateTime = uploadTime.toDate();
                formattedTime =
                    "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    imageName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ImagePreviewScreen(imageUrl: imageUrl),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 140,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Text(
                    "Uploaded: $formattedTime",
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.textSub,
                    ),
                  ),

                  Divider(),
                ],
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploader.pickUploadAndSave(getCurrentUser().uid);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
