import 'dart:convert';

import 'package:prism/core/errors/exceptions/cache_exception.dart';
import 'package:prism/core/util/constants/strings.dart';
import 'package:prism/features/account/data/models/account/main/personal_account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonalAccountLocalDataSource {
  Future<void> storeAccount(PersonalAccountModel account);
  Future<PersonalAccountModel?> getAccount();
  Future<void> clearAccount();
}

class PersonalAccountLocalDataSourceImpl
    implements PersonalAccountLocalDataSource {
  final SharedPreferences prefs;

  PersonalAccountLocalDataSourceImpl({required this.prefs});

  @override
  Future<PersonalAccountModel?> getAccount() async {
    try {
      final jsonString = prefs.getString(STORE_ACCOUNT_KEY);
      if (jsonString == null) return null;

      return PersonalAccountModel.fromJson(json.decode(jsonString));
    } catch (e) {
      throw CacheException('Failed to load account: ${e.toString()}');
    }
  }

  @override
  Future<void> storeAccount(PersonalAccountModel account) async {
    try {
      await prefs.setString(STORE_ACCOUNT_KEY, json.encode(account.toJson()));
    } catch (e) {
      throw CacheException('Failed to store account: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAccount() async {
    try {
      await prefs.remove(STORE_ACCOUNT_KEY);
    } catch (e) {
      throw CacheException('Failed to clear account: ${e.toString()}');
    }
  }
}
