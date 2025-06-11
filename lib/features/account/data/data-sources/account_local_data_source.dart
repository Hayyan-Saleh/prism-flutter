import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';

abstract class AccountLocalDataSource {
  Future<void> storeAccount(AccountEntity account);
  Future<AccountEntity> getAccount();
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  @override
  Future<AccountEntity> getAccount() {
    //     @override
    // Future<void> storePreferences(PreferencesModel model) async {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   final Map<String, dynamic> jsonMap = model.toJson();
    //   await prefs.setString(STORE_PREFERENCES_KEY, json.encode(jsonMap));
    // }
    // TODO: implement getAccount
    throw UnimplementedError();
  }

  @override
  Future<void> storeAccount(AccountEntity account) {
    // TODO: implement storeAccount
    throw UnimplementedError();
  }
}
