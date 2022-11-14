import 'package:sixam_mart_store/data/api/api_client.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class PosRepo {
  final ApiClient apiClient;
  PosRepo({@required this.apiClient});

  Future<Response> searchItemList(String searchText) async {
    return await apiClient.postData(AppConstants.SEARCH_ITEM_LIST_URI, {'name': searchText});
  }

  Future<Response> searchCustomerList(String searchText) async {
    return await apiClient.getData('${AppConstants.SEARCH_CUSTOMERS_URI}?search=$searchText');
  }

  Future<Response> placeOrder(String searchText) async {
    return await apiClient.postData('${AppConstants.PLACE_ORDER_URI}', {});
  }

  Future<Response> getPosOrders() async {
    return await apiClient.getData('${AppConstants.POS_ORDERS_URI}');
  }

}