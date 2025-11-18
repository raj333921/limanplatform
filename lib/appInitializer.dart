// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:limanplatform/components/homescreen.dart';

class AppInitializer {
  static Locale _locale = const Locale("fr");

  // Initialize cached settings
  static Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString("language_code");
    if (langCode != null) {
      _locale = Locale(langCode);
    }
  }

  // Change language and save in cache
  static Future<void> setLocale(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("language_code", languageCode);
    _locale = Locale(languageCode);
  }

  // Build your app
  static Widget buildApp() {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('te')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomeScreen(),
    );
  }
}
