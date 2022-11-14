import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/view/base/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    Get.find<OrderController>().setOffset(1);
    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<OrderController>().historyOrderList != null
          && !Get.find<OrderController>().paginate) {
        int pageSize = (Get.find<OrderController>().pageSize / 10).ceil();
        if (Get.find<OrderController>().offset < pageSize) {
          Get.find<OrderController>().setOffset(Get.find<OrderController>().offset+1);
          print('end of the page');
          Get.find<OrderController>().showBottomLoader();
          Get.find<OrderController>().getPaginatedOrders(Get.find<OrderController>().offset, false);
        }
      }
    });

    return GetBuilder<OrderController>(builder: (orderController) {
      return Column(children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => await orderController.getPaginatedOrders(1, true),
            child: ListView.builder(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: orderController.historyOrderList.length,
              itemBuilder: (context, index) {
                return OrderWidget(
                  orderModel: orderController.historyOrderList[index],
                  hasDivider: index != orderController.historyOrderList.length-1, isRunning: false,
                  showStatus: orderController.historyIndex == 0,
                );
              },
            ),
          ),
        ),

        orderController.paginate ? Center(child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CircularProgressIndicator(),
        )) : SizedBox(),
      ]);
    });
  }
}
