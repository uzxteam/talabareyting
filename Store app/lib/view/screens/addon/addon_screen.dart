import 'package:sixam_mart_store/controller/addon_controller.dart';
import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/addon/widget/add_addon_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<AddonController>().getAddonList();

    return Scaffold(

      appBar: CustomAppBar(title: 'addons'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(Get.find<AuthController>().profileModel.stores[0].itemSection) {
            Get.bottomSheet(AddAddonBottomSheet(addon: null), isScrollControlled: true, backgroundColor: Colors.transparent);
          }else {
            showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
          }
        },
        child: Icon(Icons.add_circle_outline, size: 30, color: Theme.of(context).cardColor),
      ),

      body: GetBuilder<AddonController>(builder: (addonController) {
        return addonController.addonList != null ? addonController.addonList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await addonController.getAddonList();
          },
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemCount: addonController.addonList.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                  vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                color: index % 2 == 0 ? Theme.of(context).cardColor : Theme.of(context).disabledColor.withOpacity(0.2),
                child: Row(children: [

                  Expanded(child: Text(
                    addonController.addonList[index].name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular,
                  )),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  Text(
                    addonController.addonList[index].price > 0
                        ? PriceConverter.convertPrice(addonController.addonList[index].price) : 'free'.tr,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular,
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  PopupMenuButton(
                    itemBuilder: (context) {
                      return <PopupMenuEntry>[
                        PopupMenuItem(
                          child: Text('edit'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('delete'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.red)),
                          value: 'delete',
                        ),
                      ];
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                    offset: Offset(-20, 20),
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Icon(Icons.more_vert, size: 25),
                    ),
                    onSelected: (value) {
                      if(Get.find<AuthController>().profileModel.stores[0].itemSection) {
                        if (value == 'edit') {
                          Get.bottomSheet(
                            AddAddonBottomSheet(addon: addonController.addonList[index]),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        } else {
                          Get.dialog(Center(child: Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            ),
                            child: CircularProgressIndicator(),
                          )), barrierDismissible: false);
                          addonController.deleteAddon(addonController.addonList[index].id);
                        }
                      }else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                  ),

                ]),
              );
            },
          ),
        ) : Center(child: Text('no_addon_found'.tr)) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
