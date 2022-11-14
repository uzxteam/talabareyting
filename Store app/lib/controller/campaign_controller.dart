import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/campaign_model.dart';
import 'package:sixam_mart_store/data/repository/campaign_repo.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignController extends GetxController implements GetxService {
  final CampaignRepo campaignRepo;
  CampaignController({@required this.campaignRepo});

  List<CampaignModel> _campaignList;
  List<CampaignModel> _allCampaignList;
  bool _isLoading = false;

  List<CampaignModel> get campaignList => _campaignList;
  bool get isLoading => _isLoading;

  Future<void> getCampaignList() async {
    Response response = await campaignRepo.getCampaignList();
    if(response.statusCode == 200) {
      _campaignList = [];
      _allCampaignList = [];
      response.body.forEach((campaign) {
        _campaignList.add(CampaignModel.fromJson(campaign));
        _allCampaignList.add(CampaignModel.fromJson(campaign));
      });
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void filterCampaign(String status) {
    _campaignList = [];
    if(status == 'joined') {
      _allCampaignList.forEach((campaign) {
        if(campaign.isJoined) {
          _campaignList.add(campaign);
        }
      });
    }else {
      _campaignList.addAll(_allCampaignList);
    }
    update();
  }

  Future<void> joinCampaign(int campaignID, bool fromDetails) async {
    _isLoading = true;
    update();
    Response response = await campaignRepo.joinCampaign(campaignID);
    Get.back();
    if(response.statusCode == 200) {
      if(fromDetails) {
        Get.back();
      }
      showCustomSnackBar('successfully_joined'.tr, isError: false);
      getCampaignList();
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> leaveCampaign(int campaignID, bool fromDetails) async {
    _isLoading = true;
    update();
    Response response = await campaignRepo.leaveCampaign(campaignID);
    Get.back();
    if(response.statusCode == 200) {
      if(fromDetails) {
        Get.back();
      }
      showCustomSnackBar('successfully_leave'.tr, isError: false);
      getCampaignList();
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

}