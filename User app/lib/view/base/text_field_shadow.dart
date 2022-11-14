import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
class TextFieldShadow extends StatelessWidget {
  final Widget child;
  const TextFieldShadow({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 0, blurRadius: 5, offset: Offset(0,3))],
      ),
      child: child,
    );
  }
}
