import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utilities/translations/apptranslationdelegate.dart';
import 'utilities/translations/apptranslator.dart';
import 'views/index.dart' as pages;
import 'presenters/index.dart' as presenters;
import 'presenters/presenter_provider.dart';
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

  Map<String, Widget> _routesCache = {};

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
      home: PresenterProvider<presenters.Initial>(
        child: pages.Initial(),
        presenter: presenters.Initial(),
        route: "",
        onDispose: (String routeName) {},
      ),
      onGenerateRoute: (RouteSettings settings) =>
          MaterialPageRoute(builder: (BuildContext context) {
            print("ROUTE: ${settings.name}");

            Widget res = _routesCache[settings.name];
            if ((res != null)) {
              return res;
            }
            switch (settings.name) {
              case '/Authorization':
                res = pages.Authorization();
                break;
              case '/Main':
                res = pages.Main();
                break;
              case '/Initial':
                res = PresenterProvider<presenters.Initial>(
                  child: pages.Initial(),
                  presenter: presenters.Initial(),
                  route: settings.name,
                  onDispose: (String routeName) {
                    _routesCache.remove(routeName);
                  },
                );
                break;
              case '/Main/ToDoList':
                res = PresenterProvider<presenters.ToDoList>(
                  child: pages.ToDoList(),
                  presenter: presenters.ToDoList(),
                  route: settings.name,
                  onDispose: (String routeName) {
                    _routesCache.remove(routeName);
                  },
                );
                break;
              case '/Main/ToDoList/ToDoEdit':
                res = PresenterProvider<presenters.ToDoEdit>(
                  child: pages.ToDoEdit(),
                  presenter: presenters.ToDoEdit.edit(settings.arguments),
                  route: settings.name,
                  onDispose: (String routeName) {
                    _routesCache.remove(routeName);
                  },
                );
                break;
              case '/Main/ToDoList/ToDoCreate':
                res = PresenterProvider<presenters.ToDoEdit>(
                  child: pages.ToDoEdit(),
                  presenter: presenters.ToDoEdit(),
                  route: settings.name,
                  onDispose: (String routeName) {
                    _routesCache.remove(routeName);
                  },
                );
                break;
              default:
                return res = pages.Dummy(settings.name);
                break;
            }
            _routesCache[settings.name] = res;
            return res;
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
