class LoginResponse {
  final int res_code;
  final String? id;
  final String? name;
  final String? conjoint;
  final bool? child;
  final bool? parent;

  LoginResponse({
    required this.res_code,
    this.id,
    this.name,
    this.conjoint,
    this.child,
    this.parent,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is int && value !=0) {
        return value != 0;
      } else {
        return false;
      }
    }

    return LoginResponse(
      res_code: int.parse(json['res_code'].toString()),
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      conjoint: json['conjoint']?.toString(),
      child: parseBool(json['child']),
      parent: parseBool(json['parent']),
    );
  }
}
