import 'dart:convert';
import 'dart:async';
import 'dart:io';
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

  Future<File> getBsDocument(int bsId, int bsNum, String type) async {
    try {
      await client.authenticate(
          'backoffice_Gras_2', 'testportail@test.com', '%ZmYcp^No~1`!7H01T');
      String fileName;
      if(type=="CV"){
        fileName='$type - $bsNum.pdf';
      }else{
        fileName='$type $bsNum.pdf';
      }
      final requestData = {
        'bs_id': bsId,
        'name_report': fileName,
        //'filename':fileName,
      };

      final result = await client.callKw({
        'model': 'bulletin.soin',
        'method': 'get_bs_doc',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));

      // Assuming 'result' contains the response from Odoo
      if (result != null && result['datas'] != null) {
        print(result);
        // Extract and decode the file content from the response
        String fileData = result['datas']; // Assuming 'data' contains the base64-encoded file content
        List<int> fileBytes = base64.decode(fileData); // Decode base64 to get binary file content

        // Define a file path to save the document
        String fileName = '${type}_${bsNum}_${bsId}.pdf'; // Example file name
        String filePath = '/storage/emulated/0/Download/$fileName';

        // Save the file to local storage
        File savedFile = await File(filePath).writeAsBytes(fileBytes);

        print('File saved successfully: $filePath');

        // Return the path to the saved file
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
