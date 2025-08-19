import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class CloudinaryUploader {
  final String cloudName = "doldqo1ot";
  // final String uploadPreset =
  //     "Qdveq92S1R-FQ8hCXAOosv0eOtc"; // From Cloudinary settings
  final String uploadPreset = "ktjqccyw"; // From Cloudinary settings

  /// Pick an image from the gallery
  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Upload to Cloudinary
  Future<String?> uploadImageToCloudinary(
    final imageFile,
    String imageName,
  ) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    var request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    var response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return data['secure_url']; // Cloudinary image link
    } else {
      debugPrint("Cloudinary upload failed: ${response.statusCode}");
      return null;
    }
  }

  /// Save the link to Firestore under patient's section
  Future<void> saveImageLinkToFirestore(
    String patientId,
    String imageUrl,
    String imageName,
  ) async {
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(patientId)
        .collection('medical_images')
        .add({
          'imageName': imageName,
          'imageUrl': imageUrl,
          'uploadedAt': FieldValue.serverTimestamp(),
        });
  }

  /// Main function: Pick → Upload → Save
  Future<void> pickUploadAndSave(String patientId) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    final imageName = image!.name;

    String? imageUrl = await uploadImageToCloudinary(image, image.name);
    if (imageUrl != null) {
      await saveImageLinkToFirestore(patientId, imageUrl, imageName);
      debugPrint("Image uploaded and saved successfully!");
    }
  }

  Future<void> saveProfileImageToFirestore(
    String path,
    String patientId,
    String imageUrl,
    String imageName,
  ) async {
    await FirebaseFirestore.instance.collection(path).doc(patientId).update({
      'profileUrl': imageUrl,
    });
  }

  Future<void> pickProfileAndSave(String patientId, String path) async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? profileUrl = await uploadImageToCloudinary(image, image.name);
      if (profileUrl != null) {
        await saveProfileImageToFirestore(
          patientId,
          profileUrl,
          image.name,
          path,
        );
        debugPrint("Image uploaded and saved successfully!");
      }
    }
  }
}
