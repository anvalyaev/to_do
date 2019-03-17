import 'dart:async';

import 'package:flutter/material.dart';
import 'apptranslations.dart';
import 'apptranslator.dart';

class AppTranslationsDelegate extends LocalizationsDelegate<Translation> {
  final Locale newLocale;

  const AppTranslationsDelegate({this.newLocale});
  @override
  bool isSupported(Locale locale) {
    return apptranslator.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<Translation> load(Locale locale) {
    return Translation.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Translation> old) {
    AppTranslationsDelegate tr = old as AppTranslationsDelegate;
    return (newLocale != tr.newLocale);
  }
  
}