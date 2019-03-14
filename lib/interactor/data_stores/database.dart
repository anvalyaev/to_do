import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

abstract class IDatabase {
  void initStorage(String localPath, void onInitiated());
  // void executeCommand(StorageCommand command);
}

class SembastDataBase extends IDatabase {

  @override
  void initStorage(String localPath, void onInitiated()){
    _localPath = localPath;
    String dbPath = '$_localPath/store.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    
    dbFactory.openDatabase(dbPath).then((Database newDb){
      _db = newDb;
      onInitiated();
    });
  }

  // @override
  // void executeCommand(StorageCommand command){
  //   command.execute(_db);
  // }
  String _localPath = "";
  Database _db;
}
