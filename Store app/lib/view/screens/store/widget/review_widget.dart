import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/review_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  final bool fromStore;
  ReviewWidget({@required this.review, @required this.hasDivider, @required this.fromStore});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Row(children: [

        ClipOval(
          child: CustomImage(
            image: '${fromStore ? Get.find<SplashController>().configModel.baseUrls.itemImageUrl
                : Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${fromStore
                ? review.itemImage : review.customer != null ? review.customer.image : ''}',
            height: 60, width: 60, fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

        Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(
            fromStore ? review.itemName : review.customer != null ?'${ review.customer.fName} ${ review.customer.lName}' : 'customer_not_found'.tr,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: review.customerName != null ? Theme.of(context).textTheme.headline1.color : Theme.of(context).disabledColor),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          RatingBar(rating: review.rating.toDouble(), ratingCount: null, size: 15),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          fromStore ? Text(
            review.customerName != null ? review.customerName : 'customer_not_found'.tr,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                color: review.customerName != null ? Theme.of(context).textTheme.headline1.color : Theme.of(context).disabledColor),
          ) : SizedBox(),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          Text(review.comment, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor)),

        ])),

      ]),

      hasDivider ? Padding(
        padding: EdgeInsets.only(left: 70),
        child: Divider(color: Theme.of(context).disabledColor),
      ) : SizedBox(),

    ]);
  }
}
