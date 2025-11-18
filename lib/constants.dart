import 'package:flutter/material.dart';

class Constants {
  static final List<Map<String, dynamic>> items = [
    {'title': 'booking', 'icon': Icons.book_online, 'color': Colors.blue},
    {'title': 'registration', 'icon': Icons.person_add, 'color': Colors.blue},
    {'title': 'faq', 'icon': Icons.help, 'color': Colors.blue},
    {'title': 'videos', 'icon': Icons.video_library, 'color': Colors.blue},
    {'title': 'contact_us', 'icon': Icons.call, 'color': Colors.blue},
    {'title': 'introduction', 'icon': Icons.info, 'color': Colors.blue},
  ];

  static const List<Map<String, String>> faqs = [
    {
      "question": "How do I book a service?",
      "answer":
          "You can book a service by clicking the booking icon and filling the form.",
    },
    {
      "question": "How can I contact support?",
      "answer":
          "Contact support via the FAQ section or email support@example.com.",
    },
    {
      "question": "Where can I watch videos?",
      "answer": "Videos are available under the Videos section in the app.",
    },
  ];
}
