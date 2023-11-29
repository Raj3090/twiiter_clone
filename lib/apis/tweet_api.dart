import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';

import '../constants/appwrite_constants.dart';
import '../models/tweet_model.dart';

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweetList();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;

  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final doc = await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.tweetCollectionId,
          documentId: ID.unique(),
          data: tweet.toMap());
      return right(doc);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getTweetList() async {
    final data = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetCollectionId,
    );

    return data.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetCollectionId}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final doc = await _db.updateDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.tweetCollectionId,
          documentId: tweet.id,
          data: {'likes': tweet.likes});
      return right(doc);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
