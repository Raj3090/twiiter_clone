import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
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
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliedToTweetListProvider(tweet)).when(
              data: (tweetList) {
                return ref.watch(latestTweetProvider).when(
                    data: (data) {
                      final latestTweet = Tweet.fromMap(data.payload);
                      bool isTweetAlreadyPresent = false;

                      for (final Tweet tweetModel in tweetList) {
                        if (latestTweet.id == tweetModel.id) {
                          isTweetAlreadyPresent = true;
                        }
                      }
                      if (!isTweetAlreadyPresent &&
                          latestTweet.repliedTo == tweet.id) {
                        if (data.events.contains(
                            'databases.*.collections.${AppWriteConstants.tweetCollectionId}.documents.*.create')) {
                          tweetList.insert(0, Tweet.fromMap(data.payload));
                        } else if (data.events.contains(
                            'databases.*.collections.${AppWriteConstants.tweetCollectionId}.documents.*.update')) {
                          final newTweet = Tweet.fromMap(data.payload);

                          RegExp pattern = RegExp(r'documents\.(.*?)\.update');
                          Match? match = pattern.firstMatch(data.events[0]);

                          final tweetId = match!.group(1)!;

                          final existingTweet = tweetList
                              .where((element) => element.id == tweetId)
                              .first;

                          final index = tweetList.indexOf(existingTweet);

                          tweetList
                              .removeWhere((element) => element.id == tweetId);

                          tweetList.insert(index, newTweet);
                        }
                      }

                      return Expanded(
                        child: ListView.builder(
                            itemCount: tweetList.length,
                            itemBuilder: (context, index) {
                              return TweetCard(tweet: tweetList[index]);
                            }),
                      );
                    },
                    error: (error, _) {
                      return Text(error.toString());
                    },
                    loading: () => Expanded(
                          child: ListView.builder(
                              itemCount: tweetList.length,
                              itemBuilder: (context, index) {
                                return TweetCard(tweet: tweetList[index]);
                              }),
                        ));
              },
              error: (error, _) {
                return Text(error.toString());
              },
              loading: () => const Loader())
        ],
      ),
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
