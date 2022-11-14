import 'package:sixam_mart_delivery/helper/price_converter.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderFeeReceiveDialog extends StatelessWidget {
  final double totalAmount;
  OrderFeeReceiveDialog({@required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Image.asset(Images.money, height: 100, width: 100),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          Text(
            'collect_money_from_customer'.tr, textAlign: TextAlign.center,
            style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '${'order_amount'.tr}:', textAlign: TextAlign.center,
              style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              PriceConverter.convertPrice(totalAmount), textAlign: TextAlign.center,
              style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
            ),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          CustomButton(
            buttonText: 'ok'.tr,
            onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute()),
          ),

        ]),
      ),
    );
  }
}
