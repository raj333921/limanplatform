import 'quizoption.dart';

class QuizQuestion {
  final int id;
  final String level;
  final String question;
  final List<QuizOption> options;
  final int correctOption;
  final List<Map<String, String>> explanation;
  final String imagePath;
  final String imageBase64;

  QuizQuestion({
    required this.id,
    required this.level,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.explanation,
    required this.imagePath,
    required this.imageBase64,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? 0,
      level: json['level'] ?? '',
      question: json['question'] ?? '',

      // OPTIONS LIST
      options: (json['options'] as List? ?? [])
          .map((opt) => QuizOption.fromJson(opt))
          .toList(),

      correctOption: json['correct_option'] ?? 0,

      // 🔥 FIXED EXPLANATION — THIS WAS THE CRASH
      explanation: (json['explanation'] as List? ?? [])
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),

      imagePath: json['image_path'] ?? '',
      imageBase64: json['image_base64'] ?? '',
    );
  }
}
