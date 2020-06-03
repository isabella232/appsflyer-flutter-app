import 'package:ezshop/core/models/user.dart';
import 'package:flutter/widgets.dart';

import '../app_provider.dart';
import './auth_interface.dart';
import './auth_firebase.dart';
import './auth_local.dart';

class Auth extends IAuth with ChangeNotifier {
  IAuth _instance;
  AppMode appMode;

  Status get authStatus {
    return _instance.getStatus();
  }

  set instance(AppMode mode) {
    appMode = mode;
    if (mode == AppMode.Full) {
      _instance = AuthFirebase(notifyListeners);
    } else {
      _instance = AuthLocal(notifyListeners);
    }
  }

  Future<String> signUp(String email, String password) async {
    String uid = await _instance.signUp(email, password);
    return uid;
  }

  Future<void> login(String email, String password) async {
    await _instance.login(email, password);
  }

  Future<void> signOut() async {
    _instance.signOut();
    notifyListeners();
  }

  @override
  Status getStatus() {
    return _instance.getStatus();
  }

  @override
  IAuth getInstance() {
    return _instance;
  }

  @override
  User getUser() {
    return _instance.getUser();
  }

  @override
  Future<String> loginWithFacebook() async {
    return _instance.loginWithFacebook();
  }

  Future loginWithGoogle() {
    return _instance.loginWithGoogle();
  }
}
