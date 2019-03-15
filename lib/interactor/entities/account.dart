import 'dart:async';
import 'entity_base.dart';
import '../data_stores/database/database.dart';
import '../data_stores/database/repositories/account.dart' as repository;

enum AccountStatus {not_authorized, authorized}

abstract class IAccount extends EntityBase {
  IAccount(StreamController<EntityBase> controller) : super(controller);
  AccountStatus get status;
  int get passCode;
  void changeStatus(AccountStatus status);
}

class Account extends IAccount {
  AccountStatus _status = AccountStatus.not_authorized;
  int _passCode = -1;
  SembastDataBase _database;
  bool _busy;

  Account(StreamController<EntityBase> controller, this._database)
      : super(controller);
  @override
  void initialize() {
    _status = AccountStatus.not_authorized;
    reload();
  }
  @override
  void reload() {
    _busy = true;
    modelChanged();
    repository.SembastAccountRepository repo = new repository.SembastAccountRepository(_database);
    repo.get().then((repository.AccountData accountData){
      _busy = false;
      _passCode = accountData.passCode;
    });
  }

  AccountStatus get status => _status;
  bool get busy => _busy;
  int get passCode => _passCode;

  void changeStatus(AccountStatus status){
    _status = status;
    modelChanged();
  }
  

}
