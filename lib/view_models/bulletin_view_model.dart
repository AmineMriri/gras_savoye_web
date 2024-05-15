import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart' hide Key;
import 'package:healio/models/responses/bulletin/details_bulletin_reponse.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import '../helper/config.dart';
import '../models/responses/bulletin/list_bulletins_response.dart';

class BulletinViewModel with ChangeNotifier {
  OdooClient client = OdooClient(AppConfig.serverUrl);
  String dbName='backoffice_Gras_2';

  Future<ListBulletinsResponse> getBulletins(String userId) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
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

  Future<ListBulletinsResponse> getBulletinsByStatus(String userId, String status) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      final requestData = {
        'adherent_id': userId,
        'state': status,
      };
      final result = await client.callKw({
        'model': 'bulletin.soin',
        'method': 'get_bs_list_by_state',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final bulletinResponse = ListBulletinsResponse.fromJson(result);
      print("bulletinResponse.bulletins");
      print(bulletinResponse.bulletins);
      return bulletinResponse;
    } catch (e) {
      print("Error fetching bulletins: $e");
      return ListBulletinsResponse(res_code: -1, bulletins: []);
    }
  }


  Future<DetailsBulletinResponse> getBulletinDetails(int bsId) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
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

  Future<File> getBsDocument(int bsId, String bsNum, String type) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      //String fileName = type == "CV" ? '$type - $bsNum.pdf' : '$type $bsNum.pdf';
    String fileName = type == "CV" ? '$type - 1721027.pdf' : '$type 1721027.pdf';

    final requestData = {
        'bs_id': 293376, //TODO change bs id
        'name_report': fileName,
      };

      final result = await client.callKw({
        'model': 'bulletin.soin',
        'method': 'get_bs_doc',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));

      // response from Odoo
      if (result != null && result['datas'] != null) {
        // extract and decode the file content from the response
        String fileData = result['datas'];
        List<int> fileBytes = base64.decode(fileData); // decode base64 to get binary file content

        String fileName = '${type}_${bsNum}_${bsId}.pdf';
        String filePath = '/storage/emulated/0/Download/$fileName';

        // save the file to local storage
        File savedFile = await File(filePath).writeAsBytes(fileBytes);

        print('File saved successfully: $filePath');

        // return the path to the saved file
        return savedFile;
      } else {
        throw Exception('Invalid or empty response from Odoo');
      }

    } catch (e) {
      print("Error fetching and saving bulletin details: $e");
      throw e;
    }
  }

}
