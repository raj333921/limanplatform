import 'package:flutter/material.dart';

class Constants {
  static const primary = Color(0xFF0173D3);
  static const secondary = Colors.white;
  static const background = Colors.white;
  static const externallogin = "https://planrijles.nl/scripts/login";
  static final List<Map<String, dynamic>> items = [
    {'title': 'introduction', 'icon': Icons.info, 'color': primary},
    {'title': 'booking', 'icon': Icons.book_online, 'color': primary},
    {'title': 'registration', 'icon': Icons.person_add, 'color': primary},
    {'title': 'registration', 'icon': Icons.person_add, 'color': primary},
    {'title': 'faq', 'icon': Icons.help, 'color': primary},
    {'title': 'videos', 'icon': Icons.video_library, 'color': primary},
    {'title': 'contact_us', 'icon': Icons.call, 'color': primary},
  ];

  static const List<Map<String, String>> faqs = [
    {"question": 'question1', "answer": "answer1"},
    {"question": "question2", "answer": "answer2"},
    {"question": "question3", "answer": "answer3"},
    {"question": "question4", "answer": "answer4"},
  ];
}
