import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/body/bank_info_body.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class BankRepo {
  final ApiClient apiClient;
  BankRepo({@required this.apiClient});
  
  Future<Response> updateBankInfo(BankInfoBody bankInfoBody) async {
    return await apiClient.putData(AppConstants.UPDATE_BANK_INFO_URI, bankInfoBody.toJson());
  }

  Future<Response> getWithdrawList() async {
    return await apiClient.getData(AppConstants.WITHDRAW_LIST_URI);
  }

  Future<Response> requestWithdraw(String amount) async {
    return await apiClient.postData(AppConstants.WITHDRAW_REQUEST_URI, {'amount': amount});
  }

}