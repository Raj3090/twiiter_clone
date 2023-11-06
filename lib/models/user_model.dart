// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {

  final String email;
  final String name;
  final String bannerPic;
  final String profilePic;
  final String uid;
  final String bio;
  final bool isTwitterBlue;
  final List<String> followers;
  final List<String> following;
  UserModel({
    required this.email,
    required this.name,
    required this.bannerPic,
    required this.profilePic,
    required this.uid,
    required this.bio,
    required this.isTwitterBlue,
    required this.followers,
    required this.following,
  });


  UserModel copyWith({
    String? email,
    String? name,
    String? bannerPic,
    String? profilePic,
    String? uid,
    String? bio,
    bool? isTwitterBlue,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      bannerPic: bannerPic ?? this.bannerPic,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'bannerPic': bannerPic,
      'profilePic': profilePic,
      'uid': uid,
      'bio': bio,
      'isTwitterBlue': isTwitterBlue,
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      bannerPic: map['bannerPic'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      bio: map['bio'] as String,
      isTwitterBlue: map['isTwitterBlue'] as bool,
      followers: List<String>.from(map['followers'] as List<String>),
      following: List<String>.from(map['following'] as List<String>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, bannerPic: $bannerPic, profilePic: $profilePic, uid: $uid, bio: $bio, isTwitterBlue: $isTwitterBlue, followers: $followers, following: $following)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return
      other.email == email &&
      other.name == name &&
      other.bannerPic == bannerPic &&
      other.profilePic == profilePic &&
      other.uid == uid &&
      other.bio == bio &&
      other.isTwitterBlue == isTwitterBlue &&
      listEquals(other.followers, followers) &&
      listEquals(other.following, following);
  }

  @override
  int get hashCode {
    return email.hashCode ^
      name.hashCode ^
      bannerPic.hashCode ^
      profilePic.hashCode ^
      uid.hashCode ^
      bio.hashCode ^
      isTwitterBlue.hashCode ^
      followers.hashCode ^
      following.hashCode;
  }
}
