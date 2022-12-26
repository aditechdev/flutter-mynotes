import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Mock Authentication",
    () {
      final provider = MockAuthProvider();

      test(
        "Should not be initialize to begin with",
        () {
          expect(provider.isIntialize, false);
        },
      );

      test(
        "Cannot log out, if not initialize",
        () {
          expect(
            provider.logOut(),
            throwsA(
              const TypeMatcher<NotInitializeException>(),
            ),
          );
        },
      );

      test(
        "Should be able to intialize",
        () async {
          await provider.initialize();

          expect(provider.isIntialize, true);
        },
      );
      test(
        "User should be null after initialization",
        () async {
          expect(provider.currentUser, null);
        },
      );

      test(
        "Should be able to initialize, in less than 2 sec",
        () async {
          await provider.initialize();
          expect(provider.isIntialize, true);
        },
        timeout: const Timeout(
          Duration(
            seconds: 2,
          ),
        ),
      );

      test("Create User to delegate login", () async {
        final badEmailUser = provider.createUser(
            email: "adi@gmail.com", password: "anyPassword");

        expect(badEmailUser,
            throwsA(const TypeMatcher<UserNotFoundAuthExceptions>()));

        final badPasswordUser =
            provider.createUser(email: "someone@gmail.com", password: "foobar");

        expect(badPasswordUser,
            throwsA(const TypeMatcher<WrongPasswordAuthExceptions>()));

        final user = await provider.createUser(
            email: "aditya@gmail.com", password: "123456");
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      });

      test("Login user should be verified ", () {
        provider.sendEmailVerification();

        final user = provider.currentUser;

        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      });

      test("Should be able to log out and log in", () async {
        await provider.logOut();

        await provider.logIn(email: "email", password: "password");

        final user = provider.currentUser;

        expect(user, isNotNull);
      });
    },
  );
}

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
