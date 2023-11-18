import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/tweet_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final tweetApiProvider =
    Provider((ref) => TweetAPI(db: ref.watch(appWriteDataBaseProvider)));

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) => TweetController(
          ref: ref,
          tweetApi: ref.watch(tweetApiProvider),
          storageApi: ref.watch(storageProvider),
        ));

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

  void shareTweet(BuildContext context, List<File> images, String text) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please add a tweet');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(context, images, text);
    } else {
      _shareTextTweet(context, images, text);
    }
  }

  Future<void> _shareImageTweet(
      BuildContext context, List<File> images, String text) async {
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

  Future<void> _shareTextTweet(
      BuildContext context, List<File> images, String text) async {
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
}
