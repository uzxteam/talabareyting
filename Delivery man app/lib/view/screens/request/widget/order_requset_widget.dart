import 'package:sixam_mart_delivery/controller/auth_controller.dart';
import 'package:sixam_mart_delivery/controller/order_controller.dart';
import 'package:sixam_mart_delivery/controller/splash_controller.dart';
import 'package:sixam_mart_delivery/data/model/response/order_model.dart';
import 'package:sixam_mart_delivery/helper/date_converter.dart';
import 'package:sixam_mart_delivery/helper/price_converter.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_delivery/view/base/custom_button.dart';
import 'package:sixam_mart_delivery/view/base/custom_image.dart';
import 'package:sixam_mart_delivery/view/base/custom_snackbar.dart';
import 'package:sixam_mart_delivery/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRequestWidget extends StatelessWidget {
  final OrderModel orderModel;
  final int index;
  final bool fromDetailsPage;
  final Function onTap;
  OrderRequestWidget({@required this.orderModel, @required this.index, @required this.onTap, this.fromDetailsPage = false});

  @override
  Widget build(BuildContext context) {
    bool _parcel = orderModel.orderType == 'parcel';

    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Column(children: [

          Row(children: [
            Container(
              height: 45, width: 45, alignment: Alignment.center,
              decoration: _parcel ? BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ) : null,
              child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), child: CustomImage(
                image: _parcel ? '${Get.find<SplashController>().configModel.baseUrls.parcelCategoryImageUrl}/${orderModel.parcelCategory != null
                    ? orderModel.parcelCategory.image : ''}' : '${Get.find<SplashController>().configModel.baseUrls.storeImageUrl}/${orderModel.storeLogo ?? ''}',
                height: _parcel ? 30 : 45, width: _parcel ? 30 : 45, fit: BoxFit.cover,
              )),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                _parcel ? orderModel.parcelCategory != null ? orderModel.parcelCategory.name ?? ''
                    : '' : orderModel.storeName ?? 'no_store_data_found'.tr, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
              ),
              Text(
                _parcel ? orderModel.parcelCategory != null ? orderModel.parcelCategory.description ?? '' : '' : orderModel.storeAddress ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              ),
            ])),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: Column(children: [
                (Get.find<SplashController>().configModel.showDmEarning && Get.find<AuthController>().profileModel.earnings == 1) ? Text(
                  PriceConverter.convertPrice(orderModel.originalDeliveryCharge),
                  style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                ) : SizedBox(),
                Text(
                  orderModel.paymentMethod == 'cash_on_delivery' ? 'cod'.tr : 'digitally_paid'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                ),
              ]),
            ),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Container(
            padding: _parcel ? EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL) : null,
            decoration: _parcel ? BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            ) : null,
            child: Text(
              _parcel ? 'parcel'.tr : '${orderModel.detailsCount} ${orderModel.detailsCount > 1 ? 'items'.tr : 'item'.tr}',
              style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: _parcel ? Colors.white : null),
            ),
          ),
          SizedBox(height: _parcel ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
          Text(
            '${DateConverter.timeDistanceInMin(orderModel.createdAt)} ${'mins_ago'.tr}',
            style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Row(children: [
            Expanded(child: TextButton(
              onPressed: () => Get.dialog(ConfirmationDialog(
                icon: Images.warning, title: 'are_you_sure_to_ignore'.tr,
                description: _parcel ? 'you_want_to_ignore_this_delivery'.tr : 'you_want_to_ignore_this_order'.tr,
                onYesPressed: () {
                  orderController.ignoreOrder(index);
                  Get.back();
                  showCustomSnackBar('order_ignored'.tr, isError: false);
                },
              ), barrierDismissible: false),
              style: TextButton.styleFrom(
                minimumSize: Size(1170, 40), padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  side: BorderSide(width: 1, color: Theme.of(context).textTheme.bodyText1.color),
                ),
              ),
              child: Text('ignore'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                color: Theme.of(context).textTheme.bodyText1.color,
                fontSize: Dimensions.FONT_SIZE_LARGE,
              )),
            )),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(child: CustomButton(
              height: 40,
              buttonText: 'accept'.tr,
              onPressed: () => Get.dialog(ConfirmationDialog(
                icon: Images.warning, title: 'are_you_sure_to_accept'.tr,
                description: _parcel ? 'you_want_to_accept_this_delivery'.tr : 'you_want_to_accept_this_order'.tr,
                onYesPressed: () {
                  orderController.acceptOrder(orderModel.id, index, orderModel).then((isSuccess) {
                    if(isSuccess) {
                      onTap();
                      orderModel.orderStatus = (orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'confirmed')
                          ? 'accepted' : orderModel.orderStatus;
                      Get.toNamed(
                        RouteHelper.getOrderDetailsRoute(orderModel.id),
                        arguments: OrderDetailsScreen(
                          orderModel: orderModel, isRunningOrder: true, orderIndex: orderController.currentOrderList.length-1,
                        ),
                      );
                    }else {
                      Get.find<OrderController>().getLatestOrders();
                    }
                  });
                },
              ), barrierDismissible: false),
            )),
          ]),

        ]);
      }),
    );
  }
}
