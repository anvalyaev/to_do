import 'dart:async';

import 'package:flutter/material.dart';
import 'apptranslations.dart';
import 'apptranslator.dart';

class AppTranslationsDelegate extends LocalizationsDelegate<Tr> {
  final Locale newLocale;

  const AppTranslationsDelegate({this.newLocale});
  @override
  bool isSupported(Locale locale) {
    return apptranslator.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<Tr> load(Locale locale) {
    return Tr.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Tr> old) {
    AppTranslationsDelegate tr = old as AppTranslationsDelegate;
    return (newLocale != tr.newLocale);
  }
  
}