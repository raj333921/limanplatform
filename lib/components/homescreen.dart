import 'package:flutter/material.dart';
import 'package:limanplatform/appInitializer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Language Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                AppInitializer.setLocale("en");
                // Normally you'd rebuild MaterialApp or use a state management solution
              },
              child: const Text("English"),
            ),
            ElevatedButton(
              onPressed: () {
                AppInitializer.setLocale("hi");
              },
              child: const Text("Hindi"),
            ),
            ElevatedButton(
              onPressed: () {
                AppInitializer.setLocale("te");
              },
              child: const Text("Telugu"),
            ),
          ],
        ),
      ),
    );
  }
}
