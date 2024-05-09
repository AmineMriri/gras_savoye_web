import 'package:flutter/material.dart' hide Key;
import 'package:healio/models/responses/appointment/av_dates_response.dart';
import 'package:healio/models/responses/appointment/av_time_slots_response.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../helper/config.dart';
import '../models/responses/appointment/book_apt_reponse.dart';
import '../models/responses/appointment/details_apt_reponse.dart';
import '../models/responses/appointment/list_apt_response.dart';

class AppointmentViewModel with ChangeNotifier {
  OdooClient clientLocal = OdooClient(AppConfig.localServerUrl);
  String dbName='odoo_test';

  Future<AvDatesResponse> getAvailableDatesForPhysician(int physicianId) async {
    try {
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
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
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
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

  Future<AptResponse> bookApt(int docId, String patient, DateTime date, String motif) async {
    try {
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
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
      final aptResponse = AptResponse.fromJson(result);
      return aptResponse;
    } catch (e) {
      print("Error booking appointment: $e");
      return AptResponse(resCode: -1, appointment: null,);
    }
  }

  Future<ListAptResponse> getAptByState(int userId, String state) async {
    try {
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
      final requestData = {
        'adherent_id': userId,
        'state':state
      };
      final result = await clientLocal.callKw({
        'model': 'hms.appointment',
        'method': 'get_apt_list_by_state',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final listAptResponse = ListAptResponse.fromJson(result);
      return listAptResponse;
    } catch (e) {
      print("Error fetching apts: $e");
      return ListAptResponse(resCode: -1, apts: []);
    }
  }

  Future<ListAptResponse> getPaginatedArchivedApts(int userId, int page, int pageSize) async {
    try {
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
      final requestData = {
        'page': page,
        'page_size': pageSize,
        'adherent_id': userId,
      };
      final result = await clientLocal.callKw({
        'model': 'hms.appointment',
        'method': 'get_apt_paginated_archive',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final listAptResponse = ListAptResponse.fromJson(result);
      return listAptResponse;
    } catch (e) {
      print("Error fetching doctors: $e");
      return ListAptResponse(resCode: -1, apts: [], totalPages: 0, totalCount: 0);
    }
  }

  Future<AptResponse> cancelApt(int aptId, String message,) async {
    try {
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
      final requestData = {
        'apt_id': aptId,
        'message':message
      };
      final result = await clientLocal.callKw({
        'model': 'hms.appointment',
        'method': 'cancel_apt',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final aptResponse = AptResponse.fromJson(result);
      return aptResponse;
    } catch (e) {
      print("Error canceling apts: $e");
      return AptResponse(resCode: -1, appointment: null,);
    }
  }

  Future<ListAptResponse> searchArchivedApt(int userId, String docName, int page, int pageSize) async {
    try {
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
      final requestData = {
        'user_id': userId,
        'page': page,
        'page_size': pageSize,
        'name': docName,
      };
      final result = await clientLocal.callKw({
        'model': 'hms.appointment',
        'method': 'search_archived_apts',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final listAptResponse = ListAptResponse.fromJson(result);
      return listAptResponse;
    } catch (e) {
      print("Error fetching apts: $e");
      return ListAptResponse(resCode: -1, apts: [], totalPages: 0, totalCount: 0);
    }
  }

  Future<ListAptResponse> filterArchivedApts(int userId, String specialty, String dateMin, String dateMax, int page, int pageSize) async {
    try {
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
      final requestData = {
        'user_id': userId,
        'page': page,
        'page_size': pageSize,
        'specialty': specialty,
        'dateMin': dateMin,
        'dateMax': dateMax,
      };
      final result = await clientLocal.callKw({
        'model': 'hms.appointment',
        'method': 'filter_archived_apts',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final listAptResponse = ListAptResponse.fromJson(result);
      return listAptResponse;
    } catch (e) {
      print("Error fetching apts: $e");
      return ListAptResponse(resCode: -1, apts: [], totalPages: 0, totalCount: 0);
    }
  }

  Future<DetailsAptResponse> getAptDetails(int aptId) async {
    try {
      await clientLocal.authenticate(
          dbName, AppConfig.localDbUsername, AppConfig.localDbPassword);
      final requestData = {
        'id': aptId,
      };
      final result = await clientLocal.callKw({
        'model': 'hms.appointment',
        'method': 'get_apt_details',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final detailsAptResponse = DetailsAptResponse.fromJson(result);
      return detailsAptResponse;
    } catch (e) {
      print("Error fetching physician details: $e");
      return DetailsAptResponse(resCode: -1, appointment: null,);
    }
  }
}
