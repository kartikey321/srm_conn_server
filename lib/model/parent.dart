// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class Parent {
  String? id;
  String name;
  String email;
  List<dynamic>? threads;
  String whatsappNumber;
  List<dynamic>? studentId;
  bool verified;
  Parent({
    this.id,
    required this.name,
    required this.email,
    this.threads,
    required this.whatsappNumber,
    this.studentId,
    required this.verified,
  });

  Parent copyWith({
    String? id,
    String? name,
    String? email,
    List<dynamic>? threads,
    String? whatsappNumber,
    List<dynamic>? studentId,
    bool? verified,
  }) {
    return Parent(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      threads: threads ?? this.threads,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      studentId: studentId ?? this.studentId,
      verified: verified ?? this.verified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'threads': threads,
      'whatsappNumber': whatsappNumber,
      'studentId': studentId,
      'verified': verified,
    };
  }

  factory Parent.fromMap(Map<String, dynamic> map) {
    return Parent(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      email: map['email'] as String,
      threads: map['threads'] != null
          ? List<dynamic>.from((map['threads'] as List<dynamic>))
          : null,
      whatsappNumber: map['whatsappNumber'] as String,
      studentId: map['studentId'] != null
          ? List<dynamic>.from((map['studentId'] as List<dynamic>))
          : null,
      verified: map['verified'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Parent.fromJson(String source) =>
      Parent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Parent(id: $id, name: $name, email: $email, threads: $threads, whatsappNumber: $whatsappNumber, studentId: $studentId, verified: $verified)';
  }

  @override
  bool operator ==(covariant Parent other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        listEquals(other.threads, threads) &&
        other.whatsappNumber == whatsappNumber &&
        listEquals(other.studentId, studentId) &&
        other.verified == verified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        threads.hashCode ^
        whatsappNumber.hashCode ^
        studentId.hashCode ^
        verified.hashCode;
  }
}
