class AppConfig {
  // Current selected language code
  static String languageCode = 'fr';

  // Base URL based on language
  static String get baseUrl {
    switch (languageCode) {
      case 'nl':
        return "https://y-liman.com/";
      case 'en':
        return "https://y-liman.com/en/";
      case 'fr':
      default:
        return "https://y-liman.com/fr/";
    }
  }
}
