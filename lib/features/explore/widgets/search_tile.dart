import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../user_profile/views/user_profile_view.dart';

class SearchTile extends ConsumerWidget {
  final UserModel userModel;
  const SearchTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        Navigator.push(context, UserProfileView.route(userModel));
      },
      title: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userModel.profilePic),
              radius: 30,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text(userModel.name), Text(userModel.bio)],
          )
        ],
      ),
    );
  }
}
