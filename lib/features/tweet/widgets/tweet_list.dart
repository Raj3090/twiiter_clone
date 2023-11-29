import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

import '../../../models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tweetListApiProvider).when(
        data: (tweetList) {
          return ref.watch(latestTweetProvider).when(
              data: (data) {
                if (data.events.contains(
                    'databases.*.collections.${AppWriteConstants.tweetCollectionId}.documents.*.create')) {
                  tweetList.insert(0, Tweet.fromMap(data.payload));
                }
                return ListView.builder(
                    itemCount: tweetList.length,
                    itemBuilder: (context, index) {
                      return TweetCard(tweet: tweetList[index]);
                    });
              },
              error: (error, _) {
                return Text(error.toString());
              },
              loading: () => ListView.builder(
                  itemCount: tweetList.length,
                  itemBuilder: (context, index) {
                    return TweetCard(tweet: tweetList[index]);
                  }));
        },
        error: (error, _) {
          return Text(error.toString());
        },
        loading: () => const Loader());
  }
}
