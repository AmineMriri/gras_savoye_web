import 'package:flutter/material.dart' hide Key;
import 'package:odoo_rpc/odoo_rpc.dart';

import '../models/responses/doctor/details_doctor_reponse.dart';
import '../models/responses/doctor/list_doctors_response.dart';

class DoctorViewModel with ChangeNotifier {
  OdooClient clientLocal = OdooClient('http://192.168.2.80:8069/');

  /*Future<ListDoctorsResponse> getDoctors(int page, int pageSize) async {
    try {
      await clientLocal.authenticate('odoo_test', 'admin', 'admin');
      final result = await clientLocal.callKw({
        'model': 'hms.physician',
        'method': 'get_physician_list',
        'args': [page, pageSize],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final doctorResponse = ListDoctorsResponse.fromJson(result);
      return doctorResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListDoctorsResponse(res_code: -1, doctors: []);
    }
  }*/


  Future<ListDoctorsResponse> getDoctors(int page, int pageSize) async {
    try {
      await clientLocal.authenticate('odoo_test', 'admin', 'admin');
      final requestData = {
        'page': page,
        'page_size': pageSize,
      };
      print(requestData);
      final result = await clientLocal.callKw({
        'model': 'hms.physician',
        'method': 'get_physician_list',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      print('API Response: $result');
      final doctorResponse = ListDoctorsResponse.fromJson(result);
      return doctorResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListDoctorsResponse(resCode: -1, doctors: [], totalPages: 0, totalCount: 0);
    }
  }

  Future<ListDoctorsResponse> searchDoctors(String docName, int page, int pageSize) async {
    try {
      await clientLocal.authenticate(
          'odoo_test', 'admin', 'admin');
      final requestData = {
        'page': page,
        'page_size': pageSize,
        'name': docName,
      };
      final result = await clientLocal.callKw({
        'model': 'hms.physician',
        'method': 'search_physicians_by_name',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      print('API Response: $result');
      final doctorResponse = ListDoctorsResponse.fromJson(result);
      return doctorResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListDoctorsResponse(resCode: -1, doctors: [], totalPages: 0, totalCount: 0);
    }
  }

  Future<ListDoctorsResponse> filterDoctors(String region, String specialty, int page, int pageSize) async {
    try {
      await clientLocal.authenticate(
          'odoo_test', 'admin', 'admin');
      final requestData = {
        'page': page,
        'page_size': pageSize,
        'region': region,
        'specialty': specialty,
      };
      final result = await clientLocal.callKw({
        'model': 'hms.physician',
        'method': 'filter_physicians',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      print('API Response: $result');
      final doctorResponse = ListDoctorsResponse.fromJson(result);
      return doctorResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListDoctorsResponse(resCode: -1, doctors: [], totalPages: 0, totalCount: 0);
    }
  }


  Future<DetailsDoctorResponse> getDoctorDetails(int physicianId) async {
    try {
      final requestData = {
        'id': physicianId,
      };
      final result = await clientLocal.callKw({
        'model': 'hms.physician',
        'method': 'get_physician_details',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final doctorDetailsResponse = DetailsDoctorResponse.fromJson(result);
      return doctorDetailsResponse;
    } catch (e) {
      print("Error fetching physician details: $e");
      return DetailsDoctorResponse(resCode: -1, doctor: null,);
    }
  }
}
