import 'dart:convert';
import 'package:realmo/core/errors/exceptions/preferences_exception.dart';
import 'package:realmo/core/util/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:realmo/features/preferences/data/models/preferences_model.dart';

abstract class PreferencesLocalDataSource {
  Future<void> storePreferences(PreferencesModel model);
  Future<PreferencesModel> loadPreferences();
}

class PreferencesLocalDataSourceImpl implements PreferencesLocalDataSource {
  @override
  Future<void> storePreferences(PreferencesModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> jsonMap = model.toJson();
    await prefs.setString(STORE_PREFERENCES_KEY, json.encode(jsonMap));
  }

  @override
  Future<PreferencesModel> loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(STORE_PREFERENCES_KEY);

    if (jsonString == null) {
      throw PreferencesException(EMPTY_PREFRENCES_MSG);
    }

    return PreferencesModel.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );
  }
}
