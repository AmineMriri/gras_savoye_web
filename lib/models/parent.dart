class Parent {
  final int id;
  final String name;

  Parent({
    required this.id,
    required this.name,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['parent_id'],
      name: json['parent_name'],
    );
  }
}