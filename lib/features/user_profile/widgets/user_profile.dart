import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_clone/features/user_profile/views/edit_profile_view.dart';
import 'package:twitter_clone/features/user_profile/widgets/follow_count.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel userModel;
  const UserProfile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                    child: userModel.bannerPic.isEmpty
                        ? Container(
                            color: Pallete.blueColor,
                          )
                        : Image.network(
                            userModel.bannerPic,
                            fit: BoxFit.fitWidth,
                          )),
                Positioned(
                    bottom: 0,
                    left: 16,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(userModel.profilePic),
                    )),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(16),
                  child: OutlinedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Pallete.whiteColor),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25)),
                      onPressed: () {
                        Navigator.push(context, EditProfileView.route());
                      },
                      child: Text(
                        currentUser?.uid != userModel.uid ? 'Follow' : 'Edit',
                        style: const TextStyle(color: Pallete.whiteColor),
                      )),
                )
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Text(
                userModel.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Pallete.whiteColor),
              ),
              Text(
                '@${userModel.name}',
                style: const TextStyle(fontSize: 17, color: Pallete.greyColor),
              ),
              Text(
                userModel.bio,
                style: const TextStyle(fontSize: 17, color: Pallete.greyColor),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  FollowCount(
                      count: userModel.followers.length, text: 'Follower'),
                  const SizedBox(width: 16),
                  FollowCount(
                      count: userModel.following.length, text: 'Following')
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(
                color: Pallete.greyColor,
              )
            ])),
          )
        ];
      },
      body: const TweetList(),
    );
  }
}
