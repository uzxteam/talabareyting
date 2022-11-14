import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttributeView extends StatefulWidget {
  final StoreController storeController;
  final Item product;
  AttributeView({@required this.storeController, @required this.product});

  @override
  State<AttributeView> createState() => _AttributeViewState();
}

class _AttributeViewState extends State<AttributeView> {
  @override
  Widget build(BuildContext context) {
    bool _stock = Get.find<SplashController>().configModel.moduleConfig.module.stock;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text(
        'attribute'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.storeController.attributeList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => widget.storeController.toggleAttribute(index, widget.product),
              child: Container(
                width: 100, alignment: Alignment.center,
                margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                decoration: BoxDecoration(
                  color: widget.storeController.attributeList[index].active ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Text(
                  widget.storeController.attributeList[index].attribute.name, maxLines: 2, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: widget.storeController.attributeList[index].active ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(height: widget.storeController.attributeList.where((element) => element.active).length > 0 ? Dimensions.PADDING_SIZE_LARGE : 0),

      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.storeController.attributeList.length,
        itemBuilder: (context, index) {
          return widget.storeController.attributeList[index].active ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [

              Container(
                width: 100, height: 50, alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Text(
                  widget.storeController.attributeList[index].attribute.name, maxLines: 2, textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                ),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

              Expanded(child: MyTextField(
                controller: widget.storeController.attributeList[index].controller,
                inputAction: TextInputAction.done,
                capitalization: TextCapitalization.words,
                title: false,
              )),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              CustomButton(
                onPressed: () {
                  String _variant = widget.storeController.attributeList[index].controller.text.trim();
                  if(_variant.isEmpty) {
                    showCustomSnackBar('enter_a_variant_name'.tr);
                  }else {
                    widget.storeController.attributeList[index].controller.text = '';
                    widget.storeController.addVariant(index, _variant, widget.product);
                  }
                },
                buttonText: 'add'.tr,
                width: 70, height: 50,
              ),

            ]),

            Container(
              height: 30, margin: EdgeInsets.only(left: 120),
              child: widget.storeController.attributeList[index].variants.length > 0 ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                itemCount: widget.storeController.attributeList[index].variants.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    ),
                    child: Row(children: [
                      Text(widget.storeController.attributeList[index].variants[i], style: robotoRegular),
                      InkWell(
                        onTap: () => widget.storeController.removeVariant(index, i, widget.product),
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Icon(Icons.close, size: 15),
                        ),
                      ),
                    ]),
                  );
                },
              ) : Align(alignment: Alignment.centerLeft, child: Text('no_variant_added_yet'.tr)),
            ),

            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          ]) : SizedBox();
        },
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.storeController.variantTypeList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
            ),
            child: Column(children: [

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${'variant'.tr}:',
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Text(
                  widget.storeController.variantTypeList[index].variantType,
                  style: robotoRegular, textAlign: TextAlign.center, maxLines: 1,
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              Row(children: [

                Expanded(child: MyTextField(
                  hintText: 'price'.tr,
                  controller: widget.storeController.variantTypeList[index].priceController,
                  focusNode: widget.storeController.variantTypeList[index].priceNode,
                  nextFocus: _stock ? widget.storeController.variantTypeList[index].stockNode : index != widget.storeController.variantTypeList.length-1
                      ? widget.storeController.variantTypeList[index+1].priceNode : null,
                  inputAction: (_stock && index != widget.storeController.variantTypeList.length-1) ? TextInputAction.next : TextInputAction.done,
                  isAmount: true,
                  amountIcon: true,
                )),
                SizedBox(width: _stock ? Dimensions.PADDING_SIZE_SMALL : 0),

                _stock ? Expanded(child: MyTextField(
                  hintText: 'stock'.tr,
                  controller: widget.storeController.variantTypeList[index].stockController,
                  focusNode: widget.storeController.variantTypeList[index].stockNode,
                  nextFocus: index != widget.storeController.variantTypeList.length-1 ? widget.storeController.variantTypeList[index+1].priceNode : null,
                  inputAction: index != widget.storeController.variantTypeList.length-1 ? TextInputAction.next : TextInputAction.done,
                  isNumber: true,
                  onChanged: (String text) => Get.find<StoreController>().setTotalStock(),
                )) : SizedBox(),

              ]),

            ]),
          );
        },
      ),
      SizedBox(height: widget.storeController.hasAttribute() ? Dimensions.PADDING_SIZE_LARGE : 0),

    ]);
  }
}
