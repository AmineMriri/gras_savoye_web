import 'package:healio/models/doctor.dart';

class DetailsDoctorResponse {
  final int resCode;
  final Doctor? doctor;

  DetailsDoctorResponse({required this.resCode, this.doctor});

  factory DetailsDoctorResponse.fromJson(Map<String, dynamic> json) {
        return DetailsDoctorResponse(
      resCode: int.parse(json['res_code'].toString()),
      doctor: json['physician_details']==null ? null : Doctor.fromJson(json['physician_details']),
    );
  }
}
