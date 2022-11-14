import 'dart:async';
import 'dart:typed_data';
import 'package:sixam_mart_delivery/data/model/body/record_location_body.dart';

import 'package:sixam_mart_delivery/data/api/api_client.dart';
import 'package:sixam_mart_delivery/data/model/response/profile_model.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> login(String phone, String password) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, {"phone": phone, "password": password});
  }

  Future<Response> getProfileInfo() async {
    return await apiClient.getData(AppConstants.PROFILE_URI + getUserToken());
  }

  Future<Response> recordLocation(RecordLocationBody recordLocationBody) {
    recordLocationBody.token = getUserToken();
    return apiClient.postData(AppConstants.RECORD_LOCATION_URI, recordLocationBody.toJson());
  }

  Future<Response> updateProfile(ProfileModel userInfoModel, Uint8List data, String token) async {
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName, 'l_name': userInfoModel.lName,
      'email': userInfoModel.email, 'token': getUserToken()
    });
    return await apiClient.postMultipartData(AppConstants.UPDATE_PROFILE_URI, _fields, [MultipartBody('image', data)]);
  }

  Future<Response> changePassword(ProfileModel userInfoModel, String password) async {
    return await apiClient.postData(AppConstants.UPDATE_PROFILE_URI, {'_method': 'put', 'f_name': userInfoModel.fName,
      'l_name': userInfoModel.lName, 'email': userInfoModel.email, 'password': password, 'token': getUserToken()});
  }

  Future<Response> updateActiveStatus() async {
    return await apiClient.postData(AppConstants.ACTIVE_STATUS_URI, {'token': getUserToken()});
  }

  Future<Response> updateToken() async {
    String _deviceToken;
    if (GetPlatform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
      }
    }else {
      _deviceToken = await _saveDeviceToken();
    }
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      FirebaseMessaging.instance.subscribeToTopic(sharedPreferences.getString(AppConstants.ZONE_TOPIC));
    }
    return await apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "token": getUserToken(), "fcm_token": _deviceToken});
  }

  Future<String> _saveDeviceToken() async {
    String _deviceToken = '';
    if(!GetPlatform.isWeb) {
      _deviceToken = await FirebaseMessaging.instance.getToken();
    }
    if (_deviceToken != null) {
      print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken;
  }

  Future<Response> forgetPassword(String phone) async {
    return await apiClient.postData(AppConstants.FORGET_PASSWORD_URI, {"phone": phone});
  }

  Future<Response> verifyToken(String phone, String token) async {
    return await apiClient.postData(AppConstants.VERIFY_TOKEN_URI, {"phone": phone, "reset_token": token});
  }

  Future<Response> resetPassword(String resetToken, String phone, String password, String confirmPassword) async {
    return await apiClient.postData(
      AppConstants.RESET_PASSWORD_URI,
      {"_method": "put", "phone": phone, "reset_token": resetToken, "password": password, "confirm_password": confirmPassword},
    );
  }

  Future<bool> saveUserToken(String token, String zoneTopic) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.LANGUAGE_CODE));
    sharedPreferences.setString(AppConstants.ZONE_TOPIC, zoneTopic);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    if(!GetPlatform.isWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
      FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.ZONE_TOPIC));
      apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "token": getUserToken(), "fcm_token": '@'});
    }
    await sharedPreferences.remove(AppConstants.TOKEN);
    await sharedPreferences.setStringList(AppConstants.IGNORE_LIST, []);
    await sharedPreferences.remove(AppConstants.USER_ADDRESS);
    apiClient.updateHeader(null, null);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      throw e;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
        FirebaseMessaging.instance.unsubscribeFromTopic(sharedPreferences.getString(AppConstants.ZONE_TOPIC));
      }
    }
    sharedPreferences.setBool(AppConstants.NOTIFICATION, isActive);
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }

  Future<Response> deleteDriver() async {
    return await apiClient.deleteData(AppConstants.DRIVER_REMOVE + getUserToken());
  }
}
