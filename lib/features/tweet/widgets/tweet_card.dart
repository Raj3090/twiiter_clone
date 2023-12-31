import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/features/user_profile/views/user_profile_view.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../common/loading_page.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../views/tweet_reply_view.dart';

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
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, UserProfileView.route(userData));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userData.profilePic),
                        radius: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, TweetReplyScreen.route(tweet));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tweet.retweetedBy.isNotEmpty)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AssetsConstants.retweetIcon,
                                  colorFilter: const ColorFilter.mode(
                                      Pallete.greyColor, BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  tweet.retweetedBy,
                                  style:
                                      const TextStyle(color: Pallete.blueColor),
                                )
                              ],
                            ),
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
                          const SizedBox(
                            height: 16,
                          ),
                          if (tweet.repliedTo.isNotEmpty)
                            ref
                                .watch(getTweetByIdProvider(tweet.repliedTo))
                                .when(
                              data: (data) {
                                final originalTweetUser =
                                    ref.read(userDataProvider(data.uid)).value;
                                return RichText(
                                    text: TextSpan(
                                        text: 'Replying to ',
                                        style: const TextStyle(
                                          color: Pallete.greyColor,
                                          fontSize: 16,
                                        ),
                                        children: [
                                      TextSpan(
                                        text: '@${originalTweetUser?.name}',
                                        style: const TextStyle(
                                          color: Pallete.blueColor,
                                          fontSize: 16,
                                        ),
                                      )
                                    ]));
                              },
                              error: (error, stackTrace) {
                                return const Text('something wrong!');
                              },
                              loading: () {
                                return const Loader();
                              },
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
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                            )
                          },
                          TweetCardActionsWidget(tweet: tweet),
                          const SizedBox(
                            height: 1,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                color: Pallete.greyColor,
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

class TweetCardActionsWidget extends ConsumerWidget {
  final Tweet tweet;
  const TweetCardActionsWidget({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;

    final tweetController = ref.watch(tweetControllerProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(top: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TweetIconButton(
              pathName: AssetsConstants.viewsIcon,
              text: (tweet.commentIds.length +
                      tweet.likes.length +
                      tweet.shareCount)
                  .toString(),
              onTap: () {}),
          TweetIconButton(
              pathName: AssetsConstants.commentIcon,
              text: (tweet.commentIds.length).toString(),
              onTap: () {}),
          TweetIconButton(
              pathName: AssetsConstants.retweetIcon,
              text: (tweet.shareCount).toString(),
              onTap: () {
                ref
                    .read(tweetControllerProvider.notifier)
                    .retweet(context, tweet, currentUser!);
              }),
          LikeButton(
            onTap: (isLiked) async {
              tweetController.likeTweet(tweet, currentUser);
              return !isLiked;
            },
            isLiked: tweet.likes.contains(currentUser!.uid),
            size: 25,
            likeBuilder: (isLiked) => isLiked
                ? SvgPicture.asset(
                    AssetsConstants.likeFilledIcon,
                    colorFilter: const ColorFilter.mode(
                        Pallete.redColor, BlendMode.srcIn),
                  )
                : SvgPicture.asset(
                    AssetsConstants.likeOutlinedIcon,
                    colorFilter: const ColorFilter.mode(
                        Pallete.greyColor, BlendMode.srcIn),
                  ),
            likeCount: tweet.likes.length,
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share_outlined,
                size: 25,
                color: Pallete.greyColor,
              ))
        ],
      ),
    );
  }
}
