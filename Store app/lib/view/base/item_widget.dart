import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/discount_tag.dart';
import 'package:sixam_mart_store/view/base/not_available_widget.dart';
import 'package:sixam_mart_store/view/base/rating_bar.dart';
import 'package:sixam_mart_store/view/screens/store/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final int index;
  final int length;
  final bool inStore;
  final bool isCampaign;
  ItemWidget({@required this.item, @required this.index,
   @required this.length, this.inStore = false, this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    _discount = (item.storeDiscount == 0 || isCampaign) ? item.discount : item.storeDiscount;
    _discountType = (item.storeDiscount == 0 || isCampaign) ? item.discountType : 'percent';
    _isAvailable = DateConverter.isAvailable(item.availableTimeStarts, item.availableTimeEnds);

    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getItemDetailsRoute(item), arguments: ItemDetailsScreen(item: item)),
      child: Container(
        padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
          boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
            color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5,
          )] : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(children: [

              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image: '${isCampaign ? _baseUrls.campaignImageUrl : _baseUrls.itemImageUrl}/${item.image}',
                    height: _desktop ? 120 : 65, width: _desktop ? 120 : 80, fit: BoxFit.cover,
                  ),
                ),
                DiscountTag(
                  discount: _discount, discountType: _discountType,
                  freeDelivery: false,
                ),
                _isAvailable ? SizedBox() : NotAvailableWidget(isStore: false),
              ]),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text(
                    item.name,
                    style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    maxLines: _desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  RatingBar(
                    rating: item.avgRating, size: _desktop ? 15 : 12,
                    ratingCount: item.ratingCount,
                  ),

                  Row(children: [

                    Text(
                      PriceConverter.convertPrice(item.price, discount: _discount, discountType: _discountType),
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),
                    SizedBox(width: _discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),

                    _discount > 0 ? Text(
                      PriceConverter.convertPrice(item.price),
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        color: Theme.of(context).disabledColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ) : SizedBox(),

                  ]),

                ]),
              ),

              IconButton(
                onPressed: () {
                  if(Get.find<AuthController>().profileModel.stores[0].itemSection) {
                    // TODO: add product
                    Get.toNamed(RouteHelper.getItemRoute(item));
                  }else {
                    showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                  }
                },
                icon: Icon(Icons.edit, color: Colors.blue),
              ),

              IconButton(
                onPressed: () {
                  if(Get.find<AuthController>().profileModel.stores[0].itemSection) {
                    Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: 'are_you_sure_want_to_delete_this_product'.tr,
                      onYesPressed: () => Get.find<StoreController>().deleteItem(item.id),
                    ));
                  }else {
                    showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                  }
                },
                icon: Icon(Icons.delete_forever, color: Colors.red),
              ),

            ]),
          )),

          _desktop ? SizedBox() : Padding(
            padding: EdgeInsets.only(left: _desktop ? 130 : 90),
            child: Divider(color: index == length-1 ? Colors.transparent : Theme.of(context).disabledColor),
          ),

        ]),
      ),
    );
  }
}
