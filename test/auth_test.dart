import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

void main() {}

class NotInitializeException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isIntialize = false;

  bool get isIntialize => _isIntialize;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isIntialize) throw NotInitializeException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isIntialize = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isIntialize) throw NotInitializeException();
    if (email == "adi@gmail.com") throw UserNotFoundAuthExceptions();
    if (password == "foobar") throw WrongPasswordAuthExceptions();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isIntialize) throw NotInitializeException();
    if (_user == null) throw UserNotFoundAuthExceptions();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isIntialize) throw NotInitializeException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthExceptions();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
