// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class Course {
  String studentId;
  String courseName;
  String facultyName;
  String facultyId;
  String courseCode;
  int courseCredits;
  String courseType;
  double attendance;
  double present;
  double CT1;
  double CT2;
  double CT3;
  int semester;
  Course({
    required this.studentId,
    required this.courseName,
    required this.facultyName,
    required this.facultyId,
    required this.courseCode,
    required this.courseCredits,
    required this.courseType,
    required this.attendance,
    required this.present,
    required this.CT1,
    required this.CT2,
    required this.CT3,
    required this.semester,
  });

  Course copyWith({
    String? studentId,
    String? courseName,
    String? facultyName,
    String? facultyId,
    String? courseCode,
    int? courseCredits,
    String? courseType,
    double? attendance,
    double? present,
    double? CT1,
    double? CT2,
    double? CT3,
    int? semester,
  }) {
    return Course(
      studentId: studentId ?? this.studentId,
      courseName: courseName ?? this.courseName,
      facultyName: facultyName ?? this.facultyName,
      facultyId: facultyId ?? this.facultyId,
      courseCode: courseCode ?? this.courseCode,
      courseCredits: courseCredits ?? this.courseCredits,
      courseType: courseType ?? this.courseType,
      attendance: attendance ?? this.attendance,
      present: present ?? this.present,
      CT1: CT1 ?? this.CT1,
      CT2: CT2 ?? this.CT2,
      CT3: CT3 ?? this.CT3,
      semester: semester ?? this.semester,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentId': studentId,
      'courseName': courseName,
      'facultyName': facultyName,
      'facultyId': facultyId,
      'courseCode': courseCode,
      'courseCredits': courseCredits,
      'courseType': courseType,
      'attendance': attendance,
      'present': present,
      'CT1': CT1,
      'CT2': CT2,
      'CT3': CT3,
      'semester': semester,
    };
  }

  factory Course.fromMap(map) {
    return Course(
      studentId: map['studentId'] as String,
      courseName: map['courseName'] as String,
      facultyName: map['facultyName'] as String,
      facultyId: map['facultyId'] as String,
      courseCode: map['courseCode'] as String,
      courseCredits: map['courseCredits'] as int,
      courseType: map['courseType'] as String,
      attendance: map['attendance'] as double,
      present: map['present'] as double,
      CT1: map['CT1'] as double,
      CT2: map['CT2'] as double,
      CT3: map['CT3'] as double,
      semester: map['semester'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) =>
      Course.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Course(studentId: $studentId, courseName: $courseName, facultyName: $facultyName, facultyId: $facultyId, courseCode: $courseCode, courseCredits: $courseCredits, courseType: $courseType, attendance: $attendance, present: $present, CT1: $CT1, CT2: $CT2, CT3: $CT3, semester: $semester)';
  }

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;

    return other.studentId == studentId &&
        other.courseName == courseName &&
        other.facultyName == facultyName &&
        other.facultyId == facultyId &&
        other.courseCode == courseCode &&
        other.courseCredits == courseCredits &&
        other.courseType == courseType &&
        other.attendance == attendance &&
        other.present == present &&
        other.CT1 == CT1 &&
        other.CT2 == CT2 &&
        other.CT3 == CT3 &&
        other.semester == semester;
  }

  @override
  int get hashCode {
    return studentId.hashCode ^
        courseName.hashCode ^
        facultyName.hashCode ^
        facultyId.hashCode ^
        courseCode.hashCode ^
        courseCredits.hashCode ^
        courseType.hashCode ^
        attendance.hashCode ^
        present.hashCode ^
        CT1.hashCode ^
        CT2.hashCode ^
        CT3.hashCode ^
        semester.hashCode;
  }
}
