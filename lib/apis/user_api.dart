import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../core/providers.dart';
import '../core/type_defs.dart';

final userApiProvider = Provider((ref) {
  return UserAPI(db: ref.watch(appWriteDataBaseProvider));
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUserByName(String name);
}

class UserAPI implements IUserAPI {
  final Databases _db;

  UserAPI({required Databases db}) : _db = db;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.userCollectionId,
          documentId: userModel.uid,
          data: userModel.toMap());
      return right(null);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userCollectionId,
        documentId: uid);
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
    final userDoc = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userCollectionId,
        queries: [Query.search('name', name)]);

    return userDoc.documents;
  }
}
