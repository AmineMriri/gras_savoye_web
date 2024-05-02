import 'package:healio/models/doctor.dart';

class ListDoctorsResponse {
  final int res_code;
  final List<Doctor> doctors;

  ListDoctorsResponse({required this.res_code, required this.doctors});

  factory ListDoctorsResponse.fromJson(Map<String, dynamic> json) {
    return ListDoctorsResponse(
      res_code: int.parse(json['res_code'].toString()),
      doctors: (json['physician_list'] as List)
          .map((item) => Doctor.fromJson(item))
          .toList(),
    );
  }
}

