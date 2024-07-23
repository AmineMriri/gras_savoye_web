import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:healio/models/responses/bulletin/details_bulletin_reponse.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:path_provider/path_provider.dart';
import '../helper/config.dart';
import '../models/responses/bulletin/list_bulletins_response.dart';

class BulletinViewModel with ChangeNotifier {
  OdooClient client = OdooClient(AppConfig.serverUrl);
  String dbName='backoffice_Gras_2';

  Future<ListBulletinsResponse> getBulletinsByStatus(String userId, String? status, String dbName) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      final requestData = {
        'adherent_id': userId,
        'state': status ?? status,

      };
      final result = await client.callKw({
        'model': 'bulletin.soin',
        'method': 'get_bs_list_by_state',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 60));
      print("getBulletins !!!!!!!");
      print(result);
      final bulletinResponse = ListBulletinsResponse.fromJson(result['result']);
      return bulletinResponse;
    } catch (e) {
      print("Error fetching bulletins: $e");
      return ListBulletinsResponse(resCode: -1, bulletins: []);
    }
  }

  // Future<ListBulletinsResponse> getBulletinsByStatus(String userId, String status) async {
  //   try {
  //     await client.authenticate(
  //         dbName, AppConfig.dbUsername, AppConfig.dbPassword);
  //     final requestData = {
  //       'adherent_id': userId,
  //       'state': status,
  //     };
  //     final result = await client.callKw({
  //       'model': 'bulletin.soin',
  //       'method': 'get_bs_list_by_state',
  //       'args': [requestData],
  //       'kwargs': {},
  //     }).timeout(const Duration(seconds: 20));
  //     print("getBulletinsByStatus $status !!!!!!!");
  //     print(result);
  //     final bulletinResponse = ListBulletinsResponse.fromJson(result);
  //     return bulletinResponse;
  //   } catch (e) {
  //     print("Error fetching bulletins: $e");
  //     return ListBulletinsResponse(res_code: -1, bulletins: []);
  //   }
  // }


  Future<DetailsBulletinResponse> getBulletinDetails(int bsId, String dbName) async {
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
      }).timeout(const Duration(seconds: 60));
      final bulletinDetailsResponse = DetailsBulletinResponse.fromJson(result['result']);
      return bulletinDetailsResponse;
    } catch (e) {
      print("Error fetching bulletin details: $e");
      return DetailsBulletinResponse(resCode: -1, prestations: []);
    }
  }

  Future<File> getBsDocument(int bsId, String bsNum, String type, String dbName) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      String fileName = type == "CV" ? '$type - $bsNum.pdf' : '$type $bsNum.pdf';
      //String fileName = type == "CV" ? '$type - 1721027.pdf' : '$type 1721027.pdf';

    final requestData = {
        'bs_id': bsId, //TODO change bs id
        'name_report': fileName,
      };

      final result = await client.callKw({
        'model': 'bulletin.soin',
        'method': 'get_bs_doc',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 60));

      // Debugging output to check the response type
      print('Result from Odoo: $result');

      // Validate the response and its types
      if (result != null && result['datas'] != null && result['datas'] is String) {
        // extract and decode the file content from the response
        String fileData = result['datas'];
        List<int> fileBytes = base64.decode(fileData); // decode base64 to get binary file content

        Directory? directory;
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 30) {
            directory = await getExternalStorageDirectory();
            String path = directory?.path.split('Android').first ?? '';
            directory = Directory('$path/Download');
          } else {
            directory = await getExternalStorageDirectory();
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        // Ensure the directory path is valid
        if (directory == null) {
          throw Exception('Unable to determine the directory path');
        }

        String filePath = '${directory.path}/$fileName';

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
