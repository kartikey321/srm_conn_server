// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class Thread {
  String? id;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> messageIds;
  Thread({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.messageIds,
  });

  Thread copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<dynamic>? messageIds,
  }) {
    return Thread(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageIds: messageIds ?? this.messageIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messageIds': messageIds,
    };
  }

  factory Thread.fromMap(Map<String, dynamic> map) {
    return Thread(
      id: map['id'] != null ? map['id'] as String : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['createdAt'] as String),
      messageIds: map['messageIds'] != null
          ? List<dynamic>.from((map['messageIds'] as List<dynamic>))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Thread.fromJson(String source) =>
      Thread.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Thread(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, messageIds: $messageIds)';
  }

  @override
  bool operator ==(covariant Thread other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        listEquals(other.messageIds, messageIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        messageIds.hashCode;
  }
}
