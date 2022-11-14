import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/body/update_status_body.dart';
import 'package:sixam_mart_store/data/model/response/order_details_model.dart';
import 'package:sixam_mart_store/data/model/response/order_model.dart';
import 'package:sixam_mart_store/data/model/response/running_order_model.dart';
import 'package:sixam_mart_store/data/repository/order_repo.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({@required this.orderRepo});

  List<OrderModel> _allOrderList;
  List<OrderModel> _orderList;
  List<OrderModel> _runningOrderList;
  List<RunningOrderModel> _runningOrders;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetailsModel;
  bool _isLoading = false;
  int _orderIndex = 0;
  bool _campaignOnly = false;
  String _otp = '';
  int _historyIndex = 0;
  List<String> _statusList = ['all', 'delivered', 'refunded'];
  bool _paginate = false;
  int _pageSize;
  List<int> _offsetList = [];
  int _offset = 1;
  String _orderType = 'all';

  List<OrderModel> get orderList => _orderList;
  List<OrderModel> get runningOrderList => _runningOrderList;
  List<RunningOrderModel> get runningOrders => _runningOrders;
  List<OrderModel> get historyOrderList => _historyOrderList;
  List<OrderDetailsModel> get orderDetailsModel => _orderDetailsModel;
  bool get isLoading => _isLoading;
  int get orderIndex => _orderIndex;
  bool get campaignOnly => _campaignOnly;
  String get otp => _otp;
  int get historyIndex => _historyIndex;
  List<String> get statusList => _statusList;
  bool get paginate => _paginate;
  int get pageSize => _pageSize;
  int get offset => _offset;
  String get orderType => _orderType;

  Future<void> getAllOrders() async {
    _historyIndex = 0;
    Response response = await orderRepo.getAllOrders();
    if(response.statusCode == 200) {
      _allOrderList = [];
      _orderList = [];
      response.body.forEach((order) {
        OrderModel _orderModel = OrderModel.fromJson(order);
        _allOrderList.add(_orderModel);
        _orderList.add(_orderModel);
      });
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getCurrentOrders() async {
    Response response = await orderRepo.getCurrentOrders();
    if(response.statusCode == 200) {
      _runningOrderList = [];
      _runningOrders = [
        RunningOrderModel(status: 'pending', orderList: []),
        RunningOrderModel(status: 'confirmed', orderList: []),
        RunningOrderModel(status: Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
            ? 'cooking' : 'processing', orderList: []),
        RunningOrderModel(status: 'ready_for_handover', orderList: []),
        RunningOrderModel(status: 'food_on_the_way', orderList: []),
      ];
      response.body.forEach((order) {
        OrderModel _orderModel = OrderModel.fromJson(order);
        _runningOrderList.add(_orderModel);
      });
      _campaignOnly = true;
      toggleCampaignOnly();
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  // Future<void> getCompletedOrders() async {
  //   Response response = await orderRepo.getCompletedOrders();
  //   if(response.statusCode == 200) {
  //     _historyOrderList = [];
  //     response.body.forEach((order) {
  //       OrderModel _orderModel = OrderModel.fromJson(order);
  //       _historyOrderList.add(_orderModel);
  //     });
  //   }else {
  //     ApiChecker.checkApi(response);
  //   }
  //   setHistoryIndex(0);
  // }

  Future<void> getPaginatedOrders(int offset, bool reload) async {
    if(offset == 1 || reload) {
      _offsetList = [];
      _offset = 1;
      if(reload) {
        _historyOrderList = null;
      }
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await orderRepo.getPaginatedOrderList(offset, _statusList[_historyIndex]);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        _historyOrderList.addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _pageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void setOrderType(String type) {
    _orderType = type;
    getPaginatedOrders(1, true);
  }

  Future<bool> updateOrderStatus(int orderID, String status, {bool back = false}) async {
    _isLoading = true;
    update();
    UpdateStatusBody _updateStatusBody = UpdateStatusBody(
      orderId: orderID, status: status,
      otp: status == 'delivered' ? _otp : null,
    );
    Response response = await orderRepo.updateOrderStatus(_updateStatusBody);
    Get.back();
    bool _isSuccess;
    if(response.statusCode == 200) {
      if(back) {
        Get.back();
      }
      getCurrentOrders();
      Get.find<AuthController>().getProfile();
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    }else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<void> getOrderDetails(int orderID) async {
    _orderDetailsModel = null;
    Response response = await orderRepo.getOrderDetails(orderID);
    if(response.statusCode == 200) {
      _orderDetailsModel = [];
      response.body.forEach((orderDetails) => _orderDetailsModel.add(OrderDetailsModel.fromJson(orderDetails)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setOrderIndex(int index) {
    _orderIndex = index;
    update();
  }

  void toggleCampaignOnly() {
    _campaignOnly = !_campaignOnly;
    _runningOrders[0].orderList = [];
    _runningOrders[1].orderList = [];
    _runningOrders[2].orderList = [];
    _runningOrders[3].orderList = [];
    _runningOrders[4].orderList = [];
    _runningOrderList.forEach((order) {
      if(order.orderStatus == 'pending' && (Get.find<SplashController>().configModel.orderConfirmationModel != 'deliveryman'
          || order.orderType == 'take_away' || Get.find<AuthController>().profileModel.stores[0].selfDeliverySystem == 1)
          && (_campaignOnly ? order.itemCampaign == 1 : true)) {
        _runningOrders[0].orderList.add(order);
      }else if((order.orderStatus == 'confirmed' || (order.orderStatus == 'accepted' && order.confirmed != null))
          && (_campaignOnly ? order.itemCampaign == 1 : true)) {
        _runningOrders[1].orderList.add(order);
      }else if(order.orderStatus == 'processing' && (_campaignOnly ? order.itemCampaign == 1 : true)) {
        _runningOrders[2].orderList.add(order);
      }else if(order.orderStatus == 'handover' && (_campaignOnly ? order.itemCampaign == 1 : true)) {
        _runningOrders[3].orderList.add(order);
      }else if(order.orderStatus == 'picked_up' && (_campaignOnly ? order.itemCampaign == 1 : true)) {
        _runningOrders[4].orderList.add(order);
      }
    });
    update();
  }

  void setOtp(String otp) {
    _otp = otp;
    if(otp != '') {
      update();
    }
  }

  void setHistoryIndex(int index) {
    _historyIndex = index;
    getPaginatedOrders(offset, true);
    update();
  }

  // int countHistoryList(int index) {
  //   int _length;
  //   if(index == 0) {
  //     _length = _historyOrderList.length;
  //   }else {
  //     _length = _historyOrderList.where((order) => order.orderStatus == _statusList[index]).length;
  //   }
  //   return _length;
  // }

}