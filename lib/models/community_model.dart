import 'dart:convert';

import 'package:flutter/foundation.dart';

class Community {
  final String id;
  final String name;
  final String bio;
  final String banner;
  final String avatar;
  final String ownerId;
  final String ownerName;
  final List<String> members;
  final List<String> mods;
  final List<String> tags;
  Community({
    required this.id,
    required this.name,
    required this.bio,
    required this.banner,
    required this.avatar,
    required this.ownerId,
    required this.ownerName,
    required this.members,
    required this.mods,
    required this.tags,
  });

  Community copyWith({
    String? id,
    String? name,
    String? bio,
    String? banner,
    String? avatar,
    String? ownerId,
    String? ownerName,
    List<String>? members,
    List<String>? mods,
    List<String>? tags,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      members: members ?? this.members,
      mods: mods ?? this.mods,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'bio': bio});
    result.addAll({'banner': banner});
    result.addAll({'avatar': avatar});
    result.addAll({'ownerId': ownerId});
    result.addAll({'ownerName': ownerName});
    result.addAll({'members': members});
    result.addAll({'mods': mods});
    result.addAll({'tags': tags});

    return result;
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      banner: map['banner'] ?? '',
      avatar: map['avatar'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      members: List<String>.from(map['members']),
      mods: List<String>.from(map['mods']),
      tags: List<String>.from(map['tags']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Community(id: $id, name: $name, bio: $bio, banner: $banner, avatar: $avatar, ownerId: $ownerId, ownerName: $ownerName, members: $members, mods: $mods, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Community &&
        other.id == id &&
        other.name == name &&
        other.bio == bio &&
        other.banner == banner &&
        other.avatar == avatar &&
        other.ownerId == ownerId &&
        other.ownerName == ownerName &&
        listEquals(other.members, members) &&
        listEquals(other.mods, mods) &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        bio.hashCode ^
        banner.hashCode ^
        avatar.hashCode ^
        ownerId.hashCode ^
        ownerName.hashCode ^
        members.hashCode ^
        mods.hashCode ^
        tags.hashCode;
  }
}
