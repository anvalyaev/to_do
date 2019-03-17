import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Translation {

  Translation(Locale locale) {
    this.locale = locale;
    _localisedValues = null;
  }

  static Translation of(BuildContext context) {
    return Localizations.of<Translation>(context, Translation);
  }

  static Future<Translation> load(Locale locale) async {
    Translation appTranslations = Translation(locale);
    String jsonContent =
    await rootBundle.loadString("assets/localizations/localization_${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    if(_localisedValues == null) return('');
    return _localisedValues[key] ?? "<$key>";
  }

  Locale locale;
  static Map<String, dynamic> _localisedValues;
}
