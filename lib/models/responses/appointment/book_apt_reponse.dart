import '../../appointment.dart';

class AptResponse {
  final int resCode;
  final Appointment? appointment;

  AptResponse({required this.resCode, this.appointment});

  factory AptResponse.fromJson(Map<String, dynamic> json) {
    return AptResponse(
      resCode: int.parse(json['res_code'].toString()),
      appointment: json['appointment']==null ? null : Appointment.fromJson(json['appointment']),
    );
  }
}
