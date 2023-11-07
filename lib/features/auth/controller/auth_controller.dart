import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/utils.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(authAPI: ref.watch(authApiProvider)));

final userAccountProvider = FutureProvider(
    (ref) => ref.watch(authControllerProvider.notifier).getCurrentUser());

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);

  Future<User?> getCurrentUser() => _authAPI.getCurrentUser();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;

    var response = await _authAPI.signUp(email: email, password: password);

    state = false;
    response.fold((error) => showSnackBar(context, error.message),
        (user) => print(user.email));
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;

    var response = await _authAPI.login(email: email, password: password);

    state = false;
    response.fold((error) => showSnackBar(context, error.message),
        (user) => print(user.userId));
  }
}
