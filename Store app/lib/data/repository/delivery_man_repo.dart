import 'dart:typed_data';

import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/response/delivery_man_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryManRepo {
  final ApiClient apiClient;
  DeliveryManRepo({@required this.apiClient});
  
  Future<Response> getDeliveryManList() async {
    return await apiClient.getData(AppConstants.DM_LIST_URI);
  }

  Future<Response> addDeliveryMan(DeliveryManModel deliveryMan, String pass, Uint8List image, List<Uint8List> identities, String token, bool isAdd) async {
    List<MultipartBody> _imageList = [];
    _imageList.add(MultipartBody('image', image));
    for(int index=0; index<identities.length; index++) {
      _imageList.add(MultipartBody('identity_image[]', identities[index]));
    }
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'f_name': deliveryMan.fName, 'l_name': deliveryMan.lName, 'email': deliveryMan.email, 'password': pass,
      'phone': deliveryMan.phone, 'identity_type': deliveryMan.identityType, 'identity_number': deliveryMan.identityNumber,
    });
    return apiClient.postMultipartData(
      isAdd ? AppConstants.ADD_DM_URI : '${AppConstants.UPDATE_DM_URI}${deliveryMan.id}', _fields, _imageList,
    );
  }

  Future<Response> updateDeliveryMan(DeliveryManModel deliveryManModel) async {
    return await apiClient.postData('${AppConstants.UPDATE_DM_URI}${deliveryManModel.id}', deliveryManModel.toJson());
  }

  Future<Response> deleteDeliveryMan(int deliveryManID) async {
    return await apiClient.postData(AppConstants.DELETE_DM_URI, {'_method': 'delete', 'delivery_man_id': deliveryManID});
  }

  Future<Response> updateDeliveryManStatus(int deliveryManID, int status) async {
    return await apiClient.getData('${AppConstants.UPDATE_DM_STATUS_URI}?delivery_man_id=$deliveryManID&status=$status');
  }

  Future<Response> getDeliveryManReviews(int deliveryManID) async {
    return await apiClient.getData('${AppConstants.DM_REVIEW_URI}?delivery_man_id=$deliveryManID');
  }

}