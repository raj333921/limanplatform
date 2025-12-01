import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:limanplatform/constants.dart';
import '../quiz/quizscreen.dart'; // import your quiz screen

class CodeCheckScreen extends StatefulWidget {
  const CodeCheckScreen({Key? key}) : super(key: key);
  @override
  State<CodeCheckScreen> createState() => _CodeCheckScreenState();
}

class _CodeCheckScreenState extends State<CodeCheckScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _validateCode(String langCode) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final code = _codeController.text.toUpperCase().trim();

    try {
      final resp = await http.post(
        Uri.parse('http://192.168.129.4:3000/auth/activate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );
      print("${resp.body}");
      if (resp.statusCode == 200) {
        // parse the response to check if code is valid
        final Map<String, dynamic> data = json.decode(resp.body);
        String token = data['token'];
        final isValid = resp.body.contains(
          '"token":',
        ); // simplistic check — adapt to your API
        if (isValid) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => QuizScreen(token: token, langCode: langCode),
            ),
          );
          return;
        } else {
          setState(() {
            _errorMessage = 'Invalid code';
          });
        }
      } else {
        setState(() {
          final isValid = resp.body.contains('"message":');
          String message = 'errorCodeMessage'.tr();
          if (isValid) {
            message = 'errorCodeMessage'.tr();
          }
          _errorMessage = 'Server error: $message';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine current language code from context
    String langCode = Localizations.localeOf(context).languageCode;
    // optional: normalize to lowercase
    langCode = langCode.toLowerCase();
    return Scaffold(
      appBar: AppBar(
        title: Text('accessCode').tr(),
        backgroundColor: Constants.primary,
        foregroundColor: Constants.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(
                  color: Constants.primary, // <-- Change text color here
                ),
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Code',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.primary, width: 2),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "codeValidation".tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primary, // Button color
                  foregroundColor: Constants.secondary, // Text/icon color
                ),
                onPressed: _loading
                    ? null
                    : () {
                        _validateCode(langCode);
                      },
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('submit').tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
