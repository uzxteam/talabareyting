import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/bank_controller.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/bank/widget/wallet_widget.dart';
import 'package:sixam_mart_store/view/screens/bank/widget/withdraw_request_bottom_sheet.dart';
import 'package:sixam_mart_store/view/screens/bank/widget/withdraw_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }
    Get.find<BankController>().getWithdrawList();

    return Scaffold(
      appBar: CustomAppBar(title: 'wallet'.tr, isBackButtonExist: false),
      body: GetBuilder<AuthController>(builder: (authController) {
        return GetBuilder<BankController>(builder: (bankController) {
          return (authController.profileModel != null && bankController.withdrawList != null) ? RefreshIndicator(
            onRefresh: () async {
              await Get.find<AuthController>().getProfile();
              await Get.find<BankController>().getWithdrawList();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor,
                  ),
                  alignment: Alignment.center,
                  child: Row(children: [

                    Image.asset(Images.wallet, width: 60, height: 60),
                    SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('wallet_amount'.tr, style: robotoRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).cardColor,
                      )),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(PriceConverter.convertPrice(authController.profileModel.balance), style: robotoBold.copyWith(
                        fontSize: 22, color: Theme.of(context).cardColor,
                      )),
                    ])),

                    InkWell(
                      onTap: () {
                        if(authController.profileModel.bankName != null) {
                          Get.bottomSheet(WithdrawRequestBottomSheet(), isScrollControlled: true);
                        }else {
                          showCustomSnackBar('currently_no_bank_account_added'.tr);
                        }
                      },
                      child: Padding(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL), child: Row(children: [
                        Text('withdraw'.tr, style: robotoRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).cardColor,
                        )),
                        Icon(Icons.keyboard_arrow_down, color: Theme.of(context).cardColor, size: 20),
                      ])),
                    ),

                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Row(children: [
                  WalletWidget(title: 'pending_withdraw'.tr, value: bankController.pendingWithdraw),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  WalletWidget(title: 'withdrawn'.tr, value: bankController.withdrawn),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Row(children: [
                  WalletWidget(title: 'collected_cash_from_customer'.tr, value: authController.profileModel.cashInHands),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  WalletWidget(title: 'total_earning'.tr, value: authController.profileModel.totalEarning),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('withdraw_history'.tr, style: robotoMedium),
                  InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getWithdrawHistoryRoute()),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Text('view_all'.tr, style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor,
                      )),
                    ),
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                bankController.withdrawList.length > 0 ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: bankController.withdrawList.length > 10 ? 10 : bankController.withdrawList.length,
                  itemBuilder: (context, index) {
                    return WithdrawWidget(
                      withdrawModel: bankController.withdrawList[index],
                      showDivider: index != (bankController.withdrawList.length > 10 ? 9 : bankController.withdrawList.length-1),
                    );
                  },
                ) : Center(child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  child: Text('no_withdraw_history_found'.tr),
                )),

              ]),
            ),
          ) : Center(child: CircularProgressIndicator());
        });
      }),
    );
  }
}
