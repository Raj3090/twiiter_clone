import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';

final authApiProvider = Provider((ref) {
  return AuthAPI(account: ref.watch(appWriteAccountProvider));
});

abstract class IAuthAPI {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });

  FutureEither<Session> login({
    required String email,
    required String password,
  });

  Future<User?> getCurrentUser();
}

class AuthAPI implements IAuthAPI {
  final Account _account;

  AuthAPI({required Account account}) : _account = account;

  @override
  FutureEither<User> signUp(
      {required String email, required String password}) async {
    try {
      final user = await _account.create(
          userId: ID.unique(), email: email, password: password);

      return right(user);
    } on AppwriteException catch (e, stackTrace) {
      if (kDebugMode) {
        print('signUp ${e.message}');
      }
      return left(Failure(e.message ?? 'something went wrong!', stackTrace));
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('signUp ${e.toString()}');
      }
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Session> login(
      {required String email, required String password}) async {
    try {
      final session =
          await _account.createEmailSession(email: email, password: password);

      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
      }
      return left(Failure(e.message ?? 'something went wrong!', stackTrace));
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
      }
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final user = await _account.get();

      return user;
    } on AppwriteException catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
