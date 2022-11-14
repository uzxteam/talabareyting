import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:sixam_mart_delivery/controller/auth_controller.dart';
import 'package:sixam_mart_delivery/controller/notification_controller.dart';
import 'package:sixam_mart_delivery/controller/order_controller.dart';
import 'package:sixam_mart_delivery/helper/price_converter.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_delivery/view/base/custom_alert_dialog.dart';
import 'package:sixam_mart_delivery/view/base/custom_snackbar.dart';
import 'package:sixam_mart_delivery/view/base/order_shimmer.dart';
import 'package:sixam_mart_delivery/view/base/order_widget.dart';
import 'package:sixam_mart_delivery/view/base/title_widget.dart';
import 'package:sixam_mart_delivery/view/screens/home/widget/count_card.dart';
import 'package:sixam_mart_delivery/view/screens/home/widget/earning_widget.dart';
import 'package:sixam_mart_delivery/view/screens/order/running_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {

  Future<void> _loadData() async {
    Get.find<OrderController>().getIgnoreList();
    Get.find<OrderController>().removeFromIgnoreList();
    await Get.find<AuthController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
    bool _isBatteryOptimizationDisabled = GetPlatform.isAndroid ? await DisableBatteryOptimization.isBatteryOptimizationDisabled : true;
    if(!_isBatteryOptimizationDisabled && GetPlatform.isAndroid) {
      DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Image.asset(Images.logo, height: 30, width: 30),
        ),
        titleSpacing: 0, elevation: 0,
        title: Text(AppConstants.APP_NAME, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_DEFAULT,
        )),
        actions: [
          IconButton(
            icon: GetBuilder<NotificationController>(builder: (notificationController) {
              bool _hasNewNotification = false;
              if(notificationController.notificationList != null) {
                _hasNewNotification = notificationController.notificationList.length
                    != notificationController.getSeenNotificationCount();
              }
              return Stack(children: [
                Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyText1.color),
                _hasNewNotification ? Positioned(top: 0, right: 0, child: Container(
                  height: 10, width: 10, decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Theme.of(context).cardColor),
                ),
                )) : SizedBox(),
              ]);
            }),
            onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          ),
          GetBuilder<AuthController>(builder: (authController) {
            return GetBuilder<OrderController>(builder: (orderController) {
              return (authController.profileModel != null && orderController.currentOrderList != null) ? FlutterSwitch(
                width: 75, height: 30, valueFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, showOnOff: true,
                activeText: 'online'.tr, inactiveText: 'offline'.tr, activeColor: Theme.of(context).primaryColor,
                value: authController.profileModel.active == 1, onToggle: (bool isActive) async {
                  if(!isActive && orderController.currentOrderList.length > 0) {
                    showCustomSnackBar('you_can_not_go_offline_now'.tr);
                  }else {
                    if(!isActive) {
                      Get.dialog(ConfirmationDialog(
                        icon: Images.warning, description: 'are_you_sure_to_offline'.tr,
                        onYesPressed: () {
                          Get.back();
                          authController.updateActiveStatus();
                        },
                      ));
                    }else {
                      LocationPermission permission = await Geolocator.checkPermission();
                      if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
                          || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
                        if(GetPlatform.isAndroid) {
                          Get.dialog(ConfirmationDialog(
                            icon: Images.location_permission,
                            iconSize: 200,
                            hasCancel: false,
                            description: 'this_app_collects_location_data'.tr,
                            onYesPressed: () {
                              Get.back();
                              _checkPermission(() => authController.updateActiveStatus());
                            },
                          ), barrierDismissible: false);
                        }else {
                          _checkPermission(() => authController.updateActiveStatus());
                        }
                      }else {
                        authController.updateActiveStatus();
                      }
                    }
                  }
                },
              ) : SizedBox();
            });
          }),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          return await _loadData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<AuthController>(builder: (authController) {

            return Column(children: [

              GetBuilder<OrderController>(builder: (orderController) {
                bool _hasActiveOrder = orderController.currentOrderList == null || orderController.currentOrderList.length > 0;
                bool _hasMoreOrder = orderController.currentOrderList != null && orderController.currentOrderList.length > 1;
                return Column(children: [
                  _hasActiveOrder ? TitleWidget(
                    title: 'active_order'.tr, onTap: _hasMoreOrder ? () {
                      Get.toNamed(RouteHelper.getRunningOrderRoute(), arguments: RunningOrderScreen());
                    } : null,
                  ) : SizedBox(),
                  SizedBox(height: _hasActiveOrder ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                  orderController.currentOrderList == null ? OrderShimmer(
                    isEnabled: orderController.currentOrderList == null,
                  ) : orderController.currentOrderList.length > 0 ? OrderWidget(
                    orderModel: orderController.currentOrderList[0], isRunningOrder: true, orderIndex: 0,
                  ) : SizedBox(),
                  SizedBox(height: _hasActiveOrder ? Dimensions.PADDING_SIZE_DEFAULT : 0),
                ]);
              }),

              (authController.profileModel != null && authController.profileModel.earnings == 1) ? Column(children: [
                TitleWidget(title: 'earnings'.tr),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Image.asset(Images.wallet, width: 60, height: 60),
                      SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'balance'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).cardColor),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        authController.profileModel != null ? Text(
                          PriceConverter.convertPrice(authController.profileModel.balance),
                          style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) : Container(height: 30, width: 60, color: Colors.white),
                      ]),
                    ]),
                    SizedBox(height: 30),
                    Row(children: [
                      EarningWidget(
                        title: 'today'.tr,
                        amount: authController.profileModel != null ? authController.profileModel.todaysEarning : null,
                      ),
                      Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                      EarningWidget(
                        title: 'this_week'.tr,
                        amount: authController.profileModel != null ? authController.profileModel.thisWeekEarning : null,
                      ),
                      Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                      EarningWidget(
                        title: 'this_month'.tr,
                        amount: authController.profileModel != null ? authController.profileModel.thisMonthEarning : null,
                      ),
                    ]),
                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
              ]) : SizedBox(),

              TitleWidget(title: 'orders'.tr),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                Expanded(child: CountCard(
                  title: 'todays_orders'.tr, backgroundColor: Theme.of(context).secondaryHeaderColor, height: 180,
                  value: authController.profileModel != null ? authController.profileModel.todaysOrderCount.toString() : null,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: CountCard(
                  title: 'this_week_orders'.tr, backgroundColor: Theme.of(context).errorColor, height: 180,
                  value: authController.profileModel != null ? authController.profileModel.thisWeekOrderCount.toString() : null,
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              CountCard(
                title: 'total_orders'.tr, backgroundColor: Theme.of(context).primaryColor, height: 140,
                value: authController.profileModel != null ? authController.profileModel.orderCount.toString() : null,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              CountCard(
                title: 'cash_in_your_hand'.tr, backgroundColor: Colors.green, height: 140,
                value: authController.profileModel != null
                    ? PriceConverter.convertPrice(authController.profileModel.cashInHands) : null,
              ),

              /*TitleWidget(title: 'ratings'.tr),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Text('my_ratings'.tr, style: robotoMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white,
                  ))),
                  GetBuilder<AuthController>(builder: (authController) {
                    return Shimmer(
                      duration: Duration(seconds: 2),
                      enabled: authController.profileModel == null,
                      color: Colors.grey[500],
                      child: Column(children: [
                        Row(children: [
                          authController.profileModel != null ? Text(
                            authController.profileModel.avgRating.toString(),
                            style: robotoBold.copyWith(fontSize: 30, color: Colors.white),
                          ) : Container(height: 25, width: 40, color: Colors.white),
                          Icon(Icons.star, color: Colors.white, size: 35),
                        ]),
                        authController.profileModel != null ? Text(
                          '${authController.profileModel.ratingCount} ${'reviews'.tr}',
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white),
                        ) : Container(height: 10, width: 50, color: Colors.white),
                      ]),
                    );
                  }),
                ]),
              ),*/

            ]);
          }),
        ),
      ),
    );
  }

  void _checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(CustomAlertDialog(description: 'you_denied'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(CustomAlertDialog(description: 'you_denied_forever'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else {
      callback();
    }
  }
}
