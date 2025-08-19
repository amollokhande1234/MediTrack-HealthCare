import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meditrack/shared/constants/Colors.dart';
import 'package:meditrack/shared/widgets/customAppBar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";
  String _yourText = "";
  bool _loading = false;

  // ========= CONFIGURE ONE OF THESE =========
  // If your key starts with sk-or- (OpenRouter), keep this true.
  static const bool useOpenRouter = true;

  // Put your key here (NO extra spaces/newlines).
  // static const String apiKey =
  //     "";
  // ==========================================

  String get _baseUrl =>
      useOpenRouter
          ? "https://openrouter.ai/api/v1/chat/completions"
          : "https://api.deepseek.com/v1/chat/completions";

  String get _modelId =>
      useOpenRouter
          ? "deepseek/deepseek-chat" // OpenRouter model id
          : "deepseek-chat"; // DeepSeek direct model id

  Future<String> _chat(String prompt) async {
    try {
      final uri = Uri.parse(_baseUrl);

      await dotenv.load(fileName: ".env");
      String apiKey = dotenv.env['DEEP_SEEK_API'] ?? '';

      // Common headers
      final headers = <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      };

      // OpenRouter recommends these (not strictly required but helpful)
      if (useOpenRouter) {
        headers["HTTP-Referer"] = "meditrack.app"; // any string/URL you control
        headers["X-Title"] = "Meditrack Symptom Checker";
      }

      final body = jsonEncode({
        "model": _modelId,
        "messages": [
          {
            "role": "system",
            "content":
                "You are a concise medical assistant. You can suggest likely causes, red flags, and self-care steps, but always advise consulting a clinician for diagnosis.",
          },
          {"role": "user", "content": prompt},
        ],
      });

      final res = await http.post(uri, headers: headers, body: body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data["choices"]?[0]?["message"]?["content"] ?? "").toString();
      }

      // Try to surface helpful error messages
      String msg = "HTTP ${res.statusCode}";
      try {
        final err = jsonDecode(res.body);
        if (err is Map && err["error"] != null) {
          msg += " • ${err["error"]}";
        } else if (err["message"] != null) {
          msg += " • ${err["message"]}";
        } else {
          msg += " • ${res.body}";
        }
      } catch (_) {
        msg += " • ${res.body}";
      }
      return "❌ $msg";
    } catch (e) {
      return "⚠️ Network/Parse error: $e";
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _loading = true;
      _response = "";
    });
    final reply = await _chat(text);
    setState(() {
      _loading = false;
      _yourText = _controller.text.trim();
      _response = reply.isEmpty ? "(no content)" : reply;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        useOpenRouter ? "OpenRouter (DeepSeek)" : "DeepSeek Direct";
    return Scaffold(
      appBar: customAppBar(context, "AI Chat * DeepSeek"),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            _response.isEmpty
                ? Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/deepseekIcon.png',
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(height: 12),
                            Image.asset(
                              'assets/images/deepseekText.png',
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "I’m your healthcare assistant.\nHow can I help you today?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                : _loading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User message container
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CustomColors.calendarBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "You: ${_yourText}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Bot response container
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CustomColors.cardLightPink,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: SelectableText(
                            "DeepSeek Response :> \n \n $_response",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Ask Me Anything",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        _send();

                        if (_response.isNotEmpty) {
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
