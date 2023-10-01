// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:srm_conn_server/model/student.dart';

class Faculty {
  String name;
  String regNum;
  String position;
  String email;
  String whatsappNumber;
  String? batch;
  List<dynamic>? threads;
  int? semester;
  List<dynamic>? studentId = [];
  Faculty({
    required this.name,
    required this.regNum,
    required this.position,
    required this.email,
    required this.whatsappNumber,
    this.batch,
    this.threads,
    this.semester,
    this.studentId,
  });

  Faculty copyWith({
    String? name,
    String? regNum,
    String? position,
    String? email,
    String? whatsappNumber,
    String? batch,
    List<dynamic>? threads,
    int? semester,
    List<dynamic>? studentId,
  }) {
    return Faculty(
      name: name ?? this.name,
      regNum: regNum ?? this.regNum,
      position: position ?? this.position,
      email: email ?? this.email,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      batch: batch ?? this.batch,
      threads: threads ?? this.threads,
      semester: semester ?? this.semester,
      studentId: studentId ?? this.studentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'regNum': regNum,
      'position': position,
      'email': email,
      'whatsappNumber': whatsappNumber,
      'batch': batch,
      'threads': threads,
      'semester': semester,
      'studentId': studentId,
    };
  }

  factory Faculty.fromMap(Map<String, dynamic> map) {
    return Faculty(
      name: map['name'] as String,
      regNum: map['regNum'] as String,
      position: map['position'] as String,
      email: map['email'] as String,
      whatsappNumber: map['whatsappNumber'] as String,
      batch: map['batch'] != null ? map['batch'] as String : null,
      threads: map['threads'] != null
          ? List<dynamic>.from((map['threads'] as List<dynamic>))
          : null,
      semester: map['semester'] != null ? map['semester'] as int : null,
      studentId: map['studentId'] != null
          ? List<dynamic>.from((map['studentId'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Faculty.fromJson(String source) =>
      Faculty.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Faculty(name: $name, regNum: $regNum, position: $position, email: $email, whatsappNumber: $whatsappNumber, batch: $batch, threads: $threads, semester: $semester, studentId: $studentId)';
  }

  @override
  bool operator ==(covariant Faculty other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.regNum == regNum &&
        other.position == position &&
        other.email == email &&
        other.whatsappNumber == whatsappNumber &&
        other.batch == batch &&
        listEquals(other.threads, threads) &&
        other.semester == semester &&
        listEquals(other.studentId, studentId);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        regNum.hashCode ^
        position.hashCode ^
        email.hashCode ^
        whatsappNumber.hashCode ^
        batch.hashCode ^
        threads.hashCode ^
        semester.hashCode ^
        studentId.hashCode;
  }
}
