import '../../models/user.dart';

enum Status { Uninitialized, Authenticated, Unauthenticated, OpenSourceUser }

abstract class IAuth {
  Future<String> signUp(String email, String password);
  Future login(String email, String password);
  Future<void> signOut();
  Status getStatus();
  User getUser();
}
