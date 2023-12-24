import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/appwrite_constants.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickImages() async {
  final images = <File>[];

  final imagePicker = ImagePicker();
  final imageFiles = await imagePicker.pickMultiImage();

  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }

  return images;
}

Future<File?> pickImage() async {
  final imagePicker = ImagePicker();
  final imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

  if (imageFile != null) {
    return File(imageFile.path);
  }

  return null;
}

String getImageLink(String imageId) =>
    '${AppWriteConstants.endPoint}/storage/buckets/${AppWriteConstants.imagesBucket}/files/$imageId/view?project=${AppWriteConstants.projectId}&mode=admin';
