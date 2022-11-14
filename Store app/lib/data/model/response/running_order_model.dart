import 'package:sixam_mart_store/data/model/response/order_model.dart';
import 'package:flutter/material.dart';

class RunningOrderModel {
  String status;
  List<OrderModel> orderList;

  RunningOrderModel({@required this.status, @required this.orderList});
}