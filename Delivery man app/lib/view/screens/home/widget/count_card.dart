import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CountCard extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String value;
  final double height;
  CountCard({@required this.backgroundColor, @required this.title, @required this.value, @required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        value != null ? Text(
          value, style: robotoBold.copyWith(fontSize: 40, color: Colors.white), textAlign: TextAlign.center,
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ) : Shimmer(
          duration: Duration(seconds: 2),
          enabled: value == null,
          color: Colors.grey[500],
          child: Container(height: 60, width: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5))),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Text(
          title,
          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.white),
          textAlign: TextAlign.center,
        ),

      ]),
    );
  }
}