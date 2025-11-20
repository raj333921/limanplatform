import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({super.key});

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not open $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
          onPressed: () =>
              _openUrl("https://www.facebook.com/share/17RH4UbSD8/"),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.pink),
          onPressed: () => _openUrl("https://www.instagram.com/limanbelgium"),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
          onPressed: () => _openUrl("https://wa.me/3235001414"),
        ),
      ],
    );
  }
}
