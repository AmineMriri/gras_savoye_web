import 'package:healio/models/family_member.dart';

import 'doctor.dart';

class Appointment {
  final int aptId;
  final Doctor doctor;
  final String date;
  final String time;
  final FamilyMember? familyMember;
  final String motif;
  final String state;
  final String? cancelReason;

  Appointment({
    required this.aptId,
    required this.doctor,
    required this.date,
    required this.time,
    this.familyMember,
    required this.motif,
    required this.state,
    this.cancelReason,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      aptId: json['apt_id'],
      doctor: json['doctor'] as Doctor,
      date: json['date'],
      time: json['time'],
      familyMember: json['patient'] == false ? null : json['patient'],
      motif: json['motif'],
      state: json['state'],
      cancelReason: json['cancel_reason'] == false ? null : json['cancel_reason'],
    );
  }
  @override
  String toString() {
    return 'Appointment{aptId: $aptId, doctor: $doctor, date: $date, time: $time, familyMember: $familyMember, motif: $motif, state: $state}';
  }
}
