import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
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
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: TextField(
          onSubmitted: (value) {
            ref
                .read(tweetControllerProvider.notifier)
                .shareTweet(context, [], value, tweet.id);
          },
          textInputAction: TextInputAction.go,
          style: const TextStyle(
            fontSize: 22,
          ),
          decoration: const InputDecoration(
            hintText: 'Reply Tweet here!',
            hintStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            border: InputBorder.none,
          ),
          maxLines: null,
        ),
      ),
    );
  }
}
