import 'dart:typed_data';

import 'package:sixam_mart_store/controller/addon_controller.dart';
import 'package:sixam_mart_store/controller/store_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/model/response/attribute_model.dart';
import 'package:sixam_mart_store/data/model/response/config_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/data/model/response/variant_type_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_drop_down.dart';
import 'package:sixam_mart_store/view/base/custom_image.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/base/custom_time_picker.dart';
import 'package:sixam_mart_store/view/base/my_text_field.dart';
import 'package:sixam_mart_store/view/screens/store/widget/attribute_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemScreen extends StatefulWidget {
  final Item item;
  final List<Translation> translations;
  AddItemScreen({@required this.item, @required this.translations});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  TextEditingController _c = TextEditingController();
  final FocusNode _priceNode = FocusNode();
  final FocusNode _discountNode = FocusNode();
  bool _update;
  Item _item;
  Module _module = Get.find<SplashController>().configModel.moduleConfig.module;

  @override
  void initState() {
    super.initState();

    _update = widget.item != null;
    Get.find<StoreController>().getAttributeList(widget.item);
    if(_update) {
      _item = Item.fromJson(widget.item.toJson());
      _priceController.text = _item.price.toString();
      _discountController.text = _item.discount.toString();
      _stockController.text = _item.stock.toString();
      Get.find<StoreController>().setDiscountTypeIndex(_item.discountType == 'percent' ? 0 : 1, false);
      Get.find<StoreController>().setVeg(_item.veg == 1, false);
    }else {
      _item = Item(images: []);
      Get.find<StoreController>().pickImage(false, true);
      Get.find<StoreController>().setVeg(false, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.item != null ? 'update_item'.tr : 'add_item'.tr),
      body: GetBuilder<StoreController>(builder: (storeController) {
        List<String> _unitList = [];
        if(storeController.unitList != null) {
          for(int index=0; index<storeController.unitList.length; index++) {
            _unitList.add(storeController.unitList[index].unit);
          }
        }

        List<String> _categoryList = [];
        if(storeController.categoryList != null) {
          for(int index=0; index<storeController.categoryList.length; index++) {
            _categoryList.add(storeController.categoryList[index].name);
          }
        }

        List<String> _subCategory = [];
        if(storeController.subCategoryList != null) {
          for(int index=0; index<storeController.subCategoryList.length; index++) {
            _subCategory.add(storeController.subCategoryList[index].name);
          }
        }

        if(_module.stock && storeController.variantTypeList.length > 0) {
          _stockController.text = storeController.totalStock.toString();
        }

        return (storeController.attributeList != null && storeController.categoryList != null && (widget.item != null ? storeController.subCategoryList != null : true)) ? Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              MyTextField(
                hintText: 'price'.tr,
                controller: _priceController,
                focusNode: _priceNode,
                nextFocus: _discountNode,
                isAmount: true,
                amountIcon: true,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [

                Expanded(child: MyTextField(
                  hintText: 'discount'.tr,
                  controller: _discountController,
                  focusNode: _discountNode,
                  isAmount: true,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'discount_type'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                    ),
                    child: DropdownButton<String>(
                      value: storeController.discountTypeIndex == 0 ? 'percent' : 'amount',
                      items: <String>['percent', 'amount'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.tr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        storeController.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);
                      },
                      isExpanded: true,
                      underline: SizedBox(),
                    ),
                  ),
                ])),

              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              (_module.vegNonVeg && Get.find<SplashController>().configModel.toggleVegNonVeg) ? Align(alignment: Alignment.centerLeft, child: Text(
                'item_type'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              )) : SizedBox(),
              (_module.vegNonVeg && Get.find<SplashController>().configModel.toggleVegNonVeg) ? Row(children: [

                Expanded(child: RadioListTile<String>(
                  title: Text(
                    'non_veg'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                  groupValue: storeController.isVeg ? 'veg' : 'non_veg',
                  value: 'non_veg',
                  contentPadding: EdgeInsets.zero,
                  onChanged: (String value) => storeController.setVeg(value == 'veg', true),
                  activeColor: Theme.of(context).primaryColor,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: RadioListTile<String>(
                  title: Text(
                    'veg'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                  groupValue: storeController.isVeg ? 'veg' : 'non_veg',
                  value: 'veg',
                  contentPadding: EdgeInsets.zero,
                  onChanged: (String value) => storeController.setVeg(value == 'veg', true),
                  activeColor: Theme.of(context).primaryColor,
                  dense: false,
                )),

              ]) : SizedBox(),
              SizedBox(height: (_module.vegNonVeg && Get.find<SplashController>().configModel.toggleVegNonVeg)
                  ? Dimensions.PADDING_SIZE_LARGE : 0),

              Row(children: [

                Expanded(child: CustomDropDown(
                  value: storeController.categoryIndex.toString(), title: 'category'.tr,
                  dataList: _categoryList, onChanged: (String value) {
                    storeController.setCategoryIndex(int.parse(value), true);
                    if(value != '0') {
                      storeController.getSubCategoryList(storeController.categoryList[int.parse(value)-1].id, null);
                    }
                  },
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: CustomDropDown(
                  value: storeController.subCategoryIndex.toString(),
                  title: 'sub_category'.tr,
                  dataList: _subCategory, onChanged: (String value) => storeController.setSubCategoryIndex(int.parse(value), true),
                )),

              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              AttributeView(storeController: storeController, product: widget.item),

              (_module.stock || _module.unit) ? Row(children: [
                _module.stock ? Expanded(child: MyTextField(
                  hintText: 'total_stock'.tr,
                  controller: _stockController,
                  isNumber: true,
                  isEnabled: storeController.variantTypeList.length <= 0,
                )) : SizedBox(),
                SizedBox(width: _module.stock ? Dimensions.PADDING_SIZE_SMALL : 0),

                _module.unit ? Expanded(child: CustomDropDown(
                  value: storeController.unitIndex.toString(), title: 'unit'.tr, dataList: _unitList,
                  onChanged: (String value) => storeController.setUnitIndex(int.parse(value), true),
                )) : SizedBox(),

              ]) : SizedBox(),
              SizedBox(height: (_module.stock || _module.unit) ? Dimensions.PADDING_SIZE_LARGE : 0),

              _module.addOn ? Text(
                'addons'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
              ) : SizedBox(),
              SizedBox(height: _module.addOn ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
              _module.addOn ? GetBuilder<AddonController>(builder: (addonController) {
                List<int> _addons = [];
                if(addonController.addonList != null) {
                  for(int index=0; index<addonController.addonList.length; index++) {
                    if(addonController.addonList[index].status == 1 && !storeController.selectedAddons.contains(index)) {
                      _addons.add(index);
                    }
                  }
                }
                return Autocomplete<int>(
                  optionsBuilder: (TextEditingValue value) {
                    if(value.text.isEmpty) {
                      return Iterable<int>.empty();
                    }else {
                      return _addons.where((addon) => addonController.addonList[addon].name.toLowerCase().contains(value.text.toLowerCase()));
                    }
                  },
                  fieldViewBuilder: (context, controller, node, onComplete) {
                    _c = controller;
                    return Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                      ),
                      child: TextField(
                        controller: controller,
                        focusNode: node,
                        onEditingComplete: () {
                          onComplete();
                          controller.text = '';
                        },
                        decoration: InputDecoration(
                          hintText: 'addons'.tr,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), borderSide: BorderSide.none),
                        ),
                      ),
                    );
                  },
                  displayStringForOption: (value) => addonController.addonList[value].name,
                  onSelected: (int value) {
                    _c.text = '';
                    storeController.setSelectedAddonIndex(value, true);
                    //_addons.removeAt(value);
                  },
                );
              }) : SizedBox(),
              SizedBox(height: (_module.addOn && storeController.selectedAddons.length > 0) ? Dimensions.PADDING_SIZE_SMALL : 0),
              _module.addOn ? SizedBox(
                height: storeController.selectedAddons.length > 0 ? 40 : 0,
                child: ListView.builder(
                  itemCount: storeController.selectedAddons.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      ),
                      child: Row(children: [
                        GetBuilder<AddonController>(builder: (addonController) {
                          return Text(
                            addonController.addonList[storeController.selectedAddons[index]].name,
                            style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                          );
                        }),
                        InkWell(
                          onTap: () => storeController.removeAddon(index),
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.close, size: 15, color: Theme.of(context).cardColor),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ) : SizedBox(),
              SizedBox(height: _module.addOn ? Dimensions.PADDING_SIZE_LARGE : 0),

              _module.itemAvailableTime ? Row(children: [

                Expanded(child: CustomTimePicker(
                  title: 'available_time_starts'.tr, time: _item.availableTimeStarts,
                  onTimeChanged: (time) => _item.availableTimeStarts = time,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: CustomTimePicker(
                  title: 'available_time_ends'.tr, time: _item.availableTimeEnds,
                  onTimeChanged: (time) => _item.availableTimeEnds = time,
                )),

              ]) : SizedBox(),
              SizedBox(height: _module.itemAvailableTime ? Dimensions.PADDING_SIZE_LARGE : 0),

              Row(children: [
                Text(
                  'thumbnail_image'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  '(${'max_size_2_mb'.tr})',
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).errorColor),
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Align(alignment: Alignment.center, child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: storeController.rawLogo != null ? Image.memory(
                    storeController.rawLogo, width: 150, height: 120, fit: BoxFit.cover,
                  ) : FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    image: '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${_item.image != null ? _item.image : ''}',
                    height: 120, width: 150, fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, width: 150, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0, right: 0, top: 0, left: 0,
                  child: InkWell(
                    onTap: () => storeController.pickImage(true, false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ])),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [
                Text(
                  'item_images'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(
                  '(${'max_size_2_mb'.tr})',
                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).errorColor),
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: (1/1),
                  mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL, crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: storeController.savedImages.length+storeController.rawImages.length+1,
                itemBuilder: (context, index) {
                  bool _savedImage = index < storeController.savedImages.length;
                  Uint8List _file = (_savedImage || index == (storeController.rawImages.length + storeController.savedImages.length))
                      ? null : storeController.rawImages[index-storeController.savedImages.length];
                  if(index == (storeController.rawImages.length + storeController.savedImages.length)) {
                    return InkWell(
                      onTap: () {
                        if((storeController.savedImages.length+storeController.rawImages.length) < 6) {
                          storeController.pickImages();
                        }else {
                          showCustomSnackBar('maximum_image_limit_is_6'.tr);
                        }
                      },
                      child: Container(
                        height: context.width, width: context.width, alignment: Alignment.center, decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      ),
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    ),
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        child: _savedImage ? CustomImage(
                          image: '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${storeController.savedImages[index]}',
                          width: context.width, height: context.width, fit: BoxFit.cover,
                        ) : Image.memory(
                          _file, width: context.width, height: context.width, fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0, top: 0,
                        child: InkWell(
                          onTap: () {
                            if(_savedImage) {
                              storeController.removeSavedImage(index);
                            }else {
                              storeController.removeImage(index - storeController.savedImages.length);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: Icon(Icons.delete_forever, color: Colors.red),
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),

            ]),
          )),

          !storeController.isLoading ? CustomButton(
            buttonText: _update ? 'update'.tr : 'submit'.tr,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            height: 50,
            onPressed: () {
              String _price = _priceController.text.trim();
              String _discount = _discountController.text.trim();
              bool _haveBlankVariant = false;
              bool _blankVariantPrice = false;
              bool _blankVariantStock = false;
              for(AttributeModel attr in storeController.attributeList) {
                if(attr.active && attr.variants.length == 0) {
                  _haveBlankVariant = true;
                  break;
                }
              }
              for(VariantTypeModel variantType in storeController.variantTypeList) {
                if(variantType.priceController.text.isEmpty) {
                  _blankVariantPrice = true;
                  break;
                }
                if(_module.stock && variantType.stockController.text.isEmpty) {
                  _blankVariantStock = true;
                  break;
                }
              }
              if(_price.isEmpty) {
                showCustomSnackBar('enter_item_price'.tr);
              }else if(_discount.isEmpty) {
                showCustomSnackBar('enter_item_discount'.tr);
              }else if(storeController.categoryIndex == 0) {
                showCustomSnackBar('select_a_category'.tr);
              }else if(_haveBlankVariant) {
                showCustomSnackBar('add_at_least_one_variant_for_every_attribute'.tr);
              }else if(_blankVariantPrice) {
                showCustomSnackBar('enter_price_for_every_variant'.tr);
              }else if(_module.stock && _blankVariantStock) {
                showCustomSnackBar('enter_stock_for_every_variant'.tr);
              }else if(_module.stock && storeController.variantTypeList.length<=0 && _stockController.text.trim().isEmpty) {
                showCustomSnackBar('enter_stock'.tr);
              }else if(_module.unit && storeController.unitIndex == 0) {
                showCustomSnackBar('add_an_unit'.tr);
              }else if(_module.itemAvailableTime && _item.availableTimeStarts == null) {
                showCustomSnackBar('pick_start_time'.tr);
              }else if(_module.itemAvailableTime && _item.availableTimeEnds == null) {
                showCustomSnackBar('pick_end_time'.tr);
              }else if(!_update && storeController.rawLogo == null) {
                showCustomSnackBar('upload_item_image'.tr);
              }else {
                _item.veg = storeController.isVeg ? 1 : 0;
                _item.price = double.parse(_price);
                _item.discount = double.parse(_discount);
                _item.discountType = storeController.discountTypeIndex == 0 ? 'percent' : 'amount';
                _item.categoryIds = [];
                _item.categoryIds.add(CategoryIds(id: storeController.categoryList[storeController.categoryIndex-1].id.toString()));
                if(storeController.subCategoryIndex != 0) {
                  _item.categoryIds.add(CategoryIds(id: storeController.subCategoryList[storeController.subCategoryIndex-1].id.toString()));
                }else {
                  if(_item.categoryIds.length > 1) {
                    _item.categoryIds.removeAt(1);
                  }
                }
                _item.addOns = [];
                storeController.selectedAddons.forEach((index) {
                  _item.addOns.add(Get.find<AddonController>().addonList[index]);
                });
                if(_module.unit) {
                  _item.unitType = storeController.unitList[storeController.unitIndex - 1].id.toString();
                }
                if(_module.stock) {
                  _item.stock = int.parse(_stockController.text.trim());
                }
                _item.translations = [];
                _item.translations.addAll(widget.translations);
                storeController.addItem(_item, widget.item == null);
              }
            },
          ) : Center(child: CircularProgressIndicator()),

        ]) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}