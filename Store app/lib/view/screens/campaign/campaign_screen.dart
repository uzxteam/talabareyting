import 'package:sixam_mart_store/controller/campaign_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/screens/campaign/widget/campaign_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<CampaignController>().getCampaignList();

    return Scaffold(

      appBar: CustomAppBar(title: 'campaign'.tr, menuWidget: PopupMenuButton(
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            getMenuItem('all', context),
            PopupMenuDivider(),
            getMenuItem('joined', context),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
        offset: Offset(-25, 25),
        child: Container(
          width: 40, height: 40,
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          ),
          child: Icon(Icons.arrow_drop_down, size: 30),
        ),
        onSelected: (value) {
          Get.find<CampaignController>().filterCampaign(value);
        },
      )),

      body: GetBuilder<CampaignController>(builder: (campaignController) {
        return campaignController.campaignList != null ? campaignController.campaignList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await Get.find<CampaignController>().getCampaignList();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemCount: campaignController.campaignList.length,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CampaignWidget(campaignModel: campaignController.campaignList[index]);
            },
          ),
        ) : Center(child: Text('no_campaign_available'.tr)) : Center(child: CircularProgressIndicator());
      }),
    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      child: Text(status.tr, style: robotoRegular.copyWith(color: status == 'joined' ? Colors.green : null)),
      value: status,
      height: 30,
    );
  }

}
