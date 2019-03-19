import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../../../application_settings.dart';
import 'repositories/index.dart';

abstract class IDatabase {
  void initStorage(String localPath, void onInitiated());
  ToDoItemRepository get toDoItemRepository;
}

class SembastDataBase extends IDatabase {
  String _localPath = "";
  SembastToDoItemRepository _toDoItemRepository;
  ToDoItemRepository get toDoItemRepository => _toDoItemRepository;
  Database db;

  @override
  void initStorage(String localPath, void onInitiated()) {
    _localPath = localPath;
    String dbPath = '$_localPath${ApplicationSettings.database_file_name}';
    DatabaseFactory dbFactory = databaseFactoryIo;

    dbFactory.openDatabase(dbPath).then((Database newDb) {
      db = newDb;
      db.put(ApplicationSettings.database_version, 'version');
      _toDoItemRepository = new SembastToDoItemRepository(this);
      onInitiated();
    });
  }
}

class DatabaseDummy extends IDatabase{
  @override
  void initStorage(String localPath, void Function() onInitiated) {
    // TODO: implement initStorage
  }

  ToDoItemDummy _toDoItemRepository = new ToDoItemDummy();
  ToDoItemRepository get toDoItemRepository => _toDoItemRepository;

}


