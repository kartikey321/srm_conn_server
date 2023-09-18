// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:srm_conn_server/model/parent.dart';
import 'package:srm_conn_server/model/student.dart';

class SRMMail {
  String body;
  Parent from;
  DateTime time;
  bool isRead = false;
  String directedTo;
  Student ward;

  SRMMail({
    required this.body,
    required this.from,
    required this.time,
    required this.isRead,
    required this.directedTo,
    required this.ward,
  });

  SRMMail copyWith({
    String? body,
    Parent? from,
    DateTime? time,
    bool? isRead,
    String? directedTo,
    Student? ward,
  }) {
    return SRMMail(
      body: body ?? this.body,
      from: from ?? this.from,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      directedTo: directedTo ?? this.directedTo,
      ward: ward ?? this.ward,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'body': body,
      'from': from.toMap(),
      'time': time.millisecondsSinceEpoch,
      'isRead': isRead,
      'directedTo': directedTo,
      'ward': ward.toMap(),
    };
  }

  factory SRMMail.fromMap(Map<String, dynamic> map) {
    return SRMMail(
      body: map['body'] as String,
      from: Parent.fromMap(map['from'] as Map<String, dynamic>),
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      isRead: map['isRead'] as bool,
      directedTo: map['directedTo'] as String,
      ward: Student.fromMap(map['ward'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SRMMail.fromJson(String source) =>
      SRMMail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SRMMail(body: $body, from: $from, time: $time, isRead: $isRead, directedTo: $directedTo, ward: $ward)';
  }

  @override
  bool operator ==(covariant SRMMail other) {
    if (identical(this, other)) return true;

    return other.body == body &&
        other.from == from &&
        other.time == time &&
        other.isRead == isRead &&
        other.directedTo == directedTo &&
        other.ward == ward;
  }

  @override
  int get hashCode {
    return body.hashCode ^
        from.hashCode ^
        time.hashCode ^
        isRead.hashCode ^
        directedTo.hashCode ^
        ward.hashCode;
  }
}
