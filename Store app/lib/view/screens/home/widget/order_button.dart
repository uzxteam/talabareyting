import 'package:sixam_mart_store/controller/order_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class OrderButton extends StatelessWidget {
  final String title;
  final int index;
  final OrderController orderController;
  final bool fromHistory;
  OrderButton({@required this.title, @required this.index, @required this.orderController, @required this.fromHistory});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex;
    int _length = 0;
    int _titleLength = 0;
    if(fromHistory) {
      _selectedIndex = orderController.historyIndex;
      _titleLength = orderController.statusList.length;
      _length = 0;
    }else {
      _selectedIndex = orderController.orderIndex;
      _titleLength = orderController.runningOrders.length;
      _length = orderController.runningOrders[index].orderList.length;
    }
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => fromHistory ? orderController.setHistoryIndex(index) : orderController.setOrderIndex(index),
      child: Row(children: [

        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          ),
          alignment: Alignment.center,
          child: Text(
            '$title${fromHistory ? '' : ' ($_length)'}',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
              color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ),

        (index != _titleLength-1 && index != _selectedIndex && index != _selectedIndex-1) ? Container(
          height: 15, width: 1, color: Theme.of(context).disabledColor,
        ) : SizedBox(),

      ]),
    );
  }
}
