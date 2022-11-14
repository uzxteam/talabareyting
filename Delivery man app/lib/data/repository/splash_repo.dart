import 'package:sixam_mart_delivery/data/api/api_client.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({@required this.sharedPreferences, @required this.apiClient});

  Future<Response> getConfigData() async {
    Response _response = await apiClient.getData(AppConstants.CONFIG_URI);
    return _response;
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences.setString(AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.NOTIFICATION)) {
      return sharedPreferences.setBool(AppConstants.NOTIFICATION, true);
    }
    if(!sharedPreferences.containsKey(AppConstants.NOTIFICATION_COUNT)) {
      sharedPreferences.setInt(AppConstants.NOTIFICATION_COUNT, 0);
    }
    if(!sharedPreferences.containsKey(AppConstants.IGNORE_LIST)) {
      sharedPreferences.setStringList(AppConstants.IGNORE_LIST, []);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  Future<Response> getHtmlText(bool isPrivacyPolicy) async {
    return await apiClient.getData(
      isPrivacyPolicy ? AppConstants.PRIVACY_POLICY_URI : AppConstants.TERMS_AND_CONDITIONS_URI,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'moduleId': ''
      },
    );
  }

}