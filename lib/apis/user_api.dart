import 'package:appwrite/appwrite.dart';
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
          documentId: ID.unique(),
          data: userModel.toMap());
      return right(null);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
