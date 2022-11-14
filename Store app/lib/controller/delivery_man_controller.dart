import 'dart:typed_data';

import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/delivery_man_model.dart';
import 'package:sixam_mart_store/data/model/response/review_model.dart';
import 'package:sixam_mart_store/data/repository/delivery_man_repo.dart';
import 'package:sixam_mart_store/helper/network_info.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DeliveryManController extends GetxController implements GetxService {
  final DeliveryManRepo deliveryManRepo;
  DeliveryManController({@required this.deliveryManRepo});

  List<DeliveryManModel> _deliveryManList;
  Uint8List _pickedImage;
  List<Uint8List> _pickedIdentities = [];
  List<String> _identityTypeList = ['passport', 'driving_license', 'nid'];
  int _identityTypeIndex = 0;
  bool _isLoading = false;
  List<ReviewModel> _dmReviewList;
  bool _isSuspended = false;

  List<DeliveryManModel> get deliveryManList => _deliveryManList;
  Uint8List get pickedImage => _pickedImage;
  List<Uint8List> get pickedIdentities => _pickedIdentities;
  List<String> get identityTypeList => _identityTypeList;
  int get identityTypeIndex => _identityTypeIndex;
  bool get isLoading => _isLoading;
  List<ReviewModel> get dmReviewList => _dmReviewList;
  bool get isSuspended => _isSuspended;

  Future<void> getDeliveryManList() async {
    Response response = await deliveryManRepo.getDeliveryManList();
    if(response.statusCode == 200) {
      _deliveryManList = [];
      response.body.forEach((deliveryMan) => _deliveryManList.add(DeliveryManModel.fromJson(deliveryMan)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> addDeliveryMan(DeliveryManModel deliveryMan, String pass, String token, bool isAdd) async {
    _isLoading = true;
    update();
    Response response = await deliveryManRepo.addDeliveryMan(deliveryMan, pass, _pickedImage, _pickedIdentities, token, isAdd);
    if(response.statusCode == 200) {
      Get.back();
      showCustomSnackBar(isAdd ? 'delivery_man_added_successfully'.tr : 'delivery_man_updated_successfully'.tr, isError: false);
      getDeliveryManList();
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteDeliveryMan(int deliveryManID) async {
    _isLoading = true;
    update();
    Response response = await deliveryManRepo.deleteDeliveryMan(deliveryManID);
    if(response.statusCode == 200) {
      Get.back();
      showCustomSnackBar('delivery_man_deleted_successfully'.tr, isError: false);
      getDeliveryManList();
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void setSuspended(bool isSuspended) {
    _isSuspended = isSuspended;
  }

  void toggleSuspension(int deliveryManID) async {
    _isLoading = true;
    update();
    Response response = await deliveryManRepo.updateDeliveryManStatus(deliveryManID, _isSuspended ? 1 : 0);
    if(response.statusCode == 200) {
      Get.back();
      getDeliveryManList();
      showCustomSnackBar(
        _isSuspended ? 'delivery_man_unsuspended_successfully'.tr : 'delivery_man_suspended_successfully'.tr, isError: false,
      );
      _isSuspended = !_isSuspended;
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getDeliveryManReviewList(int deliveryManID) async {
    _dmReviewList = null;
    Response response = await deliveryManRepo.getDeliveryManReviews(deliveryManID);
    if(response.statusCode == 200) {
      _dmReviewList = [];
      response.body['reviews'].forEach((review) => _dmReviewList.add(ReviewModel.fromJson(review)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setIdentityTypeIndex(String identityType, bool notify) {
    int _index = 0;
    for(int index=0; index<_identityTypeList.length; index++) {
      if(_identityTypeList[index] == identityType) {
        _index = index;
        break;
      }
    }
    _identityTypeIndex = _index;
    if(notify) {
      update();
    }
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    }else {
      if (isLogo) {
        XFile _picked = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(_picked != null) {
          _pickedImage = await NetworkInfo.compressImage(_picked);
        }
      } else {
        XFile _xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(_xFile != null) {
          _pickedIdentities.add(await NetworkInfo.compressImage(_xFile));
        }
      }
      update();
    }
  }

  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    update();
  }

}