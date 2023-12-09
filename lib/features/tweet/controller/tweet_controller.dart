import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/tweet_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

final tweetApiProvider = Provider((ref) => TweetAPI(
    db: ref.watch(appWriteDataBaseProvider),
    realtime: ref.watch(appWriteRealtimeProvider)));

final tweetListApiProvider = FutureProvider(
    (ref) => ref.watch(tweetControllerProvider.notifier).getTweets());

final latestTweetProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(tweetApiProvider).getLatestTweet();
});

final getRepliedToTweetListProvider = FutureProvider.family(
    (ref, Tweet tweet) =>
        ref.watch(tweetControllerProvider.notifier).getRepliedToTweets(tweet));

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) => TweetController(
          ref: ref,
          tweetApi: ref.watch(tweetApiProvider),
          storageApi: ref.watch(storageProvider),
        ));

final getTweetByIdProvider = FutureProvider.family((ref, String id) =>
    ref.watch(tweetControllerProvider.notifier).getTweetById(id));

class TweetController extends StateController<bool> {
  final Ref _ref;
  final TweetAPI _tweetApi;
  final StorageAPI _storageApi;
  TweetController(
      {required Ref ref,
      required TweetAPI tweetApi,
      required StorageAPI storageApi})
      : _ref = ref,
        _tweetApi = tweetApi,
        _storageApi = storageApi,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetsDoc = await _tweetApi.getTweetList();
    return tweetsDoc.map((documnet) => Tweet.fromMap(documnet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweetsDoc = await _tweetApi.getTweetById(id);
    return Tweet.fromMap(tweetsDoc.data);
  }

  Future<List<Tweet>> getRepliedToTweets(Tweet tweet) async {
    print('calling => getRepliedToTweets');
    final tweetsDoc = await _tweetApi.getRepliedToTweetList(tweet);
    return tweetsDoc.map((documnet) => Tweet.fromMap(documnet.data)).toList();
  }

  void shareTweet(
      BuildContext context, List<File> images, String text, String repliedTo) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please add a tweet');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(context, images, text, repliedTo);
    } else {
      _shareTextTweet(context, images, text, repliedTo);
    }
  }

  Future<void> _shareImageTweet(BuildContext context, List<File> images,
      String text, String repliedTo) async {
    state = true;
    final hashtags = _getHashTagsFromText(text);
    final link = _getLinkFromText(text);

    final currentUser = _ref.read(currentUserDataProvider).value!;

    final imageLinks = await _storageApi.getImageLinks(images);

    final tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: imageLinks,
        uid: currentUser.uid,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: '',
        retweetedBy: '',
        repliedTo: repliedTo,
        shareCount: 0);

    final response = await _tweetApi.shareTweet(tweet);

    state = false;

    response.fold((error) {
      showSnackBar(context, error.message);
    }, (r) {
      if (mounted) {
        showSnackBar(context, 'Tweeted!');
      }
    });
  }

  Future<void> _shareTextTweet(BuildContext context, List<File> images,
      String text, String repliedTo) async {
    state = true;
    final hashtags = _getHashTagsFromText(text);
    final link = _getLinkFromText(text);

    final currentUser = _ref.read(currentUserDataProvider).value!;

    final tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: [],
        uid: currentUser.uid,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: '',
        retweetedBy: '',
        repliedTo: repliedTo,
        shareCount: 0);

    final response = await _tweetApi.shareTweet(tweet);

    state = false;

    response.fold((error) {
      showSnackBar(context, error.message);
    }, (r) {
      if (mounted) {
        showSnackBar(context, 'Tweeted!');
        Navigator.pop(context);
      }
    });
  }

  String _getLinkFromText(String text) {
    String link = '';

    List<String> wordsInSentence = text.split(' ');

    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashTagsFromText(String text) {
    final hashtags = <String>[];

    List<String> wordsInSentence = text.split(' ');

    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Future<void> likeTweet(
    Tweet tweet,
    UserModel userModel,
  ) async {
    List<String> likes = [];

    if (tweet.likes.contains(userModel.uid)) {
      likes.remove(userModel.uid);
    } else {
      likes.add(userModel.uid);
    }

    tweet = tweet.copyWith(likes: likes);
    final response = await _tweetApi.likeTweet(tweet);

    response.fold((error) {}, (r) {
      if (mounted) {}
    });
  }

  Future<void> retweet(
    BuildContext context,
    Tweet tweet,
    UserModel userModel,
  ) async {
    tweet = tweet.copyWith(shareCount: tweet.shareCount + 1);

    final response = await _tweetApi.updateReshareCount(tweet);

    response.fold((error) {
      showSnackBar(context, error.message);
    }, (r) async {
      if (mounted) {
        tweet = tweet.copyWith(
            likes: [],
            commentIds: [],
            retweetedBy: userModel.name,
            tweetedAt: DateTime.now(),
            shareCount: 0,
            id: ID.unique());
        final res2 = await _tweetApi.shareTweet(tweet);
        res2.fold((error) => showSnackBar(context, error.message),
            (r) => showSnackBar(context, 'retweeted!'));
      }
    });
  }
}
