import 'package:sixam_mart_store/controller/notification_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/screens/notification/widget/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<NotificationController>().getNotificationList();

    return Scaffold(
      appBar: CustomAppBar(title: 'notification'.tr),
      body: GetBuilder<NotificationController>(builder: (notificationController) {
        if(notificationController.notificationList != null) {
          notificationController.saveSeenNotificationCount(notificationController.notificationList.length);
        }
        List<DateTime> _dateTimeList = [];
        return notificationController.notificationList != null ? notificationController.notificationList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await notificationController.getNotificationList();
          },
          child: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(width: 1170, child: ListView.builder(
            itemCount: notificationController.notificationList.length,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DateTime _originalDateTime = DateConverter.dateTimeStringToDate(notificationController.notificationList[index].createdAt);
              DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
              bool _addTitle = false;
              if(!_dateTimeList.contains(_convertedDate)) {
                _addTitle = true;
                _dateTimeList.add(_convertedDate);
              }
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                _addTitle ? Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(DateConverter.dateTimeStringToDateOnly(notificationController.notificationList[index].createdAt)),
                ) : SizedBox(),

                ListTile(
                  onTap: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return NotificationDialog(notificationModel: notificationController.notificationList[index]);
                    });
                  },
                  leading: ClipOval(child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder, height: 40, width: 40, fit: BoxFit.cover,
                    image: '${Get.find<SplashController>().configModel.baseUrls.notificationImageUrl}'
                        '/${notificationController.notificationList[index].image}',
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 40, width: 40, fit: BoxFit.cover),
                  )),
                  title: Text(
                    notificationController.notificationList[index].title ?? '',
                    style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                  subtitle: Text(
                    notificationController.notificationList[index].description ?? '',
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Divider(color: Theme.of(context).disabledColor),
                ),

              ]);
            },
          ))))),
        ) : Center(child: Text('no_notification_found'.tr)) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
