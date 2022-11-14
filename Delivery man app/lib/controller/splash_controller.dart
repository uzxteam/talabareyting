import 'package:sixam_mart_delivery/data/api/api_checker.dart';
import 'package:sixam_mart_delivery/data/model/response/config_model.dart';
import 'package:sixam_mart_delivery/data/repository/splash_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({@required this.splashRepo});

  ConfigModel _configModel;
  bool _firstTimeConnectionCheck = true;
  int _storeCategoryID;
  String _storeType;
  Map<String, dynamic> _data = Map();
  String _htmlText;

  ConfigModel get configModel => _configModel;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  int get storeCategoryID => _storeCategoryID;
  String get storeType => _storeType;
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

  Module getModule(String moduleType) => Module.fromJson(_data['module_config'][moduleType]);

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

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