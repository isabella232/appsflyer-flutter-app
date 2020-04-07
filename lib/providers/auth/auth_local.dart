import './auth_interface.dart';
import '../../models/user.dart';

class AuthLocal extends IAuth {
  final Function notifyListeners;
  static AuthLocal _instance;
  User _user;

  AuthLocal(this.notifyListeners) {
    print('auth local constructor');
    //build annonymous user placeholder
    _user = buildAnonymousUser();
  }

  @override
  Future login(String email, String password) {
    print('called login in authLocal');
  }

  @override
  Future<void> signOut() {
    print('called signout in authLocal');
  }

  @override
  Future<String> signUp(String email, String password) {
    print('called signup in authLocal');
  }

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
}
