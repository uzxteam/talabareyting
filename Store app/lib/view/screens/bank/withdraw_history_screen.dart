import 'package:sixam_mart_store/controller/bank_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/screens/bank/widget/withdraw_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar(title: 'withdraw_history'.tr, menuWidget: PopupMenuButton(
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            getMenuItem(Get.find<BankController>().statusList[0], context),
            PopupMenuDivider(),
            getMenuItem(Get.find<BankController>().statusList[1], context),
            PopupMenuDivider(),
            getMenuItem(Get.find<BankController>().statusList[2], context),
            PopupMenuDivider(),
            getMenuItem(Get.find<BankController>().statusList[3], context),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
        offset: Offset(-25, 25),
        child: Container(
          width: 40, height: 40,
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child: Icon(Icons.arrow_drop_down, size: 30),
        ),
        onSelected: (value) {
          int _index = Get.find<BankController>().statusList.indexOf(value);
          Get.find<BankController>().filterWithdrawList(_index);
        },
      )),

      body: GetBuilder<BankController>(builder: (bankController) {
        return bankController.withdrawList.length > 0 ? ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: bankController.withdrawList.length,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          itemBuilder: (context, index) {
            return WithdrawWidget(
              withdrawModel: bankController.withdrawList[index],
              showDivider: index != bankController.withdrawList.length - 1,
            );
          },
        ) : Center(child: Text('no_withdraw_history_found'.tr));
      }),

    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      child: Text(status.toLowerCase().tr, style: robotoRegular.copyWith(
        color: status == 'Pending' ? Theme.of(context).primaryColor : status == 'Approved' ? Colors.green
            : status == 'Denied' ? Colors.red : null,
      )),
      value: status,
      height: 30,
    );
  }

}
