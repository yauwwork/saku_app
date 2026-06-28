import '../models/user_model.dart';

class UserSession {
  UserSession._();

  static UserModel? currentUser;

  static bool get isLoggedIn => currentUser != null;

  static void clear() {
    currentUser = null;
  }
}
