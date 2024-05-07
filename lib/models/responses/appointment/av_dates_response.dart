
class AvDatesResponse {
  final int resCode;
  final List<dynamic> dates;

  AvDatesResponse({required this.resCode, required this.dates,});

  factory AvDatesResponse.fromJson(Map<String, dynamic> json) {
    return AvDatesResponse(
      resCode: int.parse(json['res_code'].toString()),
      dates: json['available_dates'],
    );
  }
}

