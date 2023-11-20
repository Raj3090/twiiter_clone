import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';

class TweetWidget extends ConsumerWidget {
  const TweetWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tweetListApiProvider).when(
        data: (tweetList) {
          return ListView.builder(itemBuilder: (context, _) {
            return Text('some error');
          });
        },
        error: (error, StackTrace) {
          return Text('some error');
        },
        loading: () => const Loader());
  }
}
