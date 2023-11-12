import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authAPI: ref.watch(authApiProvider),
        userAPI: ref.watch(userApiProvider)));

final userAccountProvider = FutureProvider(
    (ref) => ref.watch(authControllerProvider.notifier).getCurrentUser());

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
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
        (user) async {
      final res2 = await _userAPI.saveUserData(UserModel(
          email: email,
          name: getNameFromEmail(email),
          bannerPic: '',
          profilePic: '',
          uid: '',
          bio: '',
          isTwitterBlue: false,
          followers: [],
          following: []));

      res2.fold((error) {
        showSnackBar(context, error.message);
      }, (r) {
        if (mounted) {
          showSnackBar(context, 'Account created , please login');
          Navigator.push(context, LoginView.route());
        }
      });
    });
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
        (user) => Navigator.push(context, HomeView.route()));
  }

  Future<UserModel> getUserData(String uid) async {
    final userDocument = await _userAPI.getUserData(uid);
    return UserModel.fromMap(userDocument.data);
  }
}
