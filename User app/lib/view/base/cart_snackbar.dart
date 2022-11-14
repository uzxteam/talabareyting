import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

void showCartSnackBar(BuildContext context) {
  ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: EdgeInsets.only(
      right: ResponsiveHelper.isDesktop(context) ? context.width*0.7 : Dimensions.PADDING_SIZE_SMALL,
      top: Dimensions.PADDING_SIZE_SMALL, bottom: Dimensions.PADDING_SIZE_SMALL, left: Dimensions.PADDING_SIZE_SMALL,
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
    content: Text('item_added_to_cart'.tr, style: robotoMedium.copyWith(color: Colors.white)),
    action: SnackBarAction(label: 'view_cart'.tr, onPressed: () => Get.toNamed(RouteHelper.getCartRoute()), textColor: Colors.white),
  ));
  // Get.showSnackbar(GetSnackBar(
  //   backgroundColor: Colors.green,
  //   message: 'item_added_to_cart'.tr,
  //   mainButton: TextButton(
  //     onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
  //     child: Text('view_cart'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
  //   ),
  //   onTap: (_) => Get.toNamed(RouteHelper.getCartRoute()),
  //   duration: Duration(seconds: 3),
  //   maxWidth: Dimensions.WEB_MAX_WIDTH,
  //   snackStyle: SnackStyle.FLOATING,
  //   margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
  //   borderRadius: 10,
  //   isDismissible: true,
  //   dismissDirection: DismissDirection.horizontal,
  // ));
}