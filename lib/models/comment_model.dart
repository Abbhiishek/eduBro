import 'dart:convert';

class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profilePic;
  final int upVotes;
  final int downVotes;
  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    required this.profilePic,
    required this.upVotes,
    required this.downVotes,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profilePic,
    int? upVotes,
    int? downVotes,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'text': text});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'postId': postId});
    result.addAll({'username': username});
    result.addAll({'profilePic': profilePic});
    result.addAll({'upVotes': upVotes});
    result.addAll({'downVotes': downVotes});

    return result;
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
      upVotes: map['upVotes']?.toInt() ?? 0,
      downVotes: map['downVotes']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic, upVotes: $upVotes, downVotes: $downVotes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.username == username &&
        other.profilePic == profilePic &&
        other.upVotes == upVotes &&
        other.downVotes == downVotes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        profilePic.hashCode ^
        upVotes.hashCode ^
        downVotes.hashCode;
  }
}
