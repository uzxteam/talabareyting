import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderShimmer extends StatelessWidget {
  final bool isEnabled;
  OrderShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: Duration(seconds: 2),
      enabled: isEnabled,
      child: Column(children: [

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 15, width: 100, color: Colors.grey[300]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Container(height: 10, width: 150, color: Colors.grey[300]),
            ]),

            Icon(Icons.keyboard_arrow_right, size: 30, color: Theme.of(context).disabledColor),

          ]),
        ),

        Divider(color: Theme.of(context).disabledColor),

      ]),
    );
  }
}
