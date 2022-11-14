import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  final String title;
  final int count;
  CountWidget({@required this.title, @required this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
        child: Column(children: [

          Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).cardColor)),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Image.asset(Images.order, color: Theme.of(context).cardColor, height: 12, width: 12),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Text(count.toString(), style: robotoMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).cardColor,
            )),

          ]),

        ]),
      ),
    );
  }
}
