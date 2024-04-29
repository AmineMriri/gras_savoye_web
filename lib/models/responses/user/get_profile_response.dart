import 'package:healio/models/family_member.dart';

class GetProfileResponse {
  final int res_code;
  final String? name;
  final String? matricule;
  final String? etablissement;
  final String? assurance;
  final String? birthdate;
  final String? login;
  final FamilyMember? conjoint;
  final List<FamilyMember>? enfants;
  final List<FamilyMember>? parent;

  GetProfileResponse({
    required this.res_code,
    this.name,
    this.matricule,
    this.etablissement,
    this.assurance,
    this.birthdate,
    this.login,
    this.conjoint,
    this.enfants,
    this.parent,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) {
    List<FamilyMember>? enfants = [];
    if (json['enfants'] != null) {
      enfants = List<FamilyMember>.from(json['enfants'].map((x) => FamilyMember.fromJson(x)));
    }

    List<FamilyMember>? parent = [];
    if (json['parent'] != null) {
      parent = List<FamilyMember>.from(json['parent'].map((x) => FamilyMember.fromJson(x)));
    }

    return GetProfileResponse(
      res_code: int.parse(json['res_code'].toString()),
      name: json['name'].toString(),
      matricule: json['matricule'].toString(),
      etablissement: json['etablissement'].toString(),
      assurance: json['assurance'].toString(),
      birthdate: json['birthdate'].toString(),
      login: json['login'].toString(),
      conjoint: json['conjoint'] != null ? FamilyMember.fromJson(json['conjoint']) : null,
      enfants: enfants,
      parent: parent,
    );
  }

}
