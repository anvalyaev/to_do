import '../database.dart';

class AccountData {
  String id = "";
  int passCode = -1;
}

abstract class AccountRepository {
  void save(AccountData accountData);
  void remove(AccountData accountData);
  Future<AccountData> get();
}
final String accountKey = 'account';
final String idKey = 'id_account';
final String passCodeKey = 'pass_code';

class SembastAccountRepository implements AccountRepository {
  SembastDataBase _database;
  SembastAccountRepository(this._database);
  void save(AccountData accountData) async {
    var newAccount = {idKey: accountData.id, passCodeKey: accountData.passCode};
    Map oldAccount = await _database.db.get(accountKey) as Map;
    if (oldAccount == null) {
      await _database.db.put(accountKey, newAccount);
    } else {
      await _database.db.update(accountKey, newAccount);
    }
  }

  void remove(AccountData accountData) async {
    Map account = await _database.db.get(accountKey) as Map;
    if (account != null) {
      await _database.db.delete(accountKey);
    }
  }

  Future<AccountData> get() async {
    AccountData res = AccountData();
    Map account = await _database.db.get(accountKey) as Map;
    if(account != null){
      res.id = account[idKey];
      res.passCode = account[passCodeKey];
    }
    return res;
  }
}
