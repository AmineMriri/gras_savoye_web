class FamilyMember {
  final String name;
  final String birthdate;

  FamilyMember({
    required this.name,
    required this.birthdate,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      name: json['name'],
      birthdate: json['birthdate'],
    );
  }

  @override
  String toString() {
    return 'Family member: {name: $name, birthdate: $birthdate}';
  }
}
