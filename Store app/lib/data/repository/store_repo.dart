import 'dart:convert';
import 'dart:typed_data';

import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreRepo {
  final ApiClient apiClient;
  StoreRepo({@required this.apiClient});

  Future<Response> getItemList(String offset, String type) async {
    return await apiClient.getData('${AppConstants.ITEM_LIST_URI}?offset=$offset&limit=10&type=$type');
  }

  Future<Response> getAttributeList() async {
    return apiClient.getData(AppConstants.ATTRIBUTE_URI);
  }

  Future<Response> getCategoryList() async {
    return await apiClient.getData(AppConstants.CATEGORY_URI);
  }

  Future<Response> getSubCategoryList(int parentID) async {
    return await apiClient.getData('${AppConstants.SUB_CATEGORY_URI}$parentID');
  }

  Future<Response> updateStore(Store store, Uint8List logo, Uint8List cover, String min, String max, String type) async {
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      '_method': 'put', 'name': store.name, 'contact_number': store.phone, 'schedule_order': store.scheduleOrder ? '1' : '0',
      'address': store.address, 'minimum_order': store.minimumOrder.toString(), 'delivery': store.delivery ? '1' : '0',
      'take_away': store.takeAway ? '1' : '0', 'gst_status': store.gstStatus ? '1' : '0', 'gst': store.gstCode,
      'delivery_charge': store.deliveryCharge.toString(), 'veg': store.veg.toString(), 'non_veg': store.nonVeg.toString(),
      'order_place_to_schedule_interval': store.orderPlaceToScheduleInterval.toString(), 'minimum_delivery_time': min,
      'maximum_delivery_time': max, 'delivery_time_type': type,
    });
    return apiClient.postMultipartData(
      AppConstants.VENDOR_UPDATE_URI, _fields, [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)],
    );
  }

  Future<Response> addItem(Item item, Uint8List image, List<Uint8List> images, List<String> savedImages, Map<String, String> attributes, bool isAdd) async {
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'price': item.price.toString(), 'discount': item.discount.toString(), 'veg': item.veg.toString(),
      'discount_type': item.discountType, 'category_id': item.categoryIds[0].id,
      'translations': jsonEncode(item.translations),
    });
    if(Get.find<SplashController>().configModel.moduleConfig.module.stock) {
      _fields.addAll((<String, String> {'current_stock': item.stock.toString()}));
    }
    if(Get.find<SplashController>().configModel.moduleConfig.module.unit) {
      _fields.addAll((<String, String> {'unit': item.unitType}));
    }
    if(Get.find<SplashController>().configModel.moduleConfig.module.itemAvailableTime) {
      _fields.addAll((<String, String> {'available_time_starts': item.availableTimeStarts, 'available_time_ends': item.availableTimeEnds}));
    }
    String _addon = '';
    for(int index=0; index<item.addOns.length; index++) {
      _addon = _addon + '${index == 0 ? item.addOns[index].id : ',${item.addOns[index].id}'}';
    }
    _fields.addAll(<String, String> {'addon_ids': _addon});
    if(item.categoryIds.length > 1) {
      _fields.addAll(<String, String> {'sub_category_id': item.categoryIds[1].id});
    }
    if(!isAdd) {
      _fields.addAll(<String, String> {'_method': 'put', 'id': item.id.toString(), 'images': jsonEncode(savedImages)});
    }
    if(attributes.length > 0) {
      _fields.addAll(attributes);
    }
    List<MultipartBody> _images = [];
    _images.add(MultipartBody('image', image));
    for(int index=0; index<images.length; index++) {
      _images.add(MultipartBody('item_images[]', images[index]));
    }
    return apiClient.postMultipartData(
      isAdd ? AppConstants.ADD_ITEM_URI : AppConstants.UPDATE_ITEM_URI, _fields,_images,
    );
  }

  Future<Response> deleteItem(int itemID) async {
    return await apiClient.deleteData('${AppConstants.DELETE_ITEM_URI}?id=$itemID');
  }

  Future<Response> getStoreReviewList(int storeID) async {
    return await apiClient.getData('${AppConstants.VENDOR_REVIEW_URI}?store_id=$storeID');
  }

  Future<Response> getItemReviewList(int itemID) async {
    return await apiClient.getData('${AppConstants.ITEM_REVIEW_URI}/$itemID');
  }

  Future<Response> updateItemStatus(int itemID, int status) async {
    return await apiClient.getData('${AppConstants.UPDATE_ITEM_STATUS_URI}?id=$itemID&status=$status');
  }

  Future<Response> addSchedule(Schedules schedule) async {
    return await apiClient.postData(AppConstants.ADD_SCHEDULE, schedule.toJson());
  }

  Future<Response> deleteSchedule(int scheduleID) async {
    return await apiClient.deleteData('${AppConstants.DELETE_SCHEDULE}$scheduleID');
  }

  Future<Response> getUnitList() async {
    return await apiClient.getData(AppConstants.UNIT_LIST_URI);
  }

}