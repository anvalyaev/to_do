import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Tr {

  Tr(Locale locale) {
    this.locale = locale;
    _localisedValues = null;
  }

  static Tr of(BuildContext context) {
    return Localizations.of<Tr>(context, Tr);
  }

  static Future<Tr> load(Locale locale) async {
    Tr appTranslations = Tr(locale);
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
