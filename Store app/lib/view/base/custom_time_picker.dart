import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTimePicker extends StatefulWidget {
  final String title;
  final String time;
  final Function(String) onTimeChanged;
  CustomTimePicker({@required this.title, @required this.time, @required this.onTimeChanged});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  String _myTime;

  @override
  void initState() {
    super.initState();

    _myTime = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text(
        widget.title, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      InkWell(
        onTap: () async {
          TimeOfDay _time = await showTimePicker(
            context: context, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
            builder: (BuildContext context, Widget child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: Get.find<SplashController>().configModel.timeformat == '24',
                ),
                child: child,
              );
            },
          );
          if(_time != null) {
            setState(() {
              _myTime = DateConverter.convertTimeToTime(DateTime(DateTime.now().year, 1, 1, _time.hour, _time.minute));
            });
            widget.onTimeChanged(_myTime);
          }
        },
        child: Container(
          height: 50, alignment: Alignment.center,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
          ),
          child: Row(children: [

            Text(
              _myTime != null ? DateConverter.convertStringTimeToTime(_myTime) : 'pick_time'.tr, style: robotoRegular,
              maxLines: 1,
            ),
            Expanded(child: SizedBox()),

            Icon(Icons.access_time, size: 20),

          ]),
        ),
      ),

    ]);
  }
}
