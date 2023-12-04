import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

import '../../../models/tweet_model.dart';

class TweetReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
      builder: (context) => TweetReplyScreen(
            tweet: tweet,
          ));
  final Tweet tweet;

  const TweetReplyScreen({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: TweetCard(tweet: tweet),
    );
  }
}
