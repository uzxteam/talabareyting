import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/repository/splash_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({@required this.splashRepo});

  ConfigModel _configModel;
  DateTime _currentTime = DateTime.now();
  bool _firstTimeConnectionCheck = true;
  int _moduleID;
  String _moduleType;
  Map<String, dynamic> _data = Map();
  String _htmlText;

  ConfigModel get configModel => _configModel;
  DateTime get currentTime => _currentTime;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  int get moduleID => _moduleID;
  String get moduleType => _moduleType;
  String get htmlText => _htmlText;

  Future<bool> getConfigData() async {
    Response response = await splashRepo.getConfigData();
    bool _isSuccess = false;
    if(response.statusCode == 200) {
      _data = response.body;
      _configModel = ConfigModel.fromJson(response.body);
      _isSuccess = true;
    }else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    update();
    return _isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  bool showIntro() {
    return splashRepo.showIntro();
  }

  void setIntro(bool intro) {
    splashRepo.setIntro(intro);
  }

  bool isRestaurantClosed() {
    DateTime _open = DateFormat('hh:mm').parse('');
    DateTime _close = DateFormat('hh:mm').parse('');
    DateTime _openTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _open.hour, _open.minute);
    DateTime _closeTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _close.hour, _close.minute);
    if(_closeTime.isBefore(_openTime)) {
      _closeTime = _closeTime.add(Duration(days: 1));
    }
    if(_currentTime.isAfter(_openTime) && _currentTime.isBefore(_closeTime)) {
      return false;
    }else {
      return true;
    }
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  Future<void> setModule(int moduleID, String moduleType) async {
    _moduleID = moduleID;
    _moduleType = moduleType;
    if(moduleType != null) {
      _configModel.moduleConfig.module = Module.fromJson(_data['module_config'][moduleType]);
      print('-------${_configModel.moduleConfig.module.toJson()}');
    }
    update();
  }

  Module getModule(String moduleType) => Module.fromJson(_data['module_config'][moduleType]);

  Future<void> getHtmlText(bool isPrivacyPolicy) async {
    _htmlText = null;
    Response response = await splashRepo.getHtmlText(isPrivacyPolicy);
    if (response.statusCode == 200) {
      _htmlText = response.body;
      if(_htmlText != null && _htmlText.isNotEmpty) {
        _htmlText = _htmlText.replaceAll('href=', 'target="_blank" href=');
      }else {
        _htmlText = '';
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

}