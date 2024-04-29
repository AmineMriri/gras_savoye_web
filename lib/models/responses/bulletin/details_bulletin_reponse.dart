import '../../prestation.dart';

class DetailsBulletinResponse {
  final int res_code;
  final double? totalDep;
  final double? totalPec;
  final String? state;
  final List<Prestation> prestations;

  DetailsBulletinResponse({required this.res_code, this.totalDep, this.totalPec, this.state, required this.prestations});

  factory DetailsBulletinResponse.fromJson(Map<String, dynamic> json) {
    return DetailsBulletinResponse(
      res_code: int.parse(json['res_code'].toString()),
      totalDep: json['total_dep'] != null ? double.parse(json['total_dep'].toStringAsFixed(3)) : null,
      totalPec: json['total_pec'] != null ? double.parse(json['total_pec'].toStringAsFixed(3)) : null,
      state: json['state'],
      prestations: (json['list_bs_details'] as List)
          .map((item) => Prestation.fromJson(item))
          .toList(),
    );
  }
}

