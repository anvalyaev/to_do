import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utilities/translations/apptranslationdelegate.dart';
import 'utilities/translations/apptranslator.dart';
import 'pages/index.dart' as pages;
import 'bloc_presenters/index.dart' as bloc_presenters;
import 'bloc_presenters/bloc_presenter_provider.dart';
import 'application_theme.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    apptranslator.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: true,
      title: 'TODO',
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: apptranslator.supportedLocales(),
      theme: ApplicationThemeData.themeData(),
      home: BlocPresenterProvider<bloc_presenters.Initial>(
        child: pages.Initial(),
        bloc: bloc_presenters.Initial(),
      ),
      onGenerateRoute: (RouteSettings settings) =>
          MaterialPageRoute(builder: (BuildContext context) {
            switch (settings.name) {
              case '/Authorization':
                return pages.Authorization();
                break;
              case '/Main':
                return pages.Main();
                break;
              case '/Initial':
                return BlocPresenterProvider<bloc_presenters.Initial>(
                  child: pages.Initial(),
                  bloc: bloc_presenters.Initial(),
                );
                break;
              case '/Main/ToDoList':
                return pages.ToDoList();
                break;
              case '/Main/ToDoList/ToDoEdit':
                return BlocPresenterProvider<bloc_presenters.ToDoEdit>(
                  child: pages.ToDoEdit(),
                  bloc: bloc_presenters.ToDoEdit.edit(settings.arguments),
                );
                break;
              case '/Main/ToDoList/ToDoCreate':
                return BlocPresenterProvider<bloc_presenters.ToDoEdit>(
                  child: pages.ToDoEdit(),
                  bloc: bloc_presenters.ToDoEdit(),
                );
                break;
              default:
                return pages.Dummy(settings.name);
                break;
            }
          }),
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  AppTranslationsDelegate _newLocaleDelegate;
}
