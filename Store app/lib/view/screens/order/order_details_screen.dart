import 'package:photo_view/photo_view.dart';
import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/localization_controller.dart';
import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/order_details_model.dart';
import 'package:sixam_mart_store/data/model/response/order_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/order/widget/order_item_widget.dart';
import 'package:sixam_mart_store/view/screens/order/widget/slider_button.dart';
import 'package:sixam_mart_store/view/screens/order/widget/verify_delivery_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunningOrder;
  OrderDetailsScreen({@required this.orderModel, @required this.isRunningOrder});

  @override
  Widget build(BuildContext context) {
    bool _cancelPermission = Get.find<SplashController>().configModel.canceledByStore;
    bool _selfDelivery = Get.find<AuthController>().profileModel.stores[0].selfDeliverySystem == 1;
    bool _pending = orderModel.orderStatus == AppConstants.PENDING;
    bool _processing = orderModel.orderStatus == AppConstants.PROCESSING;
    bool _accepted = orderModel.orderStatus == AppConstants.ACCEPTED;
    bool _confirmed = orderModel.orderStatus == AppConstants.CONFIRMED;
    bool _handover = orderModel.orderStatus == AppConstants.HANDOVER;
    bool _pickedUp = orderModel.orderStatus == AppConstants.PICKED_UP;
    bool _cod = orderModel.paymentMethod == 'cash_on_delivery';
    bool _takeAway = orderModel.orderType == 'take_away';

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      Get.find<OrderController>().getCurrentOrders();
      String _type = message.data['type'];
      if(isRunningOrder && _type == 'order_status') {
        Get.back();
      }
    });

    Get.find<OrderController>().getOrderDetails(orderModel.id);
    bool _restConfModel = Get.find<SplashController>().configModel.orderConfirmationModel != 'deliveryman';
    bool _showSlider = (_pending && (_takeAway || _restConfModel || _selfDelivery)) || _confirmed || _processing
        || (_accepted && orderModel.confirmed != null) || (_handover && (_selfDelivery || _takeAway));
    bool _showBottomView = _showSlider || _pickedUp || isRunningOrder;

    return Scaffold(
      appBar: CustomAppBar(title: 'order_details'.tr),
      body: GetBuilder<OrderController>(builder: (orderController) {
        double _deliveryCharge = 0;
        double _itemsPrice = 0;
        double _discount = 0;
        double _couponDiscount = 0;
        double _tax = 0;
        double _addOns = 0;
        OrderModel _order = orderModel;
        if(orderController.orderDetailsModel != null) {
          if(_order.orderType == 'delivery') {
            _deliveryCharge = _order.deliveryCharge;
          }
          _discount = _order.storeDiscountAmount;
          _tax = _order.totalTaxAmount;
          _couponDiscount = _order.couponDiscountAmount;
          for(OrderDetailsModel orderDetails in orderController.orderDetailsModel) {
            for(AddOn addOn in orderDetails.addOns) {
              _addOns = _addOns + (addOn.price * addOn.quantity);
            }
            _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.quantity);
          }
        }
        double _subTotal = _itemsPrice + _addOns;
        double _total = _itemsPrice + _addOns - _discount + _tax + _deliveryCharge - _couponDiscount;

        return orderController.orderDetailsModel != null ? Column(children: [

          Expanded(child: Scrollbar(child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Center(child: SizedBox(width: 1170, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                Text('${'order_id'.tr}:', style: robotoRegular),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(_order.id.toString(), style: robotoMedium),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Expanded(child: SizedBox()),
                Icon(Icons.watch_later, size: 17),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  DateConverter.dateTimeStringToDateTime(_order.createdAt),
                  style: robotoRegular,
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              _order.scheduled == 1 ? Row(children: [
                Text('${'scheduled_at'.tr}:', style: robotoRegular),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(DateConverter.dateTimeStringToDateTime(_order.scheduleAt), style: robotoMedium),
              ]) : SizedBox(),
              SizedBox(height: _order.scheduled == 1 ? Dimensions.PADDING_SIZE_SMALL : 0),

              Row(children: [
                Text(_order.orderType.tr, style: robotoMedium),
                Expanded(child: SizedBox()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                  child: Text(
                    _order.paymentMethod == 'cash_on_delivery' ? 'cash_on_delivery'.tr : 'digital_payment'.tr,
                    style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                  ),
                ),
              ]),
              Divider(height: Dimensions.PADDING_SIZE_LARGE),

              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Row(children: [
                  Text('${'item'.tr}:', style: robotoRegular),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    orderController.orderDetailsModel.length.toString(),
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Expanded(child: SizedBox()),
                  Container(height: 7, width: 7, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    _order.orderStatus == 'delivered' ? '${'delivered_at'.tr} ${DateConverter.dateTimeStringToDateTime(_order.delivered)}'
                        : _order.orderStatus.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                ]),
              ),
              Divider(height: Dimensions.PADDING_SIZE_LARGE),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orderController.orderDetailsModel.length,
                itemBuilder: (context, index) {
                  return OrderItemWidget(order: _order, orderDetails: orderController.orderDetailsModel[index]);
                },
              ),

              (_order.orderNote  != null && _order.orderNote.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('additional_note'.tr, style: robotoRegular),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Container(
                  width: 1170,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                  ),
                  child: Text(
                    _order.orderNote,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              ]) : SizedBox(),

              (Get.find<SplashController>().getModule(_order.moduleType).orderAttachment && _order.orderAttachment != null
              && _order.orderAttachment.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('prescription'.tr, style: robotoRegular),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                InkWell(
                  onTap: () => openDialog(context, '${Get.find<SplashController>().configModel.baseUrls.orderAttachmentUrl}/${_order.orderAttachment}'),
                  child: Center(child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    child: CustomImage(
                      image: '${Get.find<SplashController>().configModel.baseUrls.orderAttachmentUrl}/${_order.orderAttachment}',
                      width: 200,
                    ),
                  )),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              ]) : SizedBox(),

              Text('customer_details'.tr, style: robotoRegular),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Row(children: [
                ClipOval(child: CustomImage(
                  image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${_order.customer != null ?_order.customer.image : ''}',
                  height: 35, width: 35, fit: BoxFit.cover,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    _order.deliveryAddress.contactPersonName, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                  Text(
                    _order.deliveryAddress.address, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                  ),

                  Wrap(children: [
                    (_order.deliveryAddress.streetNumber != null && _order.deliveryAddress.streetNumber.isNotEmpty) ? Text('street_number'.tr+ ': ' + _order.deliveryAddress.streetNumber  + ', ',
                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                    ) : SizedBox(),

                    (_order.deliveryAddress.house != null && _order.deliveryAddress.house.isNotEmpty) ? Text('house'.tr +': ' + _order.deliveryAddress.house  + ', ',
                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                    ) : SizedBox(),

                    (_order.deliveryAddress.floor != null && _order.deliveryAddress.floor.isNotEmpty) ? Text('floor'.tr+': ' + _order.deliveryAddress.floor ,
                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                    ) : SizedBox(),
                  ]),

                ])),

                (_takeAway && (_pending || _confirmed || _processing)) ? TextButton.icon(
                  onPressed: () async {
                    String url ='https://www.google.com/maps/dir/?api=1&destination=${_order.deliveryAddress.latitude}'
                        ',${_order.deliveryAddress.longitude}&mode=d';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url, mode: LaunchMode.externalApplication);
                    }else {
                      showCustomSnackBar('unable_to_launch_google_map'.tr);
                    }
                  },
                  icon: Icon(Icons.directions), label: Text('direction'.tr),
                ) : SizedBox(),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              // Total
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('item_price'.tr, style: robotoRegular),
                Text(PriceConverter.convertPrice(_itemsPrice), style: robotoRegular),
              ]),
              SizedBox(height: 10),

              Get.find<SplashController>().getModule(_order.moduleType).addOn ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('addons'.tr, style: robotoRegular),
                  Text('(+) ${PriceConverter.convertPrice(_addOns)}', style: robotoRegular),
                ],
              ) : SizedBox(),

              Get.find<SplashController>().getModule(_order.moduleType).addOn ? Divider(
                thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5),
              ) : SizedBox(),

              Get.find<SplashController>().getModule(_order.moduleType).addOn ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('subtotal'.tr, style: robotoMedium),
                  Text(PriceConverter.convertPrice(_subTotal), style: robotoMedium),
                ],
              ) : SizedBox(),
              SizedBox(height: Get.find<SplashController>().getModule(_order.moduleType).addOn ? 10 : 0),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('discount'.tr, style: robotoRegular),
                Text('(-) ${PriceConverter.convertPrice(_discount)}', style: robotoRegular),
              ]),
              SizedBox(height: 10),

              _couponDiscount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('coupon_discount'.tr, style: robotoRegular),
                Text(
                  '(-) ${PriceConverter.convertPrice(_couponDiscount)}',
                  style: robotoRegular,
                ),
              ]) : SizedBox(),
              SizedBox(height: _couponDiscount > 0 ? 10 : 0),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('vat_tax'.tr, style: robotoRegular),
                Text('(+) ${PriceConverter.convertPrice(_tax)}', style: robotoRegular),
              ]),
              SizedBox(height: 10),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('delivery_fee'.tr, style: robotoRegular),
                Text('(+) ${PriceConverter.convertPrice(_deliveryCharge)}', style: robotoRegular),
              ]),

              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('total_amount'.tr, style: robotoMedium.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor,
                )),
                Text(
                  PriceConverter.convertPrice(_total),
                  style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
                ),
              ]),

            ]))),
          ))),

          _showBottomView ? _pickedUp ? Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              border: Border.all(width: 1),
            ),
            alignment: Alignment.center,
            child: Text('item_is_on_the_way'.tr, style: robotoMedium),
          ) : _showSlider ? (_pending && (_takeAway || _restConfModel || _selfDelivery) && _cancelPermission) ? Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [

              Expanded(child: TextButton(
                onPressed: () => Get.dialog(ConfirmationDialog(
                  icon: Images.warning, title: 'are_you_sure_to_cancel'.tr, description: 'you_want_to_cancel_this_order'.tr,
                  onYesPressed: () {
                    orderController.updateOrderStatus(orderModel.id, AppConstants.CANCELED, back: true);
                  },
                ), barrierDismissible: false),
                style: TextButton.styleFrom(
                  minimumSize: Size(1170, 40), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    side: BorderSide(width: 1, color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ),
                child: Text('cancel'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
              )),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Expanded(child: CustomButton(
                buttonText: 'confirm'.tr, height: 40,
                onPressed: () {
                  Get.dialog(ConfirmationDialog(
                    icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                    onYesPressed: () {
                      orderController.updateOrderStatus(orderModel.id, AppConstants.CONFIRMED, back: true);
                    },
                  ), barrierDismissible: false);
                },
              )),

            ]),
          ) : SliderButton(
            action: () {

              if(_pending && (_takeAway || _restConfModel || _selfDelivery))  {
                Get.dialog(ConfirmationDialog(
                  icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                  onYesPressed: () {
                    orderController.updateOrderStatus(orderModel.id, AppConstants.CONFIRMED, back: true);
                  },
                  onNoPressed: () {
                    if(_cancelPermission) {
                      orderController.updateOrderStatus(orderModel.id, AppConstants.CANCELED, back: true);
                    }else {
                      Get.back();
                    }
                  },
                ), barrierDismissible: false);
              }

              else if(_processing) {
                Get.find<OrderController>().updateOrderStatus(orderModel.id, AppConstants.HANDOVER);
              }

              else if(_confirmed || (_accepted && orderModel.confirmed != null)) {
                Get.find<OrderController>().updateOrderStatus(orderModel.id, AppConstants.PROCESSING);
              }

              else if((_handover && (_takeAway || _selfDelivery))) {
                if (Get.find<SplashController>().configModel.orderDeliveryVerification || _cod) {
                  Get.bottomSheet(VerifyDeliverySheet(
                    orderID: orderModel.id, verify: Get.find<SplashController>().configModel.orderDeliveryVerification,
                    orderAmount: orderModel.orderAmount, cod: _cod,
                  ), isScrollControlled: true);
                } else {
                  Get.find<OrderController>().updateOrderStatus(orderModel.id, AppConstants.DELIVERED);
                }
              }

            },
            label: Text(
              (_pending && (_takeAway || _restConfModel || _selfDelivery)) ? 'swipe_to_confirm_order'.tr
                  : (_confirmed || (_accepted && orderModel.confirmed != null))
                  ? Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText ? 'swipe_to_cooking'.tr : 'swipe_to_process'.tr
                  : _processing ? 'swipe_if_ready_for_handover'.tr
                  : (_handover && (_takeAway || _selfDelivery)) ? 'swipe_to_deliver_order'.tr : '',
              style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
            ),
            dismissThresholds: 0.5, dismissible: false, shimmer: true,
            width: 1170, height: 60, buttonSize: 50, radius: 10,
            icon: Center(child: Icon(
              Get.find<LocalizationController>().isLtr ? Icons.double_arrow_sharp : Icons.keyboard_arrow_left,
              color: Colors.white, size: 20.0,
            )),
            isLtr: Get.find<LocalizationController>().isLtr,
            boxShadow: BoxShadow(blurRadius: 0),
            buttonColor: Theme.of(context).primaryColor,
            backgroundColor: Color(0xffF4F7FC),
            baseColor: Theme.of(context).primaryColor,
          ) : SizedBox() : SizedBox(),

        ]) : Center(child: CircularProgressIndicator());
      }),
    );
  }

  void openDialog(BuildContext context, String imageUrl) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE)),
        child: Stack(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
            child: PhotoView(
              tightMode: true,
              imageProvider: NetworkImage(imageUrl),
              heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
            ),
          ),

          Positioned(top: 0, right: 0, child: IconButton(
            splashRadius: 5,
            onPressed: () => Get.back(),
            icon: Icon(Icons.cancel, color: Colors.red),
          )),

        ]),
      );
    },
  );

}
