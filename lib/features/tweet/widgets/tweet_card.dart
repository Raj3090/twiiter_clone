import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../common/loading_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider(tweet.uid)).when(
        data: (userData) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(userData.profilePic),
                      radius: 30,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //retweeted
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Text(
                                userData.name,
                                style: const TextStyle(
                                  color: Pallete.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Text(
                              '@${userData.name} ${timeago.format(tweet.tweetedAt, locale: 'en_short')}',
                              style: const TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        HashTagText(text: tweet.text),
                        if (tweet.imageLinks.isNotEmpty)
                          CarouselImage(imageLinks: tweet.imageLinks),

                        if (tweet.link.isNotEmpty) ...{
                          const SizedBox(
                            height: 16.0,
                          ),
                          AnyLinkPreview(
                            link: tweet.link,
                            displayDirection: UIDirection.uiDirectionHorizontal,
                          )
                        },
                        Container(
                          margin: const EdgeInsets.only(top: 12, right: 12),
                          child: Row(
                            children: [
                              TweetIconButton(
                                  pathName: AssetsConstants.viewsIcon,
                                  text: "0",
                                  onTap: () {})
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        },
        error: (error, _) {
          return Text(error.toString());
        },
        loading: () => const Loader());
  }
}
