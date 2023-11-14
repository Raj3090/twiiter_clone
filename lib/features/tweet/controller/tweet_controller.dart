import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/core/utils.dart';

class TweetController extends StateController<bool> {
  TweetController() : super(false);

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

  void _shareImageTweet(BuildContext context, List<File> images, String text) {}

  void _shareTextTweet(BuildContext context, List<File> images, String text) {}
}
