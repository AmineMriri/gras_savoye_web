
class AvTimeSlotsResponse {
  final int resCode;
  final List<dynamic> slots;

  AvTimeSlotsResponse({required this.resCode, required this.slots,});

  factory AvTimeSlotsResponse.fromJson(Map<String, dynamic> json) {
    return AvTimeSlotsResponse(
      resCode: int.parse(json['res_code'].toString()),
      slots: json['available_time_slots'],
    );
  }
}

