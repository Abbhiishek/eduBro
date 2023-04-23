import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePic;
  final String banner;
  final String uid;
  final bool isAuthenticated;
  final int karma;
  final List<String> awards;
  final String bio;
  final String username;
  final int level;
  final List<String> posts;
  final List<String> comments;
  final List<String> topics;
  final List<String> communities;
  final List<String> followers;
  final List<String> following;
  final List<String> notifications;
  final List<String> savedPosts;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.banner,
    required this.uid,
    required this.isAuthenticated,
    required this.karma,
    required this.awards,
    required this.bio,
    required this.username,
    required this.level,
    required this.posts,
    required this.comments,
    required this.topics,
    required this.communities,
    required this.followers,
    required this.following,
    required this.notifications,
    required this.savedPosts,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePic,
    String? banner,
    String? uid,
    bool? isAuthenticated,
    int? karma,
    List<String>? awards,
    String? bio,
    String? username,
    int? level,
    List<String>? posts,
    List<String>? comments,
    List<String>? topics,
    List<String>? communities,
    List<String>? followers,
    List<String>? following,
    List<String>? notifications,
    List<String>? savedPosts,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
      bio: bio ?? this.bio,
      username: username ?? this.username,
      level: level ?? this.level,
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
      topics: topics ?? this.topics,
      communities: communities ?? this.communities,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      notifications: notifications ?? this.notifications,
      savedPosts: savedPosts ?? this.savedPosts,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'profilePic': profilePic});
    result.addAll({'banner': banner});
    result.addAll({'uid': uid});
    result.addAll({'isAuthenticated': isAuthenticated});
    result.addAll({'karma': karma});
    result.addAll({'awards': awards});
    result.addAll({'bio': bio});
    result.addAll({'username': username});
    result.addAll({'level': level});
    result.addAll({'posts': posts});
    result.addAll({'comments': comments});
    result.addAll({'topics': topics});
    result.addAll({'communities': communities});
    result.addAll({'followers': followers});
    result.addAll({'following': following});
    result.addAll({'notifications': notifications});
    result.addAll({'savedPosts': savedPosts});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      banner: map['banner'] ?? '',
      uid: map['uid'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? false,
      karma: map['karma']?.toInt() ?? 0,
      awards: List<String>.from(map['awards']),
      bio: map['bio'] ?? '',
      username: map['username'] ?? '',
      level: map['level']?.toInt() ?? 0,
      posts: List<String>.from(map['posts']),
      comments: List<String>.from(map['comments']),
      topics: List<String>.from(map['topics']),
      communities: List<String>.from(map['communities']),
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      notifications: List<String>.from(map['notifications']),
      savedPosts: List<String>.from(map['savedPosts']),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profilePic: $profilePic, banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, karma: $karma, awards: $awards, bio: $bio, username: $username, level: $level, posts: $posts, comments: $comments, topics: $topics, communities: $communities, followers: $followers, following: $following, notifications: $notifications, savedPosts: $savedPosts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.karma == karma &&
        listEquals(other.awards, awards) &&
        other.bio == bio &&
        other.username == username &&
        other.level == level &&
        listEquals(other.posts, posts) &&
        listEquals(other.comments, comments) &&
        listEquals(other.topics, topics) &&
        listEquals(other.communities, communities) &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        listEquals(other.notifications, notifications) &&
        listEquals(other.savedPosts, savedPosts);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePic.hashCode ^
        banner.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        karma.hashCode ^
        awards.hashCode ^
        bio.hashCode ^
        username.hashCode ^
        level.hashCode ^
        posts.hashCode ^
        comments.hashCode ^
        topics.hashCode ^
        communities.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        notifications.hashCode ^
        savedPosts.hashCode;
  }
}
