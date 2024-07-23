import 'package:healio/models/child.dart';

import '../../parent.dart';

class FamilyMembersResponse {
  final int? resCode;
  final int? id;
  final String? name;
  final String? conjoint;
  final int? conjointId;
  final List<Child>? children;
  final List<Parent>? parents;

  FamilyMembersResponse({
    this.resCode,
    this.id,
    this.name,
    this.conjoint,
    this.conjointId,
    this.children,
    this.parents,
  });

  factory FamilyMembersResponse.fromJson(Map<String, dynamic> json) {
    return FamilyMembersResponse(
      resCode: json['res_code'] == false ? -1 : int.tryParse(json['res_code'].toString().trim()) ?? -1,
      id: json['id']!=false ? json['id'] : null,
      name: json['name'].toString()!=false ? json['name'] : null,
      conjoint: json['conjoint']!=false ? json['conjoint'] : null,
      conjointId: json['conjoint_id']!=false ? json['conjoint_id'] : null,
      children: (json['list_childs'] as List)
          .map((item) => Child.fromJson(item))
          .toList(),
      parents: (json['list_parent'] as List)
          .map((item) => Parent.fromJson(item))
          .toList(),
    );
  }
}
