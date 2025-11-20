import 'package:flutter/material.dart';
import 'package:limanplatform/dao/videoitem.dart';

class Constants {
  static const primary = Color(0xFF0173D3);
  static const secondary = Colors.white;
  static const background = Colors.white;
  static const externallogin = "https://planrijles.nl/scripts/login";
  static final List<Map<String, dynamic>> items = [
    {'title': 'introduction', 'icon': Icons.info, 'color': primary},
    {'title': 'registration', 'icon': Icons.person_add, 'color': primary},
    {'title': 'booking', 'icon': Icons.book_online, 'color': primary},
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

  static const List<String> images = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
  ];

  static List<videoitem> videos = [
    videoitem(
      title: "video1",
      videoPath: "assets/videos/video1.mp4",
      thumbnail: "assets/thumbnails/video1.png",
    ),
    videoitem(
      title: "video2",
      videoPath: "assets/videos/video2.mp4",
      thumbnail: "assets/thumbnails/video1.png",
    ),
  ];
}
