import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:limanplatform/quiz/codecheckscreen.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:limanplatform/constants.dart';
import '../quiz/quizprovider.dart';

class WrongAnswersScreen extends StatefulWidget {
  const WrongAnswersScreen({super.key});
  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // We'll start confetti later if passed
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final wrong = quizProvider.wrongAnswers;
    final passed = quizProvider.totalScore > 41;

    // Determine current language code from context
    String langCode = Localizations.localeOf(context).languageCode;
    // optional: normalize to lowercase
    langCode = langCode.toLowerCase();

    // If passed, play confetti once
    if (passed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => CodeCheckScreen()),
            );
          },
        ),
        title: Text("finalHead".tr()),
        backgroundColor: Constants.primary,
        foregroundColor: Constants.background,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Score & result
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Score: ${quizProvider.totalScore.toStringAsFixed(0)}  |  "
                  "Correct: ${quizProvider.correctAnswersCount}  |  "
                  "Wrong: ${quizProvider.wrongAnswersCount}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  passed ? 'passed'.tr() : "failed".tr(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: passed ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                passed ? "passedMessage".tr() : "failedMessage".tr(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: wrong.isEmpty
                    ? const Center(
                        child: Text(
                          "Mind‑blowing trivia!",
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
                          if (q.imageBase64 != null &&
                              q.imageBase64!.isNotEmpty) {
                            final base64String = q.imageBase64!.split(',').last;
                            try {
                              imageBytes = base64Decode(base64String);
                            } catch (_) {
                              imageBytes = null;
                            }
                          }

                          return Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Constants.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            key: ValueKey(q.id),
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "question".tr(),
                                    style: const TextStyle(
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
                                  Text(
                                    "answer".tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ua.selectedOption != null &&
                                            ua.question.options.length >
                                                ua.selectedOption!
                                        ? q
                                                  .options[ua.selectedOption!]
                                                  .text[langCode] ??
                                              ""
                                        : "(No answer)",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "correctAnswer".tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    (q.options.isNotEmpty &&
                                            q.correctOption < q.options.length)
                                        ? q
                                                  .options[q.correctOption]
                                                  .text[langCode] ??
                                              ""
                                        : "",
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "explanation".tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    q.explanation.isNotEmpty
                                        ? (q.explanation.first[langCode] ?? "")
                                        : "",
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          // Confetti overlay
          if (passed)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 50,
                emissionFrequency: 0.05,
                maxBlastForce: 20,
                minBlastForce: 5,
                gravity: 0.1,
              ),
            ),
        ],
      ),
    );
  }
}
