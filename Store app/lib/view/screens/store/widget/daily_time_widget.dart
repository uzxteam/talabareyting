import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/confirmation_dialog.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyTimeWidget extends StatelessWidget {
  final int weekDay;
  DailyTimeWidget({@required this.weekDay});

  @override
  Widget build(BuildContext context) {
    String _openingTime;
    String _closingTime;
    List<Schedules> _scheduleList = [];
    Get.find<StoreController>().scheduleList.forEach((schedule) {
      if(schedule.day == weekDay) {
        _scheduleList.add(schedule);
      }
    });
    String _dayString = weekDay == 1 ? 'monday' : weekDay == 2 ? 'tuesday' : weekDay == 3 ? 'wednesday' : weekDay == 4
        ? 'thursday' : weekDay == 5 ? 'friday' : weekDay == 6 ? 'saturday' : 'sunday';
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: Row(children: [

        Expanded(flex: 2, child: Text(_dayString.tr)),

        Text(':'),
        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Expanded(flex: 8, child: SizedBox(height: 50, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _scheduleList.length+1,
          itemBuilder: (context, index) {

            if(index == _scheduleList.length) {
              return InkWell(
                onTap: () => Get.dialog(Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE)),
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [

                      Text(
                        '${'schedule_for'.tr} ${_dayString.tr}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Row(children: [

                        Expanded(child: CustomTimePicker(
                          title: 'open_time'.tr, time: _openingTime,
                          onTimeChanged: (time) => _openingTime = time,
                        )),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        Expanded(child: CustomTimePicker(
                          title: 'close_time'.tr, time: _closingTime,
                          onTimeChanged: (time) => _closingTime = time,
                        )),

                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      GetBuilder<StoreController>(builder: (storeController) {
                        return storeController.scheduleLoading ? Center(child: CircularProgressIndicator()) : Row(children: [

                          Expanded(child: TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: Size(1170, 40), padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                            ),
                            child: Text(
                              'cancel'.tr, textAlign: TextAlign.center,
                              style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                            ),
                          )),
                          SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                          Expanded(child: CustomButton(
                            buttonText: 'add'.tr,
                            onPressed: () {
                              bool _overlapped = false;
                              if(_openingTime != null && _closingTime != null) {
                                for(int index=0; index<_scheduleList.length; index++) {
                                  if(_isUnderTime(_scheduleList[index].openingTime, _openingTime, _closingTime)
                                      || _isUnderTime(_scheduleList[index].closingTime, _openingTime, _closingTime)
                                      || _isUnderTime(_openingTime, _scheduleList[index].openingTime, _scheduleList[index].closingTime)
                                      || _isUnderTime(_closingTime, _scheduleList[index].openingTime, _scheduleList[index].closingTime)) {
                                    _overlapped = true;
                                    break;
                                  }
                                }
                              }
                              if(_openingTime == null) {
                                showCustomSnackBar('pick_start_time'.tr);
                              }else if(_closingTime == null) {
                                showCustomSnackBar('pick_end_time'.tr);
                              }else if(DateConverter.convertTimeToDateTime(_openingTime).isAfter(DateConverter.convertTimeToDateTime(_openingTime))) {
                                showCustomSnackBar('closing_time_must_be_after_the_opening_time'.tr);
                              }else if(_overlapped) {
                                showCustomSnackBar('this_schedule_is_overlapped'.tr);
                              }else {
                                storeController.addSchedule(Schedules(
                                  day: weekDay, openingTime: _openingTime, closingTime: _closingTime,
                                ));
                              }
                            },
                            height: 40,
                          )),

                        ]);
                      }),

                    ]),
                  ),
                ), barrierDismissible: false),
                child: Container(
                  height: 40, width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).textTheme.bodyText1.color, width: 1),
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Row(children: [

                  Text(
                    '${DateConverter.convertStringTimeToTime(_scheduleList[index].openingTime.substring(0, 5))} '
                        '- ${DateConverter.convertStringTimeToTime(_scheduleList[index].closingTime.substring(0, 5))}',
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  InkWell(
                    onTap: () => Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: 'are_you_sure_to_delete_this_schedule'.tr,
                      onYesPressed: () => Get.find<StoreController>().deleteSchedule(_scheduleList[index].id),
                    ), barrierDismissible: false),
                    child: Icon(Icons.cancel, color: Colors.red),
                  ),
                ]),
              ),
            );

          },
        ))),

      ]),
    );
  }

  bool _isUnderTime(String time, String startTime, String endTime) {
    return DateConverter.convertTimeToDateTime(time).isAfter(DateConverter.convertTimeToDateTime(startTime))
        && DateConverter.convertTimeToDateTime(time).isBefore(DateConverter.convertTimeToDateTime(endTime));
  }
}
