import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class AmountCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  AmountCardWidget({@required this.title, @required this.value, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: color,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Text(value, style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white)),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Text(
          title, textAlign: TextAlign.center,
          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white),
        ),

      ]),
    ));
  }
}
