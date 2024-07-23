class Child {
  final int id;
  final String name;

  Child({
    required this.id,
    required this.name,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['child_id'],
      name: json['child_name'],
    );
  }
}