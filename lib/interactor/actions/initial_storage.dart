import 'action_base.dart';
import '../accessor.dart';

class InitialStorage extends ActionBase{
  InitialStorage(this._localPath);

  @override
  void doAction(Accessor accessor, void onCompleate(ActionBase result)){
    IDatabase database = accessor.database;
    database.initStorage(_localPath, (){
      accessor.initialize();
      onCompleate(this);
    });
  }
  String _localPath;
}