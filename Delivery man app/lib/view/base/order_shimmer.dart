import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderShimmer extends StatelessWidget {
  final bool isEnabled;
  OrderShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
      ),
      child: Shimmer(
        duration: Duration(seconds: 2),
        enabled: isEnabled,
        child: Column(children: [

          Row(children: [
            Container(height: 15, width: 100, color: Colors.grey[300]),
            Expanded(child: SizedBox()),
            Container(width: 7, height: 7, decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle)),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Container(height: 15, width: 70, color: Colors.grey[300]),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(Images.house, width: 20, height: 15),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Container(height: 15, width: 200, color: Colors.grey[300]),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(Icons.location_on, size: 20),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Container(height: 15, width: 200, color: Colors.grey[300]),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

          Row(children: [
            Expanded(child: Container(height: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5)))),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(child: Container(height: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5)))),
          ]),

        ]),
      ),
    );
  }
}
