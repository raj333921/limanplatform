import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:limanplatform/quiz/codecheckscreen.dart';
import 'package:limanplatform/quiz/wronganswersscreen.dart';
import '../constants.dart';
import '../dao/quizoption.dart';
import '../quiz/quizprovider.dart';

class QuizScreen extends StatefulWidget {
  final String token;
  final String langCode;
  const QuizScreen({Key? key, required this.token, required this.langCode})
    : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int timeLeft = Constants.questiontimer;
  double progress = 1.0;
  Timer? timer;
  Uint8List? questionImage;

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.fetchQuestions(widget.token, widget.langCode).then((_) {
      loadQuestionImage(quizProvider.questions[currentQuestionIndex]);
      startTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void loadQuestionImage(QuizQuestion question) {
    if (question.imageBase64 != null &&
        question.imageBase64!.isNotEmpty &&
        cleanBase64(question.imageBase64!).isNotEmpty) {
      questionImage = base64Decode(cleanBase64(question.imageBase64!));
    } else {
      questionImage = null;
    }
  }

  String cleanBase64(String? data) {
    if (data == null || data.isEmpty) return "";
    final parts = data.split(',');
    return parts.length > 1 ? parts[1] : data;
  }

  String getPointsText(String level) {
    switch (level.toLowerCase()) {
      case "hard":
        return "(5 Points)";
      default:
        return "";
    }
  }

  void startTimer() {
    timer?.cancel();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    loadQuestionImage(quizProvider.questions[currentQuestionIndex]);

    setState(() {
      timeLeft = Constants.questiontimer;
      progress = 1.0;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
            progress = timeLeft / Constants.questiontimer;
          } else {
            t.cancel();
            handleAnswer(null);
          }
        });
      }
    });
  }

  void handleAnswer(int? selectedIndex) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.answerQuestion(selectedOption: selectedIndex);
    nextQuestion();
  }

  void nextQuestion() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    if (currentQuestionIndex < quizProvider.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      quizProvider.nextQuestionProvider();
      startTimer();
    } else {
      timer?.cancel();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const WrongAnswersScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.questions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final question = quizProvider.questions[currentQuestionIndex];
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const CodeCheckScreen()),
                );
              },
            ),
            title: Text(
              "Question ${currentQuestionIndex + 1}/${quizProvider.questions.length}",
            ),
            backgroundColor: Constants.primary,
            foregroundColor: Constants.background,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Live score display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Score: ${quizProvider.totalScore.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Correct: ${quizProvider.correctAnswersCount}",
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    Text(
                      "Wrong: ${quizProvider.wrongAnswersCount}",
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Timer circle
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: Colors.red,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                      Text(
                        "$timeLeft s",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (questionImage != null)
                  Center(
                    child: Image.memory(
                      questionImage!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  getPointsText(question.level),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Options list using locale‑aware text
                Column(
                  children: question.options
                      .where(
                        (opt) =>
                            opt.text.values.any((v) => v.trim().isNotEmpty),
                      )
                      .map((opt) {
                        final index = question.options.indexOf(opt);
                        final label =
                            opt.text[widget.langCode] ??
                            ""; // fallback to English if missing
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: ElevatedButton(
                            onPressed: () => handleAnswer(index),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Constants.primary,
                              foregroundColor: Constants.background,
                            ),
                            child: Text(
                              label,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
