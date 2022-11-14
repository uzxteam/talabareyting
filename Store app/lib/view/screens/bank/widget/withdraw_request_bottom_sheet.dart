import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/bank_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class WithdrawRequestBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _amountController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_LARGE)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Text('withdraw'.tr, style: robotoMedium),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

        Image.asset(Images.bank, height: 30, width: 30),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Text(Get.find<AuthController>().profileModel.bankName, style: robotoRegular),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Text(
          Get.find<AuthController>().profileModel.branch,
          style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.FONT_SIZE_SMALL),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Text(
          Get.find<AuthController>().profileModel.accountNo,
          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

        Text('enter_amount'.tr, style: robotoRegular),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        TextField(
          controller: _amountController,
          textAlign: TextAlign.center,
          style: robotoMedium,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          decoration: InputDecoration(
            hintText: 'enter_amount'.tr,
            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
            prefixIcon: Text(
              Get.find<SplashController>().configModel.currencySymbol,
              style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        GetBuilder<BankController>(builder: (bankController) {
          return !bankController.isLoading ? CustomButton(
            buttonText: 'withdraw'.tr,
            onPressed: () {
              String _amount = _amountController.text.trim();
              if(_amount.isEmpty) {
                showCustomSnackBar('enter_amount'.tr);
              }else {
                bankController.requestWithdraw(_amount);
              }
            },
          ) : Center(child: CircularProgressIndicator());
        }),

      ]),
    );
  }
}
