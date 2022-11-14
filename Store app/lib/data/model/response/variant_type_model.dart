import 'package:flutter/material.dart';

class VariantTypeModel {
  String variantType;
  TextEditingController priceController;
  TextEditingController stockController;
  FocusNode priceNode;
  FocusNode stockNode;

  VariantTypeModel({@required this.variantType, @required this.priceController, @required this.priceNode,
    @required this.stockController, @required this.stockNode});
}