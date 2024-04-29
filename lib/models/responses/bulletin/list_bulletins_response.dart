import 'package:healio/models/bulletin.dart';

class ListBulletinsResponse {
  final int res_code;
  final List<Bulletin> bulletins;

  ListBulletinsResponse({required this.res_code, required this.bulletins});

  factory ListBulletinsResponse.fromJson(Map<String, dynamic> json) {
    return ListBulletinsResponse(
      res_code: int.parse(json['res_code'].toString()),
      bulletins: (json['list_bs'] as List)
          .map((item) => Bulletin.fromJson(item))
          .toList(),
    );
  }
}

