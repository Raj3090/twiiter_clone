import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';

import '../../../models/tweet_model.dart';

final userTweetsProvider = FutureProvider.family((ref, String uid) =>
    ref.watch(userProfileControllerProvider.notifier).getTweetByUser(uid));

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
        (ref) => UserProfileController(
              userApi: ref.watch(userApiProvider),
              tweetApi: ref.watch(tweetApiProvider),
            ));

class UserProfileController extends StateController<bool> {
  final UserAPI _userApi;
  final TweetAPI _tweetApi;

  UserProfileController({
    required UserAPI userApi,
    required TweetAPI tweetApi,
  })  : _userApi = userApi,
        _tweetApi = tweetApi,
        super(false);

  Future<List<Tweet>> getTweetByUser(String uid) async {
    final usersDoc = await _tweetApi.getTweetByUser(uid);
    return usersDoc.map((documnet) => Tweet.fromMap(documnet.data)).toList();
  }
}
