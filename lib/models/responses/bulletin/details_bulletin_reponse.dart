import '../../prestation.dart';

class DetailsBulletinResponse {
  final int resCode;
  final double? totalDep;
  final double? totalPec;
  final String? state;
  final List<Prestation> prestations;

  DetailsBulletinResponse({required this.resCode, this.totalDep, this.totalPec, this.state, required this.prestations});

  factory DetailsBulletinResponse.fromJson(Map<String, dynamic> json) {
    return DetailsBulletinResponse(
      resCode: json['res_code'] == false ? -1 : int.tryParse(json['res_code'].toString().trim()) ?? -1,
      totalDep: json['total_dep'] != null ? double.parse(json['total_dep'].toStringAsFixed(3)) : null,
      totalPec: json['total_pec'] != null ? double.parse(json['total_pec'].toStringAsFixed(3)) : null,
      state: json['state'],
      prestations: (json['list_bs_details'] as List)
          .map((item) => Prestation.fromJson(item))
          .toList(),
    );
  }
}

