import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel userModel;
  const UserProfile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        : Image.network(userModel.bannerPic))
              ],
            ),
          )
        ];
      },
      body: const Text('data'),
    );
  }
}
