import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';

class ItemTitleView extends StatelessWidget {
  final Item item;
  final bool inStorePage;
  ItemTitleView({@required this.item,  this.inStorePage = false});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    double _startingPrice;
    double _endingPrice;
    if(item.variations.length != 0) {
      List<double> _priceList = [];
      item.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = item.price;
    }

    return ResponsiveHelper.isDesktop(context) ? GetBuilder<ItemController>(builder: (itemController){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name ?? '',
            style: robotoMedium.copyWith(fontSize: 30),
            maxLines: 2, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          InkWell(
            onTap: () {
              if(inStorePage) {
                Get.back();
              }else {
                Get.offNamed(RouteHelper.getStoreRoute(item.storeId, 'item'));
              }
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: Text(
                item.storeName,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          RatingBar(rating: item.avgRating, ratingCount: item.ratingCount, size: 21),
          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Row(children: [
            Text(
              '${PriceConverter.convertPrice(_startingPrice, discount: item.discount, discountType: item.discountType)}'
                  '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: item.discount, discountType: item.discountType)}' : ''}',
              style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: 30),
            ),
            const SizedBox(width: 10),
            item.discount > 0 ? Flexible(
              child: Text(
                '${PriceConverter.convertPrice(_startingPrice)}'
                    '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                style: robotoRegular.copyWith(color: Colors.red, decoration: TextDecoration.lineThrough,fontSize: Dimensions.fontSizeLarge),
              ),
            ) : SizedBox(),
          ]),

        ],);
    }) : Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: GetBuilder<ItemController>(
        builder: (itemController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [
              Expanded(child: Text(
                item.name ?? '',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              )),

              GetBuilder<WishListController>(
                  builder: (wishController) {
                    return Row(
                      children: [
                        // Text(
                        //   wishController.localWishes.contains(item.id) ? (item.wishlistCount+1).toString() : wishController.localRemovedWishes
                        //       .contains(item.id) ? (item.wishlistCount-1).toString() : item.wishlistCount.toString(),
                        //   style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                        // ),
                        // SizedBox(width: 5),

                        InkWell(
                          onTap: () {
                            if(_isLoggedIn){
                              if(wishController.wishItemIdList.contains(item.id)) {
                                wishController.removeFromWishList(item.id, false);
                              }else {
                                wishController.addToWishList(item, null, false);
                              }
                            }else showCustomSnackBar('you_are_not_logged_in'.tr);
                          },
                          child: Icon(
                            wishController.wishItemIdList.contains(item.id) ? Icons.favorite : Icons.favorite_border, size: 25,
                            color: wishController.wishItemIdList.contains(item.id) ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ]),
            SizedBox(height: 5),

            InkWell(
              onTap: () {
                if(inStorePage) {
                  Get.back();
                }else {
                  Get.offNamed(RouteHelper.getStoreRoute(item.storeId, 'item'));
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                child: Text(
                  item.storeName,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Text(
              '${PriceConverter.convertPrice(_startingPrice, discount: item.discount, discountType: item.discountType)}'
                  '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: item.discount, discountType: item.discountType)}' : ''}',
              style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
            ),
            SizedBox(height: 5),

            item.discount > 0 ? Text(
              '${PriceConverter.convertPrice(_startingPrice)}'
                  '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
              style: robotoRegular.copyWith(color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough),
            ) : SizedBox(),
            SizedBox(height: item.discount > 0 ? 5 : 0),

            Row(children: [

              Text(item.avgRating.toStringAsFixed(1), style: robotoRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.fontSizeLarge,
              )),
              SizedBox(width: 5),

              RatingBar(rating: item.avgRating, ratingCount: item.ratingCount),

            ]),

          ]);
        },
      ),
    );
  }
}
