import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/body/bank_info_body.dart';
import 'package:sixam_mart_store/data/model/response/bank_repo.dart';
import 'package:sixam_mart_store/data/model/response/withdraw_model.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankController extends GetxController implements GetxService {
  final BankRepo bankRepo;
  BankController({@required this.bankRepo});

  bool _isLoading = false;
  List<WithdrawModel> _withdrawList;
  List<WithdrawModel> _allWithdrawList;
  double _pendingWithdraw = 0;
  double _withdrawn = 0;
  List<String> _statusList = ['All', 'Pending', 'Approved', 'Denied'];
  int _filterIndex = 0;

  bool get isLoading => _isLoading;
  List<WithdrawModel> get withdrawList => _withdrawList;
  double get pendingWithdraw => _pendingWithdraw;
  double get withdrawn => _withdrawn;
  List<String> get statusList => _statusList;
  int get filterIndex => _filterIndex;

  Future<void> updateBankInfo(BankInfoBody bankInfoBody) async {
    _isLoading = true;
    update();
    Response response = await bankRepo.updateBankInfo(bankInfoBody);
    if(response.statusCode == 200) {
     Get.find<AuthController>().getProfile();
     Get.back();
     showCustomSnackBar('bank_info_updated'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getWithdrawList() async {
    Response response = await bankRepo.getWithdrawList();
    if(response.statusCode == 200) {
      _withdrawList = [];
      _allWithdrawList = [];
      _pendingWithdraw = 0;
      _withdrawn = 0;
      response.body.forEach((withdraw) {
        WithdrawModel _withdrawModel = WithdrawModel.fromJson(withdraw);
        _withdrawList.add(_withdrawModel);
        _allWithdrawList.add(_withdrawModel);
        if(_withdrawModel.status == 'Pending') {
          _pendingWithdraw = _pendingWithdraw + _withdrawModel.amount;
        }else if(_withdrawModel.status == 'Approved') {
          _withdrawn = _withdrawn + _withdrawModel.amount;
        }
      });
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void filterWithdrawList(int index) {
    _filterIndex = index;
    _withdrawList = [];
    if(index == 0) {
      _withdrawList.addAll(_allWithdrawList);
    }else {
      _allWithdrawList.forEach((withdraw) {
        if(withdraw.status == _statusList[index]) {
          _withdrawList.add(withdraw);
        }
      });
    }
    update();
  }

  Future<void> requestWithdraw(String amount) async {
    _isLoading = true;
    update();
    Response response = await bankRepo.requestWithdraw(amount);
    if(response.statusCode == 200) {
      Get.back();
      getWithdrawList();
      Get.find<AuthController>().getProfile();
      showCustomSnackBar('request_sent_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

}