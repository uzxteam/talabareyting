import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String data;
  InfoWidget({@required this.icon, @required this.title, @required this.data});
  
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      
      Image.asset(icon, height: 20, width: 20, color: Theme.of(context).disabledColor),
      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

      Text('$title:', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).disabledColor)),
      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

      Flexible(child: Text(data, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),
      
    ]);
  }
}
