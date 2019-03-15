import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../../../application_settings.dart';

abstract class IDatabase {
  void initStorage(String localPath, void onInitiated());
}

class SembastDataBase extends IDatabase {
  String _localPath = "";
  Database db;

  @override
  void initStorage(String localPath, void onInitiated()) {
    _localPath = localPath;
    String dbPath = '$_localPath${ApplicationSettings.database_file_name}';
    DatabaseFactory dbFactory = databaseFactoryIo;

    dbFactory.openDatabase(dbPath).then((Database newDb) {
      db = newDb;
      db.put(ApplicationSettings.database_version, 'version');
      onInitiated();
    });
  }
}


