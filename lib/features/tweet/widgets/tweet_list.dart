import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tweetListApiProvider).when(
        data: (tweetList) {
          return ListView.builder(
              itemCount: tweetList.length,
              itemBuilder: (context, index) {
                return Text('Tweet UI');
              });
        },
        error: (error, _) {
          return Text(error.toString());
        },
        loading: () => const Loader());
  }
}
