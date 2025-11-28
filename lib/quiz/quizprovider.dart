import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../dao/quizoption.dart';

class UserAnswer {
  final QuizQuestion question;
  final int? selectedOption; // null if no answer (timeout or skipped)
  UserAnswer({required this.question, required this.selectedOption});
}

class QuizProvider with ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;

  // Record of what user answered for each question
  List<UserAnswer> userAnswers = [];

  String _language = 'en';

  // Scoring & statistics
  double totalScore = 0;
  int correctAnswersCount = 0;
  int wrongAnswersCount = 0;

  // Getters
  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  QuizQuestion get currentQuestion => _questions[_currentIndex];
  String get language => _language;

  // Wrong answers for review
  List<UserAnswer> get wrongAnswers {
    return userAnswers.where((ua) {
      return ua.selectedOption == null ||
          ua.selectedOption != ua.question.correctOption;
    }).toList();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  // Fetch questions from backend (or elsewhere)
  Future<void> fetchQuestions() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/quiz/quiz'),
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      _questions = data.map((q) => QuizQuestion.fromJson(q)).toList();
      // Reset previous quiz state
      _currentIndex = 0;
      userAnswers = [];
      totalScore = 0;
      correctAnswersCount = 0;
      wrongAnswersCount = 0;
      notifyListeners();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  /// Move to next question (or end). Returns false if no more questions.
  bool nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
      return true;
    }
    return false;
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
