import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:sixam_mart_delivery/controller/order_controller.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRequestDialog extends StatefulWidget {
  final bool isRequest;
  final Function onTap;
  NewRequestDialog({@required this.isRequest, @required this.onTap});

  @override
  State<NewRequestDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NewRequestDialog> {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  void _startAlarm() {
    AudioCache _audio = AudioCache();
    _audio.play('notification.mp3');
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _audio.play('notification.mp3');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Image.asset(Images.notification_in, height: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              widget.isRequest ? 'new_order_request_from_a_customer'.tr : 'you_have_assigned_a_new_order'.tr, textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
          ),

          CustomButton(
            height: 40,
            buttonText: widget.isRequest ? (Get.find<OrderController>().currentOrderList != null
                && Get.find<OrderController>().currentOrderList.length > 0) ? 'ok'.tr : 'go'.tr : 'ok'.tr,
            onPressed: () {
              if(!widget.isRequest) {
                _timer?.cancel();
              }
              Get.back();
              widget.onTap();
            },
          ),

        ]),
      ),
    );
  }
}
