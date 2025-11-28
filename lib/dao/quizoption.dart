class QuizOption {
  final Map<String, String> text;

  QuizOption({required this.text});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      text: {
        'en': json['en']?.toString() ?? "",
        'fr': json['fr']?.toString() ?? "",
        'nl': json['nl']?.toString() ?? "",
      },
    );
  }

  bool get isEmpty => text.values.every((v) => v.isEmpty);
}

class QuizQuestion {
  final int id;
  final String level;
  final String question;
  final List<QuizOption> options;
  final int correctOption;
  final List<Map<String, String>> explanation;
  final String? imagePath;
  final String? imageBase64;

  QuizQuestion({
    required this.id,
    required this.level,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.explanation,
    this.imagePath,
    this.imageBase64,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? 0,
      level: json['level'] ?? '',
      question: json['question'] ?? '',
      options: ((json['options'] as List?) ?? [])
          .map((opt) => QuizOption.fromJson(opt))
          .where((opt) => !opt.isEmpty)
          .toList(),
      correctOption: json['correct_option'] ?? 0,

      explanation: (json['explanation'] as List? ?? [])
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),

      imagePath: json['image_path']?.toString(),
      imageBase64: json['image_base64']?.toString(),
    );
  }
}
