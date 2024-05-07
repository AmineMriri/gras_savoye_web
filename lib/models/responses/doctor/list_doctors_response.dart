import 'package:healio/models/doctor.dart';

class ListDoctorsResponse {
  final int resCode;
  final int totalPages;
  final int totalCount;
  final List<Doctor> doctors;

  ListDoctorsResponse({required this.resCode, required this.totalPages, required this.totalCount, required this.doctors});

  factory ListDoctorsResponse.fromJson(Map<String, dynamic> json) {
    return ListDoctorsResponse(
      resCode: int.parse(json['res_code'].toString()),
      totalPages: int.parse(json['total_pages'].toString()),
      totalCount: int.parse(json['total_count'].toString()),
      doctors: (json['physician_list'] as List)
          .map((item) => Doctor.fromJson(item))
          .toList(),
    );
  }
}

