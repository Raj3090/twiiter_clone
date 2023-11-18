import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/utils.dart';

final storageProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appWriteStorageProvider));
});

class StorageAPI {
  final Storage _storage;

  const StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> getImageLinks(List<File> files) async {
    List<String> imageFileLinks = [];
    for (final file in files) {
      final uploadedFile = await _storage.createFile(
          bucketId: AppWriteConstants.imagesBucket,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: file.path));
      imageFileLinks.add(getImageLink(uploadedFile.$id));
    }
    return imageFileLinks;
  }
}
