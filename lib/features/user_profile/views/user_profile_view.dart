import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/user_model.dart';

class UserProfileView extends ConsumerStatefulWidget {
  static route(UserModel userModel) => MaterialPageRoute(
      builder: (context) => UserProfileView(
            userModel: userModel,
          ));

  final UserModel userModel;
  const UserProfileView({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileViewState();
}

class _UserProfileViewState extends ConsumerState<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
