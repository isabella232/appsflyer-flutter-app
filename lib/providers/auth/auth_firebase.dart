import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user.dart';
import './auth_interface.dart';

class AuthFirebase extends IAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _user;
  Status _status = Status.Uninitialized;
  final Function notifyListeners;
  static AuthFirebase _instance;

  AuthFirebase(this.notifyListeners) {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  @override
  Future login(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user2 = result.user;
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    _status = Status.Unauthenticated;
    return Future.delayed(Duration.zero);
  }

  @override
  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    this.notifyListeners();
    return user.uid;
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = convertFirebaseUserToUser(firebaseUser);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  @override
  Status getStatus() {
    return _status;
  }

  static IAuth getInstance(Function notifyListener) {
    if (_instance == null) {
      _instance = AuthFirebase(notifyListener);
    }
    return _instance;
  }

  @override
  getUser() {
    return _user;
  }

  User convertFirebaseUserToUser(FirebaseUser user) {
    return User(user.uid, user.email);
  }
}
