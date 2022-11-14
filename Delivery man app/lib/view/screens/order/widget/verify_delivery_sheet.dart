import 'package:sixam_mart_delivery/controller/auth_controller.dart';
import 'package:sixam_mart_delivery/controller/order_controller.dart';
import 'package:sixam_mart_delivery/helper/price_converter.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyDeliverySheet extends StatelessWidget {
  final int orderIndex;
  final bool verify;
  final bool cod;
  final double orderAmount;
  VerifyDeliverySheet({@required this.orderIndex, @required this.verify, @required this.orderAmount, @required this.cod});

  @override
  Widget build(BuildContext context) {
    Get.find<OrderController>().setOtp('');
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            cod ? Column(children: [
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
                  PriceConverter.convertPrice(orderAmount), textAlign: TextAlign.center,
                  style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
                ),
              ]),
              SizedBox(height: verify ? 20 : 40),
            ]) : SizedBox(),

            verify ? Column(children: [
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Text('collect_otp_from_customer'.tr, style: robotoRegular, textAlign: TextAlign.center),
              SizedBox(height: 40),

              PinCodeTextField(
                length: 4,
                appContext: context,
                keyboardType: TextInputType.number,
                animationType: AnimationType.slide,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  fieldHeight: 60,
                  fieldWidth: 60,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  selectedFillColor: Colors.white,
                  inactiveFillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                  inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  activeColor: Theme.of(context).primaryColor.withOpacity(0.4),
                  activeFillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                onChanged: (String text) => orderController.setOtp(text),
                beforeTextPaste: (text) => true,
              ),
              SizedBox(height: 40),
            ]) : SizedBox(),

            (verify && orderController.otp.length != 4) ? SizedBox() : !orderController.isLoading ? CustomButton(
              buttonText: verify ? 'verify'.tr : 'ok'.tr,
              margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
              onPressed: () {
                Get.find<OrderController>().updateOrderStatus(orderIndex, 'delivered').then((success) {
                  if(success) {
                    Get.find<AuthController>().getProfile();
                    Get.find<OrderController>().getCurrentOrders();
                    Get.offAllNamed(RouteHelper.getInitialRoute());
                  }
                });
              },
            ) : Center(child: CircularProgressIndicator()),

          ]),
        );
      }),
    );
  }
}
