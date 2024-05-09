import 'dart:async';
import 'package:healio/models/responses/user/get_profile_response.dart';
import 'package:healio/models/responses/user/login_response.dart';
import 'package:healio/models/responses/user/forgot_pwd_response.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/config.dart';
import '../helper/providers/tab_provider.dart';
import '../views/auth/sign_in_screen.dart';

class UserViewModel with ChangeNotifier {

  OdooClient client = OdooClient(AppConfig.serverUrl);
  String dbName='backoffice_Gras_2';

  Future<LoginResponse> signIn(String login, String password) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      final requestData = {
        'db_name':'Gras Savoye', //Wecover  -- Gras Savoye
        'login': login.toLowerCase().trim(),
        'password': encrypt(password.trim()),
      };
      final result = await client.callKw({
        'model': 'res.users',
        'method': 'get_user_account',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));
      final jsonResponse = result;
      final loginResponse = LoginResponse.fromJson(jsonResponse);
      return loginResponse;
    } on OdooException catch (e) {
      print("Error during sign in: $e");
      return LoginResponse(res_code: -1);
    }
    catch (e){
      print("Error during sign in: $e");
      return LoginResponse(res_code: -1);
    }
  }

  Future<ForgotPwdResponse> forgotPwd(String login) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      final requestData = {
        'db_name':'Gras Savoye', //Wecover  -- Gras Savoye
        'login': login.toLowerCase().trim(),
      };
      final result = await client.callKw({
        'model': 'res.users',
        'method': 'reset_password_mobile',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));

      final jsonResponse = result;
      final resetPwdResponse = ForgotPwdResponse.fromJson(jsonResponse);
      return resetPwdResponse;
    } on OdooException catch (e) {
      print("Error during reset pwd: $e");
      return ForgotPwdResponse(res_code: -1);
    }
    catch (e){
      print("Error during reset pwd: $e");
      return ForgotPwdResponse(res_code: -1);
    }
  }

  Future<GetProfileResponse> getProfile(int userId) async {
    try {
      await client.authenticate(
          dbName, AppConfig.dbUsername, AppConfig.dbPassword);
      final requestData = {
        'adherent_id': userId,
      };
      final result = await client.callKw({
        'model': 'res.users',
        'method': 'get_profile',
        'args': [requestData],
        'kwargs': {},
      }).timeout(const Duration(seconds: 20));

      final jsonResponse = result;
      final getProfileResponse = GetProfileResponse.fromJson(jsonResponse);

      return getProfileResponse;
    }  on OdooException catch (e) {
      print("error $e");
      //client.close();
      return GetProfileResponse(res_code: -1);
    }
  }

  String encrypt(String pwd) {
    const base64Key = 'qkdHk49RaQxsWEEkCn/g9MYurnYvK5msGQCVHMaYqJE=';
    final key = Key.fromBase64(base64Key);
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final encrypted = encrypter.encrypt(pwd);
    return encrypted.base64;
  }

  void performLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SignInScreen();
        },
      ),
          (_) => false,
    );
    final tabProvider = Provider.of<TabProvider>(context, listen: false);
    tabProvider.setTab(0);
  }



}
