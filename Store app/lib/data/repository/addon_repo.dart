import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class AddonRepo {
  final ApiClient apiClient;
  AddonRepo({@required this.apiClient});

  Future<Response> getAddonList() {
    return apiClient.getData(AppConstants.ADDON_URI);
  }

  Future<Response> addAddon(AddOns addonModel) {
    return apiClient.postData(AppConstants.ADD_ADDON_URI, addonModel.toJson());
  }

  Future<Response> updateAddon(AddOns addonModel) {
    return apiClient.putData(AppConstants.UPDATE_ADDON_URI, addonModel.toJson());
  }

  Future<Response> deleteAddon(int addonID) {
    return apiClient.deleteData(AppConstants.DELETE_ADDON_URI+'?id=$addonID');
  }

}