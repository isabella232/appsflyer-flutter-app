import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status { Uninitialized, Authenticated, Unauthenticated }

class Auth with ChangeNotifier {
  FirebaseUser _user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Status _status = Status.Uninitialized;

  Status get status => _status;
  FirebaseUser get user => _user;

  Auth.instance() {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    notifyListeners();
    return user.uid;
  }

  Future login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    _status = Status.Unauthenticated;
    return Future.delayed(Duration.zero);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    notifyListeners();
    return user;
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
