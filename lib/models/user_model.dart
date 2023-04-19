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
  final Map<String, dynamic> posts;
  final Map<String, dynamic> replies;
  final Map<String, dynamic> subjects;
  final Map<String, dynamic> communities;
  final Map<String, dynamic> followers;
  final Map<String, dynamic> following;
  final Map<String, dynamic> notifications;
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
    required this.replies,
    required this.subjects,
    required this.communities,
    required this.followers,
    required this.following,
    required this.notifications,
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
    Map<String, dynamic>? posts,
    Map<String, dynamic>? replies,
    Map<String, dynamic>? subjects,
    Map<String, dynamic>? communities,
    Map<String, dynamic>? followers,
    Map<String, dynamic>? following,
    Map<String, dynamic>? notifications,
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
      replies: replies ?? this.replies,
      subjects: subjects ?? this.subjects,
      communities: communities ?? this.communities,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      notifications: notifications ?? this.notifications,
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
    result.addAll({'replies': replies});
    result.addAll({'subjects': subjects});
    result.addAll({'communities': communities});
    result.addAll({'followers': followers});
    result.addAll({'following': following});
    result.addAll({'notifications': notifications});

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
      posts: Map<String, dynamic>.from(map['posts']),
      replies: Map<String, dynamic>.from(map['replies']),
      subjects: Map<String, dynamic>.from(map['subjects']),
      communities: Map<String, dynamic>.from(map['communities']),
      followers: Map<String, dynamic>.from(map['followers']),
      following: Map<String, dynamic>.from(map['following']),
      notifications: Map<String, dynamic>.from(map['notifications']),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profilePic: $profilePic, banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, karma: $karma, awards: $awards, bio: $bio, username: $username, level: $level, posts: $posts, replies: $replies, subjects: $subjects, communities: $communities, followers: $followers, following: $following, notifications: $notifications)';
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
        mapEquals(other.posts, posts) &&
        mapEquals(other.replies, replies) &&
        mapEquals(other.subjects, subjects) &&
        mapEquals(other.communities, communities) &&
        mapEquals(other.followers, followers) &&
        mapEquals(other.following, following) &&
        mapEquals(other.notifications, notifications);
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
        replies.hashCode ^
        subjects.hashCode ^
        communities.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        notifications.hashCode;
  }
}
