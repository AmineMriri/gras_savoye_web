import 'package:healio/models/bulletin.dart';

class ListBulletinsResponse {
  final int resCode;
  final List<Bulletin> bulletins;
  final int? totalEnCours;
  final int? totalTraite;
  final int? totalAll;


  ListBulletinsResponse({required this.resCode, required this.bulletins, this.totalEnCours, this.totalTraite, this.totalAll});

  factory ListBulletinsResponse.fromJson(Map<String, dynamic> json) {
    return ListBulletinsResponse(
      resCode: json['res_code'] == false ? -1 : int.tryParse(json['res_code'].toString().trim()) ?? -1,
      bulletins: (json['list_bs'] as List)
          .map((item) => Bulletin.fromJson(item))
          .toList(),
      totalEnCours: json['total_en_cours'] == false ? 0 : int.tryParse(json['total_en_cours'].toString().trim()) ?? 0,
      totalTraite: json['total_traité'] == false ? 0 : int.tryParse(json['total_traité'].toString().trim()) ?? 0,
      totalAll: json['total_all'] == false ? 0 : int.tryParse(json['total_all'].toString().trim()) ?? 0,
    );
  }
}

