// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:srm_conn_server/model/student.dart';

class Faculty {
  String name;
  String regNo;
  List<Student?> students;
  Faculty({
    required this.name,
    required this.regNo,
    required this.students,
  });

  Faculty copyWith({
    String? name,
    String? regNo,
    List<Student?>? students,
  }) {
    return Faculty(
      name: name ?? this.name,
      regNo: regNo ?? this.regNo,
      students: students ?? this.students,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'regNo': regNo,
      'students': students.map((x) => x?.toMap()).toList(),
    };
  }

  factory Faculty.fromMap(Map<String, dynamic> map) {
    return Faculty(
      name: map['name'] as String,
      regNo: map['regNo'] as String,
      students: List<Student?>.from(
        (map['students'] as List<int>).map<Student?>(
          (x) => Student.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Faculty.fromJson(String source) =>
      Faculty.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Faculty(name: $name, regNo: $regNo, students: $students)';

  @override
  bool operator ==(covariant Faculty other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.regNo == regNo &&
        listEquals(other.students, students);
  }

  @override
  int get hashCode => name.hashCode ^ regNo.hashCode ^ students.hashCode;
}
