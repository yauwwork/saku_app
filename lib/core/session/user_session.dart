import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserSession {
  UserSession._();

  static const _prefsKey = 'current_user';
  static UserModel? currentUser;

  static bool get isLoggedIn => currentUser != null;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      currentUser = UserModel.fromJson(jsonMap);
    }
  }

  static Future<void> save(UserModel user) async {
    currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(user.toJson()));
  }

  static Future<void> clear() async {
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
