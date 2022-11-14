import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isButtonActive;
  final Function onTap;
  SwitchButton({@required this.icon, @required this.title, @required this.onTap, this.isButtonActive});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _buttonActive;

  @override
  void initState() {
    super.initState();

    _buttonActive = widget.isButtonActive;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(_buttonActive != null) {
          setState(() {
            _buttonActive = !_buttonActive;
          });
        }
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL,
          vertical: _buttonActive != null ? Dimensions.PADDING_SIZE_EXTRA_SMALL : Dimensions.PADDING_SIZE_DEFAULT,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [
          Icon(widget.icon, size: 25),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(child: Text(widget.title, style: robotoRegular)),
         _buttonActive != null ? Switch(
            value: _buttonActive,
            onChanged: (bool isActive) {
              if(_buttonActive != null) {
                setState(() {
                  _buttonActive = !_buttonActive;
                });
              }
              widget.onTap();
            },
            activeColor: Theme.of(context).primaryColor,
            activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
          ) : SizedBox(),
        ]),
      ),
    );
  }
}
