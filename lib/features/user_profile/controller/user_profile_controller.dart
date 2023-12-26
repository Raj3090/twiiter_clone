import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../../core/utils.dart';
import '../../../models/tweet_model.dart';

final userTweetsProvider = FutureProvider.family((ref, String uid) =>
    ref.watch(userProfileControllerProvider.notifier).getTweetByUser(uid));

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
        (ref) => UserProfileController(
              userApi: ref.watch(userApiProvider),
              tweetApi: ref.watch(tweetApiProvider),
              storageApi: ref.watch(storageProvider),
            ));

class UserProfileController extends StateController<bool> {
  final UserAPI _userApi;
  final TweetAPI _tweetApi;
  final StorageAPI _storageApi;

  UserProfileController({
    required UserAPI userApi,
    required TweetAPI tweetApi,
    required StorageAPI storageApi,
  })  : _userApi = userApi,
        _tweetApi = tweetApi,
        _storageApi = storageApi,
        super(false);

  Future<List<Tweet>> getTweetByUser(String uid) async {
    final usersDoc = await _tweetApi.getTweetByUser(uid);
    return usersDoc.map((documnet) => Tweet.fromMap(documnet.data)).toList();
  }

  Future saveUserProfileData(UserModel userModel, File? bannerImage,
      File? profileImage, BuildContext context) async {
    if (bannerImage != null) {
      final imageUrls = await _storageApi.getImageLinks([bannerImage]);
      userModel = userModel.copyWith(bannerPic: imageUrls[0]);
    }

    if (profileImage != null) {
      final imageUrls = await _storageApi.getImageLinks([profileImage]);
      userModel = userModel.copyWith(profilePic: imageUrls[0]);
    }

    final response = await _userApi.updateUserData(userModel);
    response.fold((l) => showSnackBar(context, l.message), (r) => null);
  }
}
