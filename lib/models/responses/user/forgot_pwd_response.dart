class ForgotPwdResponse {
  final int res_code;

  ForgotPwdResponse({
    required this.res_code,
  });

  factory ForgotPwdResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPwdResponse(
      res_code: int.parse(json['res_code'].toString()),
    );
  }
}
