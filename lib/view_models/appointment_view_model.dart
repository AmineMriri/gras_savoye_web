import 'package:flutter/material.dart' hide Key;
import 'package:healio/models/responses/appointment/av_dates_response.dart';
import 'package:healio/models/responses/appointment/av_time_slots_response.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../models/responses/appointment/book_apt_reponse.dart';
import '../models/responses/doctor/details_doctor_reponse.dart';
import '../models/responses/doctor/list_doctors_response.dart';

class AppointmentViewModel with ChangeNotifier {
  OdooClient clientLocal = OdooClient('http://192.168.1.14:8069/');

  Future<AvDatesResponse> getAvailableDatesForPhysician(int physicianId) async {
    try {
      await clientLocal.authenticate('odoo_test', 'admin', 'admin');
      final requestData = {
        'physician_id': physicianId,
      };
      final result = await clientLocal.callKw({
        'model': 'hms.schedule',
        'method': 'get_available_dates_for_physician',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final avDatesResponse = AvDatesResponse.fromJson(result);
      return avDatesResponse;
    } catch (e) {
      print("Error fetching available dates: $e");
      return AvDatesResponse(resCode: -1, dates: []);
    }
  }

  Future<AvTimeSlotsResponse> getAvailableTimeSlots(int physicianId, DateTime date) async {
    try {
      await clientLocal.authenticate('odoo_test', 'admin', 'admin');
      final requestData = {
        'physician_id': physicianId,
        'date_str': date.toString(),
      };
      final result = await clientLocal.callKw({
        'model': 'hms.schedule',
        'method': 'get_available_time_slots',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final avTimeSlotsResponse = AvTimeSlotsResponse.fromJson(result);
      return avTimeSlotsResponse;
    } catch (e) {
      print("Error fetching available time slots: $e");
      return AvTimeSlotsResponse(resCode: -1, slots: []);
    }
  }

  Future<BookAptResponse> bookApt(int docId, String patient, DateTime date, String motif) async {
    try {
      await clientLocal.authenticate('odoo_test', 'admin', 'admin');
      final requestData = {
        'doc_id': docId,
        'patient': patient,
        'date': date,
        'motif': motif,
      };
      print(requestData);
      final result = await clientLocal.callKw({
        'model': 'hms.appointment',
        'method': 'book_apt',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final aptResponse = BookAptResponse.fromJson(result);
      return aptResponse;
    } catch (e) {
      print("Error booking appointment: $e");
      return BookAptResponse(resCode: -1, appointment: null,);
    }
  }
}
