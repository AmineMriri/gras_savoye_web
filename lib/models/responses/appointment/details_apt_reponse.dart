import 'package:healio/models/appointment.dart';

class DetailsAptResponse {
  final int resCode;
  final Appointment? appointment;

  DetailsAptResponse({required this.resCode, this.appointment});

  factory DetailsAptResponse.fromJson(Map<String, dynamic> json) {
        return DetailsAptResponse(
      resCode: int.parse(json['res_code'].toString()),
      appointment: json['apt_details']==null ? null : Appointment.fromJson(json['apt_details']),
    );
  }
}
