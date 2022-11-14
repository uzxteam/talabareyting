import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/screens/home/widget/order_button.dart';
import 'package:sixam_mart_store/view/screens/order/widget/count_widget.dart';
import 'package:sixam_mart_store/view/screens/order/widget/order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<OrderController>().getPaginatedOrders(1, true);

    return Scaffold(
      appBar: CustomAppBar(title: 'order_history'.tr, isBackButtonExist: false),
      body: GetBuilder<OrderController>(builder: (orderController) {
        return Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: [

            GetBuilder<AuthController>(builder: (authController) {
              return authController.profileModel != null ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Row(children: [
                  CountWidget(title: 'today'.tr, count: authController.profileModel.todaysOrderCount),
                  CountWidget(title: 'this_week'.tr, count: authController.profileModel.thisWeekOrderCount),
                  CountWidget(title: 'this_month'.tr, count: authController.profileModel.thisMonthOrderCount),
                ]),
              ) : SizedBox();
            }),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orderController.statusList.length,
                itemBuilder: (context, index) {
                  return OrderButton(
                    title: orderController.statusList[index].tr, index: index, orderController: orderController, fromHistory: true,
                  );
                },
              ),
            ),
            SizedBox(height: orderController.historyOrderList != null ? Dimensions.PADDING_SIZE_SMALL : 0),

            Expanded(
              child: orderController.historyOrderList != null ? orderController.historyOrderList.length > 0
                  ? OrderView() : Center(child: Text('no_order_found'.tr)) : Center(child: CircularProgressIndicator()),
            ),

          ]),
        );
      }),
    );
  }
}
