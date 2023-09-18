// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class Thread {
  String? id;
  DateTime createdAt;
  DateTime updatedat;
  List<dynamic>? messageIds;
  Thread({
    this.id,
    required this.createdAt,
    required this.updatedat,
    this.messageIds,
  });

  Thread copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedat,
    List<dynamic>? messageIds,
  }) {
    return Thread(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedat: updatedat ?? this.updatedat,
      messageIds: messageIds ?? this.messageIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedat': updatedat.millisecondsSinceEpoch,
      'messageIds': messageIds,
    };
  }

  factory Thread.fromMap(Map<String, dynamic> map) {
    return Thread(
      id: map['id'] != null ? map['id'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedat: DateTime.fromMillisecondsSinceEpoch(map['updatedat'] as int),
      messageIds: map['messageIds'] != null
          ? List<dynamic>.from((map['messageIds'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Thread.fromJson(String source) =>
      Thread.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Thread(id: $id, createdAt: $createdAt, updatedat: $updatedat, messageIds: $messageIds)';
  }

  @override
  bool operator ==(covariant Thread other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.updatedat == updatedat &&
        listEquals(other.messageIds, messageIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        updatedat.hashCode ^
        messageIds.hashCode;
  }
}
