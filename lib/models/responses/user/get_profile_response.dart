import 'package:healio/models/family_member.dart';

class GetProfileResponse {
  final int resCode;
  final String? name;
  final String? image;

  final String? matricule;
  final String? etablissement;
  final String? assurance;
  final String? birthdate;
  final String? login;
  final FamilyMember? conjoint;
  final List<FamilyMember>? enfants;
  final List<FamilyMember>? parent;

  GetProfileResponse({
    required this.resCode,
    this.name,
    this.image,

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
      resCode: json['res_code'] == false ? -1 : int.tryParse(json['res_code'].toString().trim()) ?? -1,
      name: json['name'].toString(),
      image: json['image'] == false ? null : json['image'],

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
