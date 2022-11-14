import 'package:sixam_mart_store/data/model/response/order_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool hasDivider;
  final bool isRunning;
  final bool showStatus;
  OrderWidget({@required this.orderModel, @required this.hasDivider, @required this.isRunning, this.showStatus = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(orderModel.id), arguments: OrderDetailsScreen(
        orderModel: orderModel, isRunningOrder: isRunning,
      )),
      child: Column(children: [

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${'order_id'.tr}: #${orderModel.id}', style: robotoMedium),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                Text(
                  DateConverter.dateTimeStringToDateTime(orderModel.createdAt),
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                ),
                Container(
                  height: 10, width: 1, color: Theme.of(context).disabledColor,
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                ),
                Text(
                  orderModel.orderType.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor),
                ),
              ]),
            ])),

            showStatus ? Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              ),
              alignment: Alignment.center,
              child: Text(
                orderModel.orderStatus.toUpperCase(),
                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).cardColor),
              ),
            ) : Text(
              '${orderModel.detailsCount} ${orderModel.detailsCount < 2 ? 'item'.tr : 'items'.tr}',
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
            ),

            showStatus ? SizedBox() : Icon(Icons.keyboard_arrow_right, size: 30, color: Theme.of(context).primaryColor),

          ]),
        ),

        hasDivider ? Divider(color: Theme.of(context).disabledColor) : SizedBox(),

      ]),
    );
  }
}
