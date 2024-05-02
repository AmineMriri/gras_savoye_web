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

  Future<ListDoctorsResponse> getDoctors() async {
    try {
      await clientLocal.authenticate(
          'odoo_test', 'admin', 'admin');
      final result = await clientLocal.callKw({
        'model': 'hms.physician',
        'method': 'get_physician_list',
        'args': [],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final doctorResponse = ListDoctorsResponse.fromJson(result);
      return doctorResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListDoctorsResponse(res_code: -1, doctors: []);
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
