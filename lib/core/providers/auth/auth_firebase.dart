import 'dart:convert';

import 'package:ezshop/core/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import './auth_interface.dart';

class AuthFirebase extends IAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _user;
  Status _status = Status.Uninitialized;
  final Function notifyListeners;
  static AuthFirebase _instance;
  GoogleSignIn googleSignIn;
  FacebookLogin facebookLogin;

  AuthFirebase(this.notifyListeners) {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  @override
  Future login(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
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

    if (googleSignIn != null) {
      googleSignIn.signOut();
    }

    if (facebookLogin != null) {
      facebookLogin.logOut();
    }
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

  @override
  Future<String> loginWithFacebook() async {
    facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        final accessToken = facebookLoginResult.accessToken.token;
        final facebookAuthCredential =
            FacebookAuthProvider.getCredential(accessToken: accessToken);

        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=$accessToken');

        var profile = json.decode(graphResponse.body);

        try {
          await _firebaseAuth
              .signInWithCredential(facebookAuthCredential)
              .catchError((err) {
            if (err
                .toString()
                .contains("ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL")) {
              throw "The email address ${profile['email']} already exist in the system. Please connect with the account that uses this email";
            }
          });
        } catch (e) {
          return e.toString();
        }
        break;
    }

    return null;
  }

  @override
  Future loginWithGoogle() async {
    googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    _firebaseAuth.signInWithCredential(credential);
  }
}
