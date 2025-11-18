import 'package:flutter/material.dart';

class Constants {
  static final List<Map<String, dynamic>> items = [
    {'title': 'introduction', 'icon': Icons.info, 'color': Colors.blue},
    {'title': 'booking', 'icon': Icons.book_online, 'color': Colors.blue},
    {'title': 'registration', 'icon': Icons.person_add, 'color': Colors.blue},
    {'title': 'faq', 'icon': Icons.help, 'color': Colors.blue},
    {'title': 'videos', 'icon': Icons.video_library, 'color': Colors.blue},
    {'title': 'contact_us', 'icon': Icons.call, 'color': Colors.blue},
  ];

  static const List<Map<String, String>> faqs = [
    {"question": 'question1', "answer": "answer1"},
    {"question": "question2", "answer": "answer2"},
    {"question": "question3", "answer": "answer3"},
    {"question": "question4", "answer": "answer4"},
  ];
}
