import 'package:sixam_mart_store/helper/price_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletWidget extends StatelessWidget {
  final String title;
  final double value;
  WalletWidget({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE, horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 0.5, blurRadius: 5)],
      ),
      alignment: Alignment.center,
      child: Column(children: [

        Text(
          PriceConverter.convertPrice(value),
          style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Text(
          title, textAlign: TextAlign.center,
          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
        ),

      ]),
    ));
  }
}
