import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocalizationController({@required this.sharedPreferences, @required this.apiClient}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  int _selectedIndex = 0;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get selectedIndex => _selectedIndex;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    if(_locale.languageCode == 'ar') {
      _isLtr = false;
    }else {
      _isLtr = true;
    }
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.TOKEN), locale.languageCode,
      Get.find<AuthController>().profileModel != null ? Get.find<AuthController>().profileModel.stores[0].module.id : null,
    );
    saveLanguage(_locale);
    Get.find<StoreController>().getItemList('1', 'all');
    update();
  }

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ?? AppConstants.languages[0].languageCode,
        sharedPreferences.getString(AppConstants.COUNTRY_CODE) ?? AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    for(int index = 0; index < AppConstants.languages.length; index++) {
      if(_locale.languageCode == AppConstants.languages[index].languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(AppConstants.COUNTRY_CODE, locale.countryCode);
  }
}