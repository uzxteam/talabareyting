import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/store/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Item item;
  ItemDetailsScreen({@required this.item});

  @override
  Widget build(BuildContext context) {
    Get.find<StoreController>().setAvailability(item.status == 1);
    if(Get.find<AuthController>().profileModel.stores[0].reviewsSection) {
      Get.find<StoreController>().getItemReviewList(item.id);
    }
    Module _module = Get.find<SplashController>().configModel.moduleConfig.module;

    return Scaffold(
      appBar: CustomAppBar(title: 'item_details'.tr),
      body: GetBuilder<StoreController>(builder: (storeController) {
        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getItemImagesRoute(item)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    child: CustomImage(
                      image: '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${item.image}',
                      height: 70, width: 80, fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    item.name, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${'price'.tr}: ${item.price}', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular,
                  ),
                  Row(children: [
                    Expanded(child: Text(
                      '${'discount'.tr}: ${item.discount} ${item.discountType == 'percent' ? '%'
                          : Get.find<SplashController>().configModel.currencySymbol}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: robotoRegular,
                    )),
                    (_module.unit || Get.find<SplashController>().configModel.toggleVegNonVeg) ? Container(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        _module.unit ? item.unitType : item.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.white),
                      ),
                    ) : SizedBox(),
                  ]),
                ])),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              _module.itemAvailableTime ? Row(children: [
                Text('daily_time'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Expanded(child: Text(
                  '${DateConverter.convertStringTimeToTime(item.availableTimeStarts)}'
                      ' - ${DateConverter.convertStringTimeToTime(item.availableTimeEnds)}',
                  maxLines: 1,
                  style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                )),
                FlutterSwitch(
                  width: 100, height: 30, valueFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, showOnOff: true,
                  activeText: 'available'.tr, inactiveText: 'unavailable'.tr, activeColor: Theme.of(context).primaryColor,
                  value: storeController.isAvailable, onToggle: (bool isActive) {
                    storeController.toggleAvailable(item.id);
                  },
                ),
              ]) : SizedBox(),

              Row(children: [
                Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
                Text(item.avgRating.toStringAsFixed(1), style: robotoRegular),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: Text(
                  '${item.ratingCount} ${'ratings'.tr}',
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                )),
                _module.itemAvailableTime ? SizedBox() : FlutterSwitch(
                  width: 100, height: 30, valueFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, showOnOff: true,
                  activeText: 'available'.tr, inactiveText: 'unavailable'.tr, activeColor: Theme.of(context).primaryColor,
                  value: storeController.isAvailable, onToggle: (bool isActive) {
                    storeController.toggleAvailable(item.id);
                  },
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


              item.variations.length > 0 ? Text('variations'.tr, style: robotoMedium) : SizedBox(),
              SizedBox(height: item.variations.length > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
              item.variations.length > 0 ? ListView.builder(
                itemCount: item.variations.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Row(children: [

                    Text(item.variations[index].type+':', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      PriceConverter.convertPrice(item.variations[index].price),
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),
                    SizedBox(width: _module.stock ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                    _module.stock ? Text(
                      '(${item.variations[index].stock})',
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ) : SizedBox(),

                  ]);
                },
              ) : SizedBox(),
              SizedBox(height: item.variations.length > 0 ? Dimensions.PADDING_SIZE_LARGE : 0),

              Row(children: [
                _module.stock ? Text('${'total_stock'.tr}:', style: robotoMedium) : SizedBox(),
                SizedBox(width: _module.stock ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                _module.stock ? Text(
                  item.stock.toString(),
                  style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                ) : SizedBox(),
              ]),
              SizedBox(height: _module.stock ? Dimensions.PADDING_SIZE_LARGE : 0),

              (item.addOns.length > 0 && _module.addOn) ? Text('addons'.tr, style: robotoMedium) : SizedBox(),
              SizedBox(height: (item.addOns.length > 0 && _module.addOn) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
              (item.addOns.length > 0 && _module.addOn) ? ListView.builder(
                itemCount: item.addOns.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(children: [

                    Text(item.addOns[index].name+':', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      PriceConverter.convertPrice(item.addOns[index].price),
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),

                  ]);
                },
              ) : SizedBox(),
              SizedBox(height: item.addOns.length > 0 ? Dimensions.PADDING_SIZE_LARGE : 0),

              (item.description != null && item.description.isNotEmpty) ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('description'.tr, style: robotoMedium),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(item.description, style: robotoRegular),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                ],
              ) : SizedBox(),

              Get.find<AuthController>().profileModel.stores[0].reviewsSection ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('reviews'.tr, style: robotoMedium),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  storeController.itemReviewList != null ? storeController.itemReviewList.length > 0 ? ListView.builder(
                    itemCount: storeController.itemReviewList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ReviewWidget(
                        review: storeController.itemReviewList[index], fromStore: false,
                        hasDivider: index != storeController.itemReviewList.length-1,
                      );
                    },
                  ) : Padding(
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                    child: Center(child: Text('no_review_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                  ) : Padding(
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ) : SizedBox(),

            ]),
          )),

          CustomButton(
            onPressed: () {
              if(Get.find<AuthController>().profileModel.stores[0].itemSection) {
                // TODO: add product
                Get.toNamed(RouteHelper.getItemRoute(item));
              }else {
                showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
              }
            },
            buttonText: 'update_item'.tr,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          ),

        ]);
      }),
    );
  }
}
