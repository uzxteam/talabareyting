import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/view/base/rating_bar.dart';
import 'package:flutter/material.dart';

class ItemShimmer extends StatelessWidget {
  final bool isEnabled;
  final bool hasDivider;
  ItemShimmer({@required this.isEnabled, @required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    bool _desktop = false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(children: [

              Container(
                height: _desktop ? 120 : 65, width: _desktop ? 120 : 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Container(height: _desktop ? 20 : 15, width: double.maxFinite, color: Colors.grey[300]),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  RatingBar(rating: 0, size: _desktop ? 15 : 12, ratingCount: 0),
                  Row(children: [
                    Container(height: _desktop ? 20 : 15, width: 30, color: Colors.grey[300]),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Container(height: _desktop ? 15 : 10, width: 20, color: Colors.grey[300]),
                  ]),

                ]),
              ),

              Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                  child: Icon(Icons.add, size: _desktop ? 30 : 25),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                  child: Icon(
                    Icons.favorite_border,  size: _desktop ? 30 : 25,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ]),

            ]),
          ),
        ),
        _desktop ? SizedBox() : Padding(
          padding: EdgeInsets.only(left: _desktop ? 130 : 90),
          child: Divider(color: hasDivider ? Theme.of(context).disabledColor : Colors.transparent),
        ),
      ],
    );
  }
}
