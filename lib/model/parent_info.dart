class ParentInfo {
  String email;
  String name;
  String relation;

//<editor-fold desc="Data Methods">
  ParentInfo({
    required this.email,
    required this.name,
    required this.relation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParentInfo &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          name == other.name &&
          relation == other.relation);

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ relation.hashCode;

  @override
  String toString() {
    return 'ParentInfo{' +
        ' email: $email,' +
        ' name: $name,' +
        ' relation: $relation,' +
        '}';
  }

  ParentInfo copyWith({
    String? email,
    String? name,
    String? relation,
  }) {
    return ParentInfo(
      email: email ?? this.email,
      name: name ?? this.name,
      relation: relation ?? this.relation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'name': this.name,
      'relation': this.relation,
    };
  }

  factory ParentInfo.fromMap(Map<String, dynamic> map) {
    return ParentInfo(
      email: map['email'] as String,
      name: map['name'] as String,
      relation: map['relation'] as String,
    );
  }

//</editor-fold>
}
