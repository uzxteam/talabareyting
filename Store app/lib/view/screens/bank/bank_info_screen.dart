import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/screens/bank/widget/add_bank_bottom_sheet.dart';
import 'package:sixam_mart_store/view/screens/bank/widget/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }
    return Scaffold(
      appBar: CustomAppBar(title: 'bank_info'.tr),
      body: GetBuilder<AuthController>(builder: (authController) {
        return Center(child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: authController.profileModel != null ? authController.profileModel.bankName != null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              InfoWidget(icon: Images.bank, title: 'bank_name'.tr, data: authController.profileModel.bankName),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              InfoWidget(icon: Images.branch, title: 'branch_name'.tr, data: authController.profileModel.branch),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              InfoWidget(icon: Images.user, title: 'holder_name'.tr, data: authController.profileModel.holderName),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              InfoWidget(icon: Images.credit_card, title: 'account_no'.tr, data: authController.profileModel.accountNo),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

              CustomButton(
                buttonText: 'edit'.tr,
                onPressed: () => Get.bottomSheet(AddBankBottomSheet(
                  bankName: authController.profileModel.bankName, branchName: authController.profileModel.branch,
                  holderName: authController.profileModel.holderName, accountNo: authController.profileModel.accountNo,
                ), isScrollControlled: true, backgroundColor: Colors.transparent),
              ),

            ],
          ) : Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Image.asset(Images.bank_info, width: context.width-100),
            SizedBox(height: 30),

            Text(
              'currently_no_bank_account_added'.tr, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
            ),
            SizedBox(height: 30),

            CustomButton(
              buttonText: 'add_bank'.tr,
              onPressed: () => Get.bottomSheet(AddBankBottomSheet(), isScrollControlled: true, backgroundColor: Colors.transparent),
            ),

          ]) : Center(child: CircularProgressIndicator()),
        ));
      }),
    );
  }
}
