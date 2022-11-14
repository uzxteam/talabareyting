import 'package:sixam_mart_store/controller/pos_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/cart_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/rating_bar.dart';
import 'package:sixam_mart_store/view/screens/pos/widget/product_bottom_sheet.dart';
import 'package:sixam_mart_store/view/screens/pos/widget/quantity_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  PosProductWidget({@required this.cart, @required this.cartIndex, @required this.isAvailable, @required this.addOns});

  @override
  Widget build(BuildContext context) {
    String _addOnText = '';
    int _index = 0;
    List<int> _ids = [];
    List<int> _qtys = [];
    cart.addOnIds.forEach((addOn) {
      _ids.add(addOn.id);
      _qtys.add(addOn.quantity);
    });
    cart.item.addOns.forEach((addOn) {
      if (_ids.contains(addOn.id)) {
        _addOnText = _addOnText + '${(_index == 0) ? '' : ',  '}${addOn.name} (${_qtys[_index]})';
        _index = _index + 1;
      }
    });

    String _variationText = '';
    if(cart.variation.length > 0) {
      List<String> _variationTypes = cart.variation[0].type.split('-');
      if(_variationTypes.length == cart.item.choiceOptions.length) {
        int _index = 0;
        cart.item.choiceOptions.forEach((choice) {
          _variationText = _variationText + '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      }else {
        _variationText = cart.item.variations[0].type;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => ItemBottomSheet(item: cart.item, cartIndex: cartIndex, cart: cart),
          );
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
          child: Stack(children: [
            Positioned(
              top: 0, bottom: 0, right: 0, left: 0,
              child: Icon(Icons.delete, color: Colors.white, size: 50),
            ),
            Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) => Get.find<PosController>().removeFromCart(cartIndex),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 800 : 200],
                    blurRadius: 5, spreadRadius: 1,
                  )],
                ),
                child: Column(
                  children: [

                    Row(children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${cart.item.image}',
                              height: 65, width: 70, fit: BoxFit.cover,
                            ),
                          ),
                          isAvailable ? SizedBox() : Positioned(
                            top: 0, left: 0, bottom: 0, right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.black.withOpacity(0.6)),
                              child: Text('not_available_now_break'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                                color: Colors.white, fontSize: 8,
                              )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            cart.item.name,
                            style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          RatingBar(rating: cart.item.avgRating, size: 12, ratingCount: cart.item.ratingCount),
                          SizedBox(height: 5),
                          Text(
                            PriceConverter.convertPrice(cart.discountedPrice+cart.discountAmount),
                            style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                        ]),
                      ),

                      Row(children: [
                        QuantityButton(
                          onTap: () {
                            if (cart.quantity > 1) {
                              Get.find<PosController>().setQuantity(false, cart);
                            }else {
                              Get.find<PosController>().removeFromCart(cartIndex);
                            }
                          },
                          isIncrement: false,
                        ),
                        Text(cart.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                        QuantityButton(
                          onTap: () => Get.find<PosController>().setQuantity(true, cart),
                          isIncrement: true,
                        ),
                      ]),

                      !ResponsiveHelper.isMobile(context) ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: IconButton(
                          onPressed: () {
                            Get.find<PosController>().removeFromCart(cartIndex);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ) : SizedBox(),

                    ]),

                    _addOnText.isNotEmpty ? Padding(
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Row(children: [
                        SizedBox(width: 80),
                        Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                        Flexible(child: Text(
                          _addOnText,
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                        )),
                      ]),
                    ) : SizedBox(),

                    cart.item.variations.length > 0 ? Padding(
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Row(children: [
                        SizedBox(width: 80),
                        Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                        Flexible(child: Text(
                          _variationText,
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                        )),
                      ]),
                    ) : SizedBox(),

                    /*addOns.length > 0 ? SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                        itemCount: addOns.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(children: [
                              InkWell(
                                onTap: () {
                                  Get.find<CartController>().removeAddOn(cartIndex, index);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                                ),
                              ),
                              Text(addOns[index].name, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                              SizedBox(width: 2),
                              Text(
                                PriceConverter.convertPrice(addOns[index].price),
                                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '(${cart.addOnIds[index].quantity})',
                                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                            ]),
                          );
                        },
                      ),
                    ) : SizedBox(),*/

                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
