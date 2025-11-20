import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:limanplatform/components/appconfig.dart';
import 'package:limanplatform/components/corousel.dart';
import 'package:limanplatform/components/faq.dart';
import 'package:limanplatform/components/socialicons.dart';
import 'package:limanplatform/components/videopage.dart';
import 'package:limanplatform/components/webview_page.dart';
import 'package:limanplatform/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('nl'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr'),
      startLocale: Locale('fr'),
      child: const LimanPlatform(),
    ),
  );
}

class LimanPlatform extends StatelessWidget {
  const LimanPlatform({super.key});

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
                        color: Constants.primary,
                      ),
                      onSelected: (value) async {
                        // 🔥 CHANGE LANGUAGE
                        await context.setLocale(Locale(value));
                        AppConfig.languageCode = value; // set globally
                        print(AppConfig.languageCode);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'fr',
                          child: Text(
                            "French",
                            style: TextStyle(color: Constants.primary),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'nl',
                          child: Text(
                            "Dutch",
                            style: TextStyle(color: Constants.primary),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'en',
                          child: Text(
                            "English",
                            style: TextStyle(color: Constants.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: buildImageCarousel(Constants.images),
              ),
              // --- GRID ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    itemCount: Constants.items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
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
                            print("${AppConfig.baseUrl}/inloggen/");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: "${AppConfig.baseUrl}/inloggen/",
                                  name: key,
                                ),
                              ),
                            );
                          } else if (key == "registration") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: "${AppConfig.baseUrl}/registreren/",
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
                            //DialogHelper.showSuccess(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPage(),
                              ),
                            );
                          } else if (key == "contact_us") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: "${AppConfig.baseUrl}/contact/",
                                  name: key,
                                ),
                              ),
                            );
                          } else if (key == "introduction") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  url: "${AppConfig.baseUrl}/rijbewijsb/",
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
                                  color: Constants.background,
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
              const SocialIcons(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                color: Constants.primary,
                child: Text(
                  "© 2025 Liman Platform. All rights reserved.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Constants.background,
                    fontSize: 14,
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
