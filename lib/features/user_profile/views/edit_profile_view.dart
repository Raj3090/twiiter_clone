import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';

import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const EditProfileView());

  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(currentUserDataProvider).value;
    return userModel == null
        ? const Loader()
        : Scaffold(
            body: SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      height: 150,
                      width: double.infinity,
                      child: userModel.bannerPic.isEmpty
                          ? Container(
                              color: Pallete.blueColor,
                            )
                          : Image.network(userModel.bannerPic)),
                  Positioned(
                      bottom: 20,
                      left: 16,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(userModel.profilePic),
                      )),
                ],
              ),
            ),
          );
  }
}
