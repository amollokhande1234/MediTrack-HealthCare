import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:meditrack/FirebaseServices/FirebaseConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

String profileUrl = '';
String userName = '';
String userEmail = '';

Future<void> saveUserData(String username, String profileUrl) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("username", username);
  await prefs.setString("profileUrl", profileUrl);
}

// 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
// class DeepSeekService {
//   // final String apiKey =
//   //     "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";
//   String apiKey =
//       "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";
//   final String baseUrl = "https://api.deepseek.com/v1/chat/completions";

//   Future<void> getDeepSeekResponse(String prompt) async {
//     const String apiKey =
//         "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"; // replace with your key
//     const String apiUrl = "https://api.deepseek.com/chat/completions";

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $apiKey",
//       },
//       body: jsonEncode({
//         "model": "deepseek-chat", // or the correct model you enabled
//         "messages": [
//           {"role": "user", "content": prompt},
//         ],
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print("Response: ${data['choices'][0]['message']['content']}");
//     } else {
//       print("Error ${response.statusCode}: ${response.body}");
//     }
//   }
// }

class DeepSeekService {
  // replace with your real key
  final String apiUrl = "https://api.deepseek.com/v1/chat/completions";

  Future<String> getDeepSeekResponse(String prompt) async {
    await dotenv.load(fileName: ".env");
    String apiKey = dotenv.env['DEEP_SEEK_API'] ?? '';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "deepseek-chat", // make sure this is available in your account
        "messages": [
          {"role": "user", "content": prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }
}

class UserLocalStorage {
  // Save user details
  static Future<void> saveUserData() async {
    final user = getCurrentUser().uid;
    if (user != null) {
      final doc = await fireStore.collection('patients').doc(user).get();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("name", doc['name']);
      await prefs.setString("email", doc['email'] ?? "");
      await prefs.setString("profileUrl", doc['profileUrl'] ?? '');
      await prefs.setString("number", doc['number'] ?? 'NA');
    }
  }

  // Get user details
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString("name"),
      "email": prefs.getString("email"),
      "imageUrl": prefs.getString("imageUrl"),
    };
  }

  // Clear user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
