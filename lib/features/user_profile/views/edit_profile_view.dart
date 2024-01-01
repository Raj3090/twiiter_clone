import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route(UserModel userModel) => MaterialPageRoute(
      builder: (context) => EditProfileView(userModel: userModel));

  final UserModel userModel;
  const EditProfileView({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  TextEditingController? nameController;
  TextEditingController? bioController;

  File? bannerImage;
  File? profileImage;

  Future selectBannerImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        bannerImage = image;
      });
    }
  }

  Future selectProfileImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        profileImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final userModel = widget.userModel;
    nameController = TextEditingController(text: userModel?.name ?? '');
    bioController = TextEditingController(text: userModel?.bio ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final userModel = widget.userModel;
    return userModel == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () {
                      final updatedUser = userModel.copyWith(
                          name: nameController?.text, bio: bioController?.text);
                      ref
                          .watch(userProfileControllerProvider.notifier)
                          .saveUserProfileData(
                              updatedUser, bannerImage, profileImage, context);
                    },
                    child: const Text('Save'))
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            height: 150,
                            width: double.infinity,
                            child: bannerImage != null
                                ? Image.file(
                                    bannerImage!,
                                    fit: BoxFit.fitWidth,
                                  )
                                : userModel.bannerPic.isEmpty
                                    ? Container(
                                        color: Pallete.blueColor,
                                      )
                                    : Image.network(
                                        userModel.bannerPic,
                                        fit: BoxFit.fitWidth,
                                      )),
                      ),
                      Positioned(
                          bottom: 20,
                          left: 16,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                            child: profileImage != null
                                ? CircleAvatar(
                                    radius: 36,
                                    backgroundImage: FileImage(profileImage!),
                                  )
                                : CircleAvatar(
                                    radius: 36,
                                    backgroundImage:
                                        NetworkImage(userModel.profilePic),
                                  ),
                          )),
                    ],
                  ),
                ),
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: 'Name', contentPadding: EdgeInsets.all(20))),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      hintText: 'Bio', contentPadding: EdgeInsets.all(20)),
                )
              ],
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    nameController?.dispose();
    bioController?.dispose();
  }
}
