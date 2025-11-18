import 'package:flutter/material.dart';
import 'package:limanplatform/appInitializer.dart';
import 'package:limanplatform/components/dailogue.dart';
import 'package:limanplatform/components/faq.dart';
import 'package:limanplatform/components/webview_page.dart';
import 'package:limanplatform/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.init();
  runApp(AppInitializer.buildApp());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // --- HEADER ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo.png', // your logo path
                      height: 50,
                    ),
                    SizedBox(width: 27),
                  ],
                ),
              ),

              // --- GRID ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    itemCount: Constants.items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          String key = Constants.items[index]['title']
                              .toLowerCase();
                          if (key == "booking") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: "https://y-liman.com/en/inloggen/",
                                  name: key,
                                ),
                              ),
                            );
                          } else if (key == "registration") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: "https://y-liman.com/en/registreren/",
                                  name: key,
                                ),
                              ),
                            );
                          } else if (key == "faq") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FAQPage(),
                              ),
                            );
                          } else if (key == "videos") {
                            DialogHelper.showSuccess(context);
                          } else if (key == "contact us") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: "https://y-liman.com/en/contact/",
                                  name: key,
                                ),
                              ),
                            );
                          } else if (key == "introduction") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: "https://y-liman.com/en/rijbewijsb/",
                                  name: key,
                                ),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Constants.items[index]['color'].withOpacity(
                              0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor:
                                    Constants.items[index]['color'],
                                child: Icon(
                                  Constants.items[index]['icon'],
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                Constants.items[index]['title'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
