import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/user_model.dart';

class UserProfile extends ConsumerWidget {
  final UserModel userModel;
  const UserProfile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
