import 'package:flutter/material.dart';

class Constants {
  static const List<Map<String, dynamic>> items = [
    {
      "icon": Icons.description, // Booking icon
      "title": "Introduction",
      "color": Colors.blue,
    },
    {
      "icon": Icons.app_registration, // Booking icon
      "title": "Registration",
      "color": Colors.blue,
    },
    {
      "icon": Icons.book_online, // Booking icon
      "title": "Booking",
      "color": Colors.blue,
    },
    {
      "icon": Icons.question_answer, // FAQ icon
      "title": "FAQ",
      "color": Colors.blue,
    },
    {
      "icon": Icons.play_circle_fill, // Videos icon
      "title": "Videos",
      "color": Colors.blue,
    },
    {
      "icon": Icons.contact_emergency, // Videos icon
      "title": "Contact Us",
      "color": Colors.blue,
    },
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
