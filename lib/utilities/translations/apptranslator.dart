import 'dart:ui';

class AppTranslator {

  static final AppTranslator _application = AppTranslator._internal();

  factory AppTranslator() {
    return _application;
  }

  AppTranslator._internal();
  
  List<String> get supportedLanguages => supportedLanguagesMap.values.toList();

  List<String> get supportedLanguagesCodes => supportedLanguagesMap.keys.toList();

  String languageName(String languageCode){
    return supportedLanguagesMap[languageCode];
  }

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
  Map<String, String> supportedLanguagesMap = {
    "en":'English',
    'ru':'Русский'
  };
}

AppTranslator apptranslator = AppTranslator();

typedef void LocaleChangeCallback(Locale locale);