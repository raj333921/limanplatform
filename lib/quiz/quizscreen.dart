import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:limanplatform/quiz/wronganswersscreen.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../dao/quizoption.dart';
import '../quiz/quizprovider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int timeLeft = Constants.questiontimer;
  double progress = 1.0;
  Timer? timer;
  Uint8List? questionImage;
  int score = 0;

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.fetchQuestions().then((_) {
      loadQuestionImage(quizProvider.questions[currentQuestionIndex]);
      startTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Decode base64 image once per question
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
            handleAnswer(null); // time up, treat as wrong
          }
        });
      }
    });
  }

  void handleAnswer(int? selectedIndex) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final question = quizProvider.questions[currentQuestionIndex];

    // Scoring logic with negative marking
    if (selectedIndex != null) {
      if (selectedIndex == question.correctOption) {
        score += question.level.toLowerCase() == "easy" ? 5 : 1;
      } else {
        score -= 1; // negative marking for wrong
      }
    }

    nextQuestion();
  }

  void nextQuestion() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    if (currentQuestionIndex < quizProvider.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      startTimer(); // restart timer for next question
    } else {
      timer?.cancel();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => WrongAnswersScreen()));
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
                // Circular Timer
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 35,
                        backgroundColor: Constants.background,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.pink,
                        ),
                      ),
                      Text(
                        "$timeLeft s",
                        style: const TextStyle(
                          color: Constants.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Question Image
                if (questionImage != null)
                  Center(
                    child: Image.memory(
                      questionImage!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),

                // Points display for hard questions
                Text(
                  getPointsText(question.level),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 8),

                // Question text
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Options
                Column(
                  children: question.options
                      .where(
                        (opt) =>
                            opt.text.values.any((v) => v.trim().isNotEmpty),
                      )
                      .map((opt) {
                        final index = question.options.indexOf(opt);
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
                              opt.text['en'] ?? "",
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
