import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class BankField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputAction inputAction;
  final TextCapitalization capitalization;
  BankField(
      {this.hintText = '',
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.inputAction = TextInputAction.next,
        this.capitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text(hintText, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor)),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      TextField(
        controller: controller,
        focusNode: focusNode,
        style: robotoRegular,
        textInputAction: inputAction,
        cursorColor: Theme.of(context).primaryColor,
        textCapitalization: capitalization,
        autofocus: false,
        decoration: InputDecoration(
          hintText: hintText,
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).disabledColor.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), borderSide: BorderSide.none),
          hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
        ),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

    ]);
  }
}
