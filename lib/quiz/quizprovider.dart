import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../dao/quizoption.dart';

class UserAnswer {
  final QuizQuestion question;
  final int? selectedOption; // null = time‑out / skipped
  UserAnswer({required this.question, required this.selectedOption});
}

class QuizProvider with ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;

  List<UserAnswer> userAnswers = [];

  double totalScore = 0;
  int correctAnswersCount = 0;
  int wrongAnswersCount = 0;

  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  QuizQuestion get currentQuestion => _questions[_currentIndex];

  Future<void> fetchQuestions(String token, String lang) async {
    final uri = Uri.http(
      'localhost:3000', // authority (host + optional port)
      '/quiz/liman', // path (API endpoint)
      {'lang': lang}, // query parameters
    );
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      _questions = data.map((q) => QuizQuestion.fromJson(q)).toList();
      _currentIndex = 0;
      userAnswers = [];
      totalScore = 0;
      correctAnswersCount = 0;
      wrongAnswersCount = 0;
      notifyListeners();
    } else {
      throw Exception('questionsNotLoading'.tr());
    }
  }

  int getPoints(String level) {
    switch (level.toLowerCase()) {
      default:
        return 1;
    }
  }

  double getNegativePoints(String level) {
    switch (level.toLowerCase()) {
      case 'hard':
        return 5;
      default:
        return 1;
    }
  }

  /// Correct signature: only selectedOption is required named param
  void answerQuestion({required int? selectedOption}) {
    final q = _questions[_currentIndex];

    userAnswers.add(UserAnswer(question: q, selectedOption: selectedOption));
    print("Selected -->${selectedOption}");
    print("correctOption -->${q.correctOption}");
    print("question -->${q.question}");
    if (selectedOption != null && selectedOption == q.correctOption) {
      correctAnswersCount++;
      totalScore += getPoints(q.level);
    } else {
      wrongAnswersCount++;
      totalScore -= getNegativePoints(q.level);
    }

    notifyListeners();
  }

  bool nextQuestionProvider() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  List<UserAnswer> get wrongAnswers {
    return userAnswers
        .where(
          (ua) =>
              ua.selectedOption == null ||
              ua.selectedOption != ua.question.correctOption,
        )
        .toList();
  }

  void resetQuiz() {
    _currentIndex = 0;
    userAnswers = [];
    totalScore = 0;
    correctAnswersCount = 0;
    wrongAnswersCount = 0;
    notifyListeners();
  }
}
