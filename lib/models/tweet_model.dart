// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:twitter_clone/core/tweet_type_enum.dart';

class Tweet {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int shareCount;
  final String repliedTo;
  final String retweetedBy;

  Tweet({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.shareCount,
    required this.retweetedBy,
    required this.repliedTo,
  });

  Tweet copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? shareCount,
    String? retweetedBy,
    String? repliedTo,
  }) {
    return Tweet(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      shareCount: shareCount ?? this.shareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashtags': hashtags,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'shareCount': shareCount,
      'retweetedBy': retweetedBy,
      'repliedTo': repliedTo,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] as String,
      hashtags: List<String>.from(map['hashtags'] ?? []),
      link: map['link'] as String,
      imageLinks: List<String>.from(map['imageLinks'] ?? []),
      uid: map['uid'] as String,
      tweetType: (map['tweetType'] as String).toEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt'] as int),
      likes: List<String>.from(map['likes'] ?? []),
      commentIds: List<String>.from(map['commentIds'] ?? []),
      id: map['\$id'] as String,
      shareCount: map['shareCount'] as int,
      retweetedBy: map['retweetedBy'] as String,
      repliedTo: map['repliedTo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tweet.fromJson(String source) =>
      Tweet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tweet(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentIds: $commentIds, id: $id, shareCount: $shareCount,retweetedBy:$retweetedBy,repliedTo:$repliedTo)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.tweetedAt == tweetedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.shareCount == shareCount &&
        other.repliedTo == repliedTo &&
        other.retweetedBy == retweetedBy;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        tweetedAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        id.hashCode ^
        shareCount.hashCode ^
        repliedTo.hashCode ^
        retweetedBy.hashCode;
  }
}
