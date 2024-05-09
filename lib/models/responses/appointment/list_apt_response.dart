import 'package:healio/models/appointment.dart';

class ListAptResponse {
  final int resCode;
  final List<Appointment> apts;
  final int? totalPages;
  final int? totalCount;

  ListAptResponse({required this.resCode, required this.apts, this.totalPages, this.totalCount});

  factory ListAptResponse.fromJson(Map<String, dynamic> json) {
    return ListAptResponse(
      resCode: int.parse(json['res_code'].toString()),
      apts: (json['apts'] as List)
          .map((item) => Appointment.fromJson(item))
          .toList(),
      totalPages: json['totalPages']==false ? null : int.parse(json['totalPages'].toString()),
      totalCount: json['totalCount']==false ? null : int.parse(json['totalCount'].toString()),
    );
  }
}

