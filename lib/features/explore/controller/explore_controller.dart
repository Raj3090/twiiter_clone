import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/models/user_model.dart';

final searchUserByNameProvider = FutureProvider.family((ref, String name) =>
    ref.watch(exploreControllerProvider.notifier).searchUserByName(name));

final exploreControllerProvider =
    StateNotifierProvider<ExploreController, bool>((ref) => ExploreController(
          userApi: ref.watch(userApiProvider),
        ));

class ExploreController extends StateController<bool> {
  final UserAPI _userApi;

  ExploreController({
    required UserAPI userApi,
  })  : _userApi = userApi,
        super(false);

  Future<List<UserModel>> searchUserByName(String name) async {
    final usersDoc = await _userApi.searchUserByName(name);
    return usersDoc
        .map((documnet) => UserModel.fromMap(documnet.data))
        .toList();
  }
}
