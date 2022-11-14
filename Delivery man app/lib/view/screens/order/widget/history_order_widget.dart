import 'package:sixam_mart_delivery/controller/splash_controller.dart';
import 'package:sixam_mart_delivery/data/model/response/order_model.dart';
import 'package:sixam_mart_delivery/helper/date_converter.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/custom_image.dart';
import 'package:sixam_mart_delivery/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryOrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunning;
  final int index;
  HistoryOrderWidget({@required this.orderModel, @required this.isRunning, @required this.index});

  @override
  Widget build(BuildContext context) {
    bool _parcel = orderModel.orderType == 'parcel';

    return InkWell(
      onTap: () => Get.toNamed(
        RouteHelper.getOrderDetailsRoute(orderModel.id),
        arguments: OrderDetailsScreen(orderModel: orderModel, isRunningOrder: isRunning, orderIndex: index),
      ),
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        ),
        child: Row(children: [

          Container(
            height: 70, width: 70, alignment: Alignment.center,
            decoration: _parcel ? BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ) : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              child: CustomImage(
                image: _parcel ? '${Get.find<SplashController>().configModel.baseUrls.parcelCategoryImageUrl}/${orderModel.parcelCategory.image}'
                    : '${Get.find<SplashController>().configModel.baseUrls.storeImageUrl}/${orderModel.storeLogo ?? ''}',
                height: _parcel ? 45 : 70, width: _parcel ? 45 : 70, fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Text(
                  '${_parcel ? 'delivery_id'.tr : 'order_id'.tr}:',
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Expanded(child: Text(
                  '#${orderModel.id}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                )),
                _parcel ? Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text('parcel'.tr, style: robotoMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.white,
                  )),
                ) : SizedBox(),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Text(
                _parcel ? orderModel.parcelCategory.name : orderModel.storeName ?? 'no_store_data_found'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Row(children: [
                Icon(Icons.access_time, size: 15),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  DateConverter.dateTimeStringToDateTime(orderModel.createdAt),
                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.FONT_SIZE_SMALL),
                ),
              ]),

            ]),
          ),

        ]),
      ),
    );
  }
}
