import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../../constants/appwrite_constants.dart';

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
    UserModel copyUserModel = widget.userModel;
    return Scaffold(
        body: ref.watch(userProfileProvider).when(data: (data) {
      if (data.events.contains(
          'databases.*.collections.${AppWriteConstants.userCollectionId}.documents.${copyUserModel.uid}')) {
        copyUserModel = UserModel.fromMap(data.payload);
      }
      return UserProfile(
        userModel: copyUserModel,
      );
    }, error: (error, stackTrace) {
      return Text(error.toString());
    }, loading: () {
      return UserProfile(
        userModel: widget.userModel,
      );
    }));
  }
}
