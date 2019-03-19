import 'action_base.dart';
import '../accessor.dart';

class SetLocalization extends ActionBase{
  SetLocalization(this._localizationCode);
  @override
  void doAction(IAccessor accessor, void onCompleate(ActionBase result)){
    IDatabase database = accessor.database;
    // storage.executeCommand(StorageCommand.SetLocalization(_localizationCode));
  }
  String _localizationCode;
}