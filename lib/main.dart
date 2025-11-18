import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:limanplatform/components/dailogue.dart';
import 'package:limanplatform/components/faq.dart';
import 'package:limanplatform/components/webview_page.dart';
import 'package:limanplatform/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('nl'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('nl'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 REQUIRED FOR LOCALIZATION
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // --- HEADER ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/logo.png', height: 50),

                    // 🌍 LANGUAGE SELECTOR
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.language,
                        size: 28,
                        color: Colors.blue,
                      ),
                      onSelected: (value) async {
                        // 🔥 CHANGE LANGUAGE
                        await context.setLocale(Locale(value));
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'en', child: Text("English")),
                        PopupMenuItem(value: 'nl', child: Text("Dutch")),
                        PopupMenuItem(value: 'fr', child: Text("French")),
                      ],
                    ),
                  ],
                ),
              ),

              // --- GRID ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    itemCount: Constants.items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                builder: (context) => const FAQPage(),
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
                                radius: 32,
                                backgroundColor:
                                    Constants.items[index]['color'],
                                child: Icon(
                                  Constants.items[index]['icon'],
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Constants.items[index]['title'].toString().tr(),
                                style: const TextStyle(
                                  fontSize: 16,
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
