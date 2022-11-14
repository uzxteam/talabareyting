import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountTag extends StatelessWidget {
  final double discount;
  final String discountType;
  final double fromTop;
  final double fontSize;
  final bool freeDelivery;
  DiscountTag({@required this.discount, @required this.discountType, this.fromTop = 10, this.fontSize, this.freeDelivery = false});

  @override
  Widget build(BuildContext context) {
    return (discount > 0 || freeDelivery) ? Positioned(
      top: fromTop, left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(Dimensions.RADIUS_SMALL)),
        ),
        child: Text(
          discount > 0 ? '$discount${discountType == 'percent' ? '%'
              : Get.find<SplashController>().configModel.currencySymbol} ${'off'.tr}' : 'free_delivery'.tr,
          style: robotoMedium.copyWith(
            color: Colors.white,
            fontSize: fontSize != null ? fontSize : ResponsiveHelper.isMobile(context) ? 8 : 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ) : SizedBox();
  }
}
