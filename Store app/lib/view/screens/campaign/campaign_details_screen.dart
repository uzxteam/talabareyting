import 'package:sixam_mart_store/controller/campaign_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/campaign_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignDetailsScreen extends StatelessWidget {
  final CampaignModel campaignModel;
  CampaignDetailsScreen({@required this.campaignModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(children: [

        Expanded(child: CustomScrollView(slivers: [

          SliverAppBar(
            expandedHeight: 230, toolbarHeight: 50,
            pinned: true, floating: false,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: Theme.of(context).cardColor),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CustomImage(
                fit: BoxFit.cover, placeholder: Images.restaurant_cover,
                image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}/${campaignModel.image}',
              ),
            ),
          ),

          SliverToBoxAdapter(child: Center(child: Container(
            width: 1170,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            color: Theme.of(context).cardColor,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}/${campaignModel.image}',
                    height: 40, width: 50, fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    campaignModel.title, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Row(children: [
                    Text('date'.tr, style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor,
                    )),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      '${DateConverter.convertDateToDate(campaignModel.availableDateStarts)}'
                          ' - ${DateConverter.convertDateToDate(campaignModel.availableDateEnds)}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                    ),
                  ]),
                  Row(children: [
                    Text('daily_time'.tr, style: robotoRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor,
                    )),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      '${DateConverter.convertStringTimeToTime(campaignModel.startTime)}'
                          ' - ${DateConverter.convertStringTimeToTime(campaignModel.endTime)}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                    ),
                  ]),
                ])),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              Text(
                campaignModel.description ?? 'no_description_found'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              ),

            ]),
          ))),

        ])),

        CustomButton(
          buttonText: campaignModel.isJoined ? 'leave_now'.tr : 'join_now'.tr,
          color: campaignModel.isJoined ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColor,
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          onPressed: () {
            Get.dialog(ConfirmationDialog(
              icon: Images.warning, description: campaignModel.isJoined ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
              onYesPressed: () {
                if(campaignModel.isJoined) {
                  Get.find<CampaignController>().leaveCampaign(campaignModel.id, true);
                }else {
                  Get.find<CampaignController>().joinCampaign(campaignModel.id, true);
                }
              },
            ));
          },
        ),

      ]),
    );
  }
}
