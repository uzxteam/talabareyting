import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomDropDown extends StatefulWidget {
  final String value;
  final String title;
  final List<String> dataList;
  final Function(String value) onChanged;
  CustomDropDown({@required this.value, @required this.title, @required this.dataList, @required this.onChanged});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  int _value = 0;

  @override
  void initState() {
    super.initState();

    _value = (widget.value == null || widget.dataList == null || widget.dataList.length == 0) ? 0 : (int.parse(widget.value));
  }

  @override
  Widget build(BuildContext context) {
    List<int> _indexList = [];
    int _length = 1;
    if(widget.dataList != null) {
      _length = widget.dataList.length + 1;
    }
    for(int index=0; index<_length; index++) {
      _indexList.add(index);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.title != null ? Text(
        widget.title,
        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
      ) : SizedBox(),
      SizedBox(height: widget.title != null ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
      Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
        ),
        child: DropdownButton<int>(
          value: _value,
          items: _indexList.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value != 0 ? widget.dataList[value-1].tr : 'select'.tr),
            );
          }).toList(),
          onChanged: (int value) {
            widget.onChanged(value.toString());
            setState(() {
              _value = value;
            });
          },
          isExpanded: true,
          underline: SizedBox(),
        ),
      ),
    ]);
  }
}
