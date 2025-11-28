import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../quiz/quizprovider.dart';
import 'package:provider/provider.dart';

class WrongAnswersScreen extends StatelessWidget {
  const WrongAnswersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wrong = Provider.of<QuizProvider>(
      context,
      listen: false,
    ).wrongAnswers;

    return Scaffold(
      appBar: AppBar(title: const Text("Review Wrong Answers")),
      body: wrong.isEmpty
          ? const Center(
              child: Text(
                "No wrong answers — well done!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: wrong.length,
              itemBuilder: (context, index) {
                final ua = wrong[index];
                final q = ua.question;

                Uint8List? imageBytes;
                if (q.imageBase64 != null && q.imageBase64!.isNotEmpty) {
                  // If you store full data URI, strip prefix
                  final base64String = q.imageBase64!.split(',').last;
                  try {
                    imageBytes = base64Decode(base64String);
                  } catch (_) {
                    imageBytes = null;
                  }
                }

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Question:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(q.question),
                        const SizedBox(height: 8),
                        if (imageBytes != null)
                          Image.memory(
                            imageBytes,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 8),
                        const Text(
                          "Your answer:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ua.selectedOption != null
                              ? (q.options.length > ua.selectedOption!
                                    ? (q
                                              .options[ua.selectedOption!]
                                              .text['en'] ??
                                          "")
                                    : "(Invalid option)")
                              : "(No answer)",
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Correct answer:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (q.options.isNotEmpty &&
                                  q.correctOption < q.options.length)
                              ? (q.options[q.correctOption].text['en'] ?? "")
                              : "",
                          style: const TextStyle(color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Explanation:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          q.explanation.isNotEmpty
                              ? (q.explanation.first['en'] ?? "")
                              : "",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
