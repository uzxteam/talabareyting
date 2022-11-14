import 'package:sixam_mart_store/controller/campaign_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/campaign_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/screens/campaign/campaign_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignWidget extends StatelessWidget {
  final CampaignModel campaignModel;
  CampaignWidget({@required this.campaignModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        RouteHelper.getCampaignDetailsRoute(campaignModel.id),
        arguments: CampaignDetailsScreen(campaignModel: campaignModel),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            child: CustomImage(
              image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}/${campaignModel.image}',
              height: 85, width: 100, fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

            Text(campaignModel.title, style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Text(
              campaignModel.description ?? 'no_description_found'.tr, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Row(children: [

              InkWell(
                onTap: () {
                  Get.dialog(ConfirmationDialog(
                    icon: Images.warning, description: campaignModel.isJoined ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
                    onYesPressed: () {
                      if(campaignModel.isJoined) {
                        Get.find<CampaignController>().leaveCampaign(campaignModel.id, false);
                      }else {
                        Get.find<CampaignController>().joinCampaign(campaignModel.id, false);
                      }
                    },
                  ));
                },
                child: Container(
                  height: 25, width: 70, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: campaignModel.isJoined ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                  child: Text(campaignModel.isJoined ? 'leave_now'.tr : 'join_now'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(
                    color: Theme.of(context).cardColor,
                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  )),
                ),
              ),
              Expanded(child: SizedBox()),

              Icon(Icons.date_range, size: 15, color: Theme.of(context).disabledColor),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                DateConverter.convertDateToDate(campaignModel.availableDateStarts),
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor),
              ),

            ]),

          ])),

        ]),
      ),
    );
  }
}
