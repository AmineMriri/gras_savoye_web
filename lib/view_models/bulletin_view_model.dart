import 'package:flutter/material.dart' hide Key;
import 'package:healio/models/responses/bulletin/details_bulletin_reponse.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import '../models/responses/bulletin/list_bulletins_response.dart';

class BulletinViewModel with ChangeNotifier {
  OdooClient client = OdooClient('http://vps-015df9c1.vps.ovh.net:8079/');

  Future<ListBulletinsResponse> getBulletins(String userId) async {
    try {
      await client.authenticate(
          'backoffice_Gras_2', 'testportail@test.com', '%ZmYcp^No~1`!7H01T');
      final requestData = {
        'adherent_id': userId,
      };
      final result = await client.callKw({
        'model': 'bulletin.soin',
        'method': 'get_bs_list',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final bulletinResponse = ListBulletinsResponse.fromJson(result);
      return bulletinResponse;
    } catch (e) {
      print("Error fetching bulletins: $e");
      return ListBulletinsResponse(res_code: -1, bulletins: []);
    }
  }


  Future<DetailsBulletinResponse> getBulletinDetails(int bsId) async {
    try {
      await client.authenticate(
          'backoffice_Gras_2', 'testportail@test.com', '%ZmYcp^No~1`!7H01T');
      final requestData = {
        'bs_id': bsId,
      };
      final result = await client.callKw({
        'model': 'bulletin.soin',
        'method': 'get_bs_details',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final bulletinDetailsResponse = DetailsBulletinResponse.fromJson(result);
      return bulletinDetailsResponse;
    } catch (e) {
      print("Error fetching bulletin details: $e");
      return DetailsBulletinResponse(res_code: -1, prestations: []);
    }
  }
}
