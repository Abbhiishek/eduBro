import 'dart:convert';

import 'package:flutter/foundation.dart';

class Notification {
  final String id;
  final String title;
  final String body;
  final String type;
  final String payload;
  final DateTime createdAt;
  final String senderId;
  final List<String> receiverId;
  final String? image;
  final bool isRead;
  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.payload,
    required this.createdAt,
    required this.senderId,
    required this.receiverId,
    this.image,
    required this.isRead,
  });

  Notification copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? payload,
    DateTime? createdAt,
    String? senderId,
    List<String>? receiverId,
    String? image,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      image: image ?? this.image,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'body': body});
    result.addAll({'type': type});
    result.addAll({'payload': payload});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'senderId': senderId});
    result.addAll({'receiverId': receiverId});
    if (image != null) {
      result.addAll({'image': image});
    }
    result.addAll({'isRead': isRead});

    return result;
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? '',
      payload: map['payload'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      senderId: map['senderId'] ?? '',
      receiverId: List<String>.from(map['receiverId']),
      image: map['image'],
      isRead: map['isRead'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Notification(id: $id, title: $title, body: $body, type: $type, payload: $payload, createdAt: $createdAt, senderId: $senderId, receiverId: $receiverId, image: $image, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notification &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.type == type &&
        other.payload == payload &&
        other.createdAt == createdAt &&
        other.senderId == senderId &&
        listEquals(other.receiverId, receiverId) &&
        other.image == image &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        type.hashCode ^
        payload.hashCode ^
        createdAt.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        image.hashCode ^
        isRead.hashCode;
  }
}
