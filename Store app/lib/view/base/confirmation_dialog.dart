import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/campaign_controller.dart';
import 'package:sixam_mart_store/controller/delivery_man_controller.dart';
import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Function onYesPressed;
  final Function onNoPressed;
  final bool isLogOut;
  ConfirmationDialog({
    @required this.icon, this.title, @required this.description, @required this.onYesPressed,
    this.onNoPressed, this.isLogOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Image.asset(icon, width: 50, height: 50),
          ),

          title != null ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              title, textAlign: TextAlign.center,
              style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.red),
            ),
          ) : SizedBox(),

          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Text(description, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE), textAlign: TextAlign.center),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          GetBuilder<DeliveryManController>(builder: (dmController) {
            return GetBuilder<StoreController>(builder: (storeController) {
              return GetBuilder<CampaignController>(builder: (campaignController) {
                return GetBuilder<OrderController>(builder: (orderController) {
                    return GetBuilder<AuthController>(builder: (authController) {
                      return (orderController.isLoading || campaignController.isLoading || storeController.isLoading
                      || dmController.isLoading || authController.isLoading) ? Center(child: CircularProgressIndicator()) : Row(children: [

                        Expanded(child: TextButton(
                          onPressed: () => isLogOut ? onYesPressed() : onNoPressed != null ? onNoPressed() : Get.back(),
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: Size(1170, 40), padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                          ),
                          child: Text(
                            isLogOut ? 'yes'.tr : 'no'.tr, textAlign: TextAlign.center,
                            style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                          ),
                        )),
                        SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                        Expanded(child: CustomButton(
                          buttonText: isLogOut ? 'no'.tr : 'yes'.tr,
                          onPressed: () => isLogOut ? Get.back() : onYesPressed(),
                          height: 40,
                        )),

                      ]);
                    });
                  }
                );
              });
            });
          }),

        ]),
      )),
    );
  }
}