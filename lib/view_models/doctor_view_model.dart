import 'dart:convert';

import 'package:flutter/material.dart' hide Key;
import 'package:odoo_rpc/odoo_rpc.dart';

import '../helper/config.dart';
import '../models/responses/doctor/details_doctor_reponse.dart';
import '../models/responses/doctor/list_doctors_response.dart';

class DoctorViewModel with ChangeNotifier {
  OdooClient client = OdooClient(AppConfig.serverUrl);
  // String dbName='gras_savoye';
  String dbName='backoffice_Gras_2';

  Future<ListDoctorsResponse> getDoctors(int page, int pageSize,String dbName)  async {

    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword).timeout(const Duration(seconds: 30));
      final requestData = {
        'page': page,
        'page_size': pageSize,
      };
      print(client.httpClient);
      final result = await client.callKw({
        'model': 'hms.physician',
        'method': 'get_physician_list',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 60));



      final doctorResponse = ListDoctorsResponse.fromJson(result['result']);

      print('this is the get doctors result :'+result['result']);
      return doctorResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListDoctorsResponse(resCode: -1, doctors: [], totalPages: 0, totalCount: 0);
    }


  }

  Future<ListDoctorsResponse> searchDoctors(String docName, int page, int pageSize) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      final requestData = {
        'page': page,
        'page_size': pageSize,
        'name': docName,
      };
      final result = await client.callKw({
        'model': 'hms.physician',
        'method': 'search_physicians_by_name',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      // final result = {
      //   "jsonrpc": "2.0",
      //   "id": null,
      //   "result": {
      //     "res_code": "1",
      //     "physician_list": [
      //       {
      //         "doc_id": 1,
      //         "name": "Dr salah",
      //         "speciality": "generalist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "Drsalah@salah.com",
      //         "image": false
      //       },
      //       {
      //         "doc_id": 2,
      //         "name": "Dr foulen",
      //         "speciality": "Dentist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "Foulen@Dr.com",
      //         "image": false
      //       },
      //       {
      //         "doc_id": 3,
      //         "name": "Dr someone",
      //         "speciality": "specialist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "specialist@Dr.com",
      //         "image": false
      //       },
      //       {
      //         "doc_id": 4,
      //         "name": "Dr mohamed",
      //         "speciality": "generalist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "mohamed@Dr.com",
      //         "image": false
      //       },
      //       {
      //         "doc_id": 5,
      //         "name": "Dr salem",
      //         "speciality": "Dentist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "Salem@Dr.com",
      //         "image": false
      //       }
      //     ],
      //     "total_pages": 1,
      //     "total_count": 5,
      //     "headers": {
      //       "Access-Control-Allow-Origin": "*"
      //     }
      //   }
      // };

      final doctorResponse = ListDoctorsResponse.fromJson(result);

      return doctorResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListDoctorsResponse(resCode: -1, doctors: [], totalPages: 0, totalCount: 0);
    }
  }

  Future<ListDoctorsResponse> filterDoctors(String region, String specialty, int page, int pageSize) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      final requestData = {
        'page': page,
        'page_size': pageSize,
        'region': region,
        'specialty': specialty,
      };
      final result = await client.callKw({
        'model': 'hms.physician',
        'method': 'filter_physicians',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      // final result = {
      //   "jsonrpc": "2.0",
      //   "id": null,
      //   "result": {
      //     "res_code": "1",
      //     "physician_list": [
      //       {
      //         "doc_id": 1,
      //         "name": "Dr salah",
      //         "speciality": "generalist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "Drsalah@salah.com",
      //         "image": false
      //       },
      //       {
      //         "doc_id": 2,
      //         "name": "Dr foulen",
      //         "speciality": "Dentist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "Foulen@Dr.com",
      //         "image": false
      //       },
      //       {
      //         "doc_id": 3,
      //         "name": "Dr someone",
      //         "speciality": "specialist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "specialist@Dr.com",
      //         "image": false
      //       },
      //       {
      //         "doc_id": 4,
      //         "name": "Dr mohamed",
      //         "speciality": "generalist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "mohamed@Dr.com",
      //         "image": false
      //       },
      //       {
      //         "doc_id": 5,
      //         "name": "Dr salem",
      //         "speciality": "Dentist",
      //         "state": false,
      //         "delegation": false,
      //         "latitude": false,
      //         "longitude": false,
      //         "phone": false,
      //         "email": "Salem@Dr.com",
      //         "image": false
      //       }
      //     ],
      //     "total_pages": 1,
      //     "total_count": 5,
      //     "headers": {
      //       "Access-Control-Allow-Origin": "*"
      //     }
      //   }
      // };


      // final doctorResponse = ListDoctorsResponse.fromJson(result['result']);
      final doctorResponse = ListDoctorsResponse.fromJson(result);

      return doctorResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListDoctorsResponse(resCode: -1, doctors: [], totalPages: 0, totalCount: 0);
    }
  }


  Future<DetailsDoctorResponse> getDoctorDetails(int physicianId) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      final requestData = {
        'id': physicianId,
      };
      final result = await client.callKw({
        'model': 'hms.physician',
        'method': 'get_physician_details',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));

      final doctorDetailsResponse = DetailsDoctorResponse.fromJson(result['result']);
      return doctorDetailsResponse;
    } catch (e) {
      print("Error fetching physician details: $e");
      return DetailsDoctorResponse(resCode: -1, doctor: null,);
    }
    // try {
    //
    // String jsonResponse = '''
    //   {
    //     "jsonrpc": "2.0",
    //     "id": null,
    //     "result": {
    //       "res_code": "1",
    //       "physician_details": {
    //         "doc_id": 19,
    //         "name": "MARRAKCHI OLFA",
    //         "speciality": "LABO. D'ANALYSES MEDICALES",
    //         "state": "Tunis",
    //         "delegation": "Kram",
    //         "latitude": 36.8330743,
    //         "longitude": 10.3140234,
    //         "phone": "12345678",
    //         "email": "imen@test.com",
    //         "image": "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"
    //       }
    //     }
    //   }
    // ''';
    //
    //   // Parse JSON response
    //   Map<String, dynamic> result = jsonDecode(jsonResponse);
    //
    //   // Deserialize JSON into your model
    //   final doctorDetailsResponse =
    //   DetailsDoctorResponse.fromJson(result['result']);
    //   // DetailsDoctorResponse.fromJson(result['result']);
    //
    //
    //   return doctorDetailsResponse;
    // } catch (e) {
    //   print("Error fetching physician details: $e");
    //   return DetailsDoctorResponse(resCode: -1, doctor: null);
    // }
  }
}
