// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SRMMail {
  String body;
  String senderId;
  DateTime time;
  String directedTo;
  String studentId;
  SRMMail({
    required this.body,
    required this.senderId,
    required this.time,
    required this.directedTo,
    required this.studentId,
  });

  SRMMail copyWith({
    String? body,
    String? senderId,
    DateTime? time,
    String? directedTo,
    String? studentId,
  }) {
    return SRMMail(
      body: body ?? this.body,
      senderId: senderId ?? this.senderId,
      time: time ?? this.time,
      directedTo: directedTo ?? this.directedTo,
      studentId: studentId ?? this.studentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'body': body,
      'senderId': senderId,
      'time': time.toIso8601String(),
      'directedTo': directedTo,
      'studentId': studentId,
    };
  }

  factory SRMMail.fromMap(Map<String, dynamic> map) {
    return SRMMail(
      body: map['body'] as String,
      senderId: map['senderId'] as String,
      time: DateTime.parse(map['time'] as String),
      directedTo: map['directedTo'] as String,
      studentId: map['studentId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SRMMail.fromJson(String source) =>
      SRMMail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SRMMail(body: $body, senderId: $senderId, time: $time, directedTo: $directedTo, studentId: $studentId)';
  }

  @override
  bool operator ==(covariant SRMMail other) {
    if (identical(this, other)) return true;

    return other.body == body &&
        other.senderId == senderId &&
        other.time == time &&
        other.directedTo == directedTo &&
        other.studentId == studentId;
  }

  @override
  int get hashCode {
    return body.hashCode ^
        senderId.hashCode ^
        time.hashCode ^
        directedTo.hashCode ^
        studentId.hashCode;
  }
}
