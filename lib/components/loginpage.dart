import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:limanplatform/components/appconfig.dart';
import 'package:limanplatform/components/webview_page.dart';
import 'package:limanplatform/constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> fetchData(String email, String password) async {
    final url = Uri.parse(
      'https://planrijles.nl/login.php?message&rijschool=liman',
    );

    final body = {"username": email, "password": password};

    print("POST URL: $url");
    print("POST body: $body");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "User-Agent": "Mozilla/5.0", // some servers require this
        },
        body: body,
        // followRedirects is true by default
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("booking".tr()), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              obscureText: false,
              cursorColor: Constants.primary, // Cursor color
              decoration: InputDecoration(
                labelText: "login".tr(),
                labelStyle: TextStyle(
                  color: Constants.primary, // Label color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.primary, // Border when focused
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.primary.withOpacity(
                      0.5,
                    ), // Border when not focused
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              cursorColor: Constants.primary, // Cursor color
              decoration: InputDecoration(
                labelText: "password".tr(),
                labelStyle: TextStyle(
                  color: Constants.primary, // Label color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.primary, // Border when focused
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.primary.withOpacity(
                      0.5,
                    ), // Border when not focused
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  fetchData(email, password);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primary, // 🔵 Button color
                  foregroundColor: Constants.background, // ⚪ Text color
                ),
                child: Text("loginButton".tr()),
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: "fogorPassword".tr(),
                style: const TextStyle(
                  color: Constants.primary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(
                          url:
                              "https://planrijles.nl/wachtwoordvergeten?rijschool=liman&setLanguage=${AppConfig.languageCode}",
                          name: "fogorPassword".tr(),
                        ),
                      ),
                    );
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchUrl(Uri parse, {required mode}) {}
}

class LaunchMode {}
