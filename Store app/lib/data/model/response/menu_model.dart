import 'package:flutter/material.dart';

class MenuModel {
  String icon;
  String title;
  String route;
  bool isBlocked;

  MenuModel({@required this.icon, @required this.title, @required this.route, this.isBlocked = false});
}