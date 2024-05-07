import '../../appointment.dart';

class BookAptResponse {
  final int resCode;
  final Appointment? appointment;

  BookAptResponse({required this.resCode, this.appointment});

  factory BookAptResponse.fromJson(Map<String, dynamic> json) {
    return BookAptResponse(
      resCode: int.parse(json['res_code'].toString()),
      appointment: json['appointment']==null ? null : Appointment.fromJson(json['appointment']),
    );
  }
}
