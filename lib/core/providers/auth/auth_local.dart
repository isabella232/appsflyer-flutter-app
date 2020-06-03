import 'package:ezshop/core/models/user.dart';

import './auth_interface.dart';

class AuthLocal extends IAuth {
  final Function notifyListeners;
  static AuthLocal _instance;
  User _user;

  AuthLocal(this.notifyListeners) {
    //build annonymous user placeholder
    _user = buildAnonymousUser();
  }

  @override
  Future login(String email, String password) {}

  @override
  Future<void> signOut() {}

  @override
  Future<String> signUp(String email, String password) {}

  @override
  Status getStatus() {
    return Status.OpenSourceUser;
  }

  static IAuth getInstance(Function notifyListener) {
    if (_instance == null) {
      _instance = AuthLocal(notifyListener);
    }
    return _instance;
  }

  @override
  getUser() {
    return _user;
  }

  User buildAnonymousUser() {
    return User("1", "anonymous@ezshop.com");
  }

  @override
  Future<String> loginWithFacebook() {
    return null;
  }

  @override
  Future loginWithGoogle() {
    return null;
  }
}
