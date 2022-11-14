import 'dart:convert';
import 'dart:typed_data';

import 'package:sixam_mart_store/controller/addon_controller.dart';
import 'package:sixam_mart_store/controller/auth_controller.dart';
import 'package:sixam_mart_store/controller/splash_controller.dart';
import 'package:sixam_mart_store/data/api/api_checker.dart';
import 'package:sixam_mart_store/data/model/response/attr.dart';
import 'package:sixam_mart_store/data/model/response/category_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/data/model/response/attribute_model.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart';
import 'package:sixam_mart_store/data/model/response/review_model.dart';
import 'package:sixam_mart_store/data/model/response/unit_model.dart';
import 'package:sixam_mart_store/data/model/response/variant_type_model.dart';
import 'package:sixam_mart_store/data/repository/store_repo.dart';
import 'package:sixam_mart_store/helper/network_info.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StoreController extends GetxController implements GetxService {
  final StoreRepo storeRepo;
  StoreController({@required this.storeRepo});

  List<Item> _itemList;
  List<ReviewModel> _storeReviewList;
  List<ReviewModel> _itemReviewList;
  bool _isLoading = false;
  int _pageSize;
  List<String> _offsetList = [];
  int _offset = 1;
  List<AttributeModel> _attributeList;
  int _discountTypeIndex = 0;
  List<CategoryModel> _categoryList;
  List<CategoryModel> _subCategoryList;
  Uint8List _rawLogo;
  Uint8List _rawCover;
  List<int> _selectedAddons;
  List<VariantTypeModel> _variantTypeList;
  bool _isAvailable = true;
  List<Schedules> _scheduleList;
  bool _scheduleLoading = false;
  bool _isGstEnabled;
  int _tabIndex = 0;
  bool _isVeg = false;
  bool _isStoreVeg = true;
  bool _isStoreNonVeg = true;
  String _type = 'all';
  static List<String> _itemTypeList = ['all', 'veg', 'non_veg'];
  List<UnitModel> _unitList;
  int _totalStock = 0;
  List<Uint8List> _rawImages = [];
  List<String> _savedImages = [];
  int _imageIndex = 0;
  int _categoryIndex = 0;
  int _subCategoryIndex = 0;
  int _unitIndex = 0;
  List<String> _durations = ['min', 'hours', 'days'];
  int _durationIndex = 0;

  List<Item> get itemList => _itemList;
  List<ReviewModel> get storeReviewList => _storeReviewList;
  List<ReviewModel> get itemReviewList => _itemReviewList;
  bool get isLoading => _isLoading;
  int get pageSize => _pageSize;
  int get offset => _offset;
  List<AttributeModel> get attributeList => _attributeList;
  int get discountTypeIndex => _discountTypeIndex;
  List<CategoryModel> get categoryList => _categoryList;
  List<CategoryModel> get subCategoryList => _subCategoryList;
  Uint8List get rawLogo => _rawLogo;
  Uint8List get rawCover => _rawCover;
  List<int> get selectedAddons => _selectedAddons;
  List<VariantTypeModel> get variantTypeList => _variantTypeList;
  bool get isAvailable => _isAvailable;
  List<Schedules> get scheduleList => _scheduleList;
  bool get scheduleLoading => _scheduleLoading;
  bool get isGstEnabled => _isGstEnabled;
  int get tabIndex => _tabIndex;
  bool get isVeg => _isVeg;
  bool get isStoreVeg => _isStoreVeg;
  bool get isStoreNonVeg => _isStoreNonVeg;
  String get type => _type;
  List<String> get itemTypeList => _itemTypeList;
  List<UnitModel> get unitList => _unitList;
  int get totalStock => _totalStock;
  List<Uint8List> get rawImages => _rawImages;
  List<String> get savedImages => _savedImages;
  int get imageIndex => _imageIndex;
  int get categoryIndex => _categoryIndex;
  int get subCategoryIndex => _subCategoryIndex;
  int get unitIndex => _unitIndex;
  List<String> get durations => _durations;
  int get durationIndex => _durationIndex;

  Future<void> getItemList(String offset, String type) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _type = type;
      _itemList = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await storeRepo.getItemList(offset, type);
      if (response.statusCode == 200) {
        if (offset == '1') {
          _itemList = [];
        }
        _itemList.addAll(ItemModel.fromJson(response.body).items);
        _pageSize = ItemModel.fromJson(response.body).totalSize;
        _isLoading = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void getAttributeList(Item item) async {
    _attributeList = null;
    _discountTypeIndex = 0;
    _rawLogo = null;
    _selectedAddons = [];
    _variantTypeList = [];
    _totalStock = 0;
    _rawImages = [];
    _savedImages = [];
    if(item != null) {
      _savedImages.addAll(item.images);
    }
    Response response = await storeRepo.getAttributeList();
    if(response.statusCode == 200) {
      _attributeList = [];
      response.body.forEach((attribute) {
        if(item != null) {
          bool _active = item.attributes.contains(Attr.fromJson(attribute).id);
          List<String> _options = [];
          if(_active) {
            _options.addAll(item.choiceOptions[item.attributes.indexOf(Attr.fromJson(attribute).id)].options);
          }
          _attributeList.add(AttributeModel(
            attribute: Attr.fromJson(attribute),
            active: item.attributes.contains(Attr.fromJson(attribute).id),
            controller: TextEditingController(), variants: _options,
          ));
        }else {
          _attributeList.add(AttributeModel(attribute: Attr.fromJson(attribute), active: false,
            controller: TextEditingController(), variants: [],
          ));
        }
      });
    }else {
      ApiChecker.checkApi(response);
    }
    if(Get.find<SplashController>().configModel.moduleConfig.module.addOn) {
      List<int> _addonsIds = await Get.find<AddonController>().getAddonList();
      if(item != null && item.addOns != null) {
        for(int index=0; index<item.addOns.length; index++) {
          setSelectedAddonIndex(_addonsIds.indexOf(item.addOns[index].id), false);
        }
      }
    }
    if(Get.find<SplashController>().configModel.moduleConfig.module.unit) {
      await getUnitList(item);
    }
    generateVariantTypes(item);
    await getCategoryList(item);
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void toggleAttribute(int index, Item product) {
    _attributeList[index].active = !_attributeList[index].active;
    generateVariantTypes(product);
    update();
  }

  void addVariant(int index, String variant, Item product) {
    _attributeList[index].variants.add(variant);
    generateVariantTypes(product);
    update();
  }

  void removeVariant(int mainIndex, int index, Item product) {
    _attributeList[mainIndex].variants.removeAt(index);
    generateVariantTypes(product);
    update();
  }

  Future<void> getCategoryList(Item item) async {
    _categoryList = null;
    _categoryIndex = 0;
    Response response = await storeRepo.getCategoryList();
    if (response.statusCode == 200) {
      _categoryList = [];
      for(int index=0; index<response.body.length; index++) {
        _categoryList.add(CategoryModel.fromJson(response.body[index]));
        if(item != null) {
          if(CategoryModel.fromJson(response.body[index]).id.toString() == item.categoryIds[0].id) {
            _categoryIndex = index + 1;
          }
        }
      }
      if(item != null) {
        await getSubCategoryList(int.parse(item.categoryIds[0].id), item);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSubCategoryList(int categoryID, Item item) async {
    _subCategoryList = null;
    if(categoryID != 0) {
      _subCategoryIndex = 0;
      Response response = await storeRepo.getSubCategoryList(categoryID);
      if (response.statusCode == 200) {
        _subCategoryList = [];
        for(int index=0; index<response.body.length; index++) {
          _subCategoryList.add(CategoryModel.fromJson(response.body[index]));
          if(item != null && item.categoryIds.length > 1) {
            if(CategoryModel.fromJson(response.body[index]).id.toString() == item.categoryIds[1].id) {
              _subCategoryIndex = index + 1;
            }
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
    update();
  }

  Future<void> updateStore(Store store, String min, String max, String type) async {
    _isLoading = true;
    update();
    Response response = await storeRepo.updateStore(store, _rawLogo, _rawCover, min, max, type);
    if(response.statusCode == 200) {
      Get.back();
      Get.find<AuthController>().getProfile();
      showCustomSnackBar(Get.find<SplashController>().configModel.moduleConfig.module.showRestaurantText
          ? 'restaurant_settings_updated_successfully'.tr : 'store_settings_updated_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _rawLogo = null;
      _rawCover = null;
    }else {
      if (isLogo) {
        XFile _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(_pickedLogo != null) {
          _rawLogo = await NetworkInfo.compressImage(_pickedLogo);
        }
      } else {
        XFile _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(_pickedCover != null) {
          _rawCover = await NetworkInfo.compressImage(_pickedCover);
        }
      }
      update();
    }
  }

  void setSelectedAddonIndex(int index, bool notify) {
    if(!_selectedAddons.contains(index)) {
      _selectedAddons.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeAddon(int index) {
    _selectedAddons.removeAt(index);
    update();
  }

  Future<void> addItem(Item item, bool isAdd) async {
    _isLoading = true;
    update();
    Map<String, String> _fields = Map();
    if(_variantTypeList.length > 0) {
      List<int> _idList = [];
      List<String> _nameList = [];
      _attributeList.forEach((attributeModel) {
        if(attributeModel.active) {
          _idList.add(attributeModel.attribute.id);
          _nameList.add(attributeModel.attribute.name);
          String _variantString = '';
          attributeModel.variants.forEach((variant) {
            _variantString = _variantString + '${_variantString.isEmpty ? '' : ','}' + variant.replaceAll(' ', '');
          });
          _fields.addAll(<String, String>{'choice_options_${attributeModel.attribute.id}': jsonEncode([_variantString])});
        }
      });
      _fields.addAll(<String, String> {
        'attribute_id': jsonEncode(_idList), 'choice_no': jsonEncode(_idList), 'choice': jsonEncode(_nameList)
      });
      for(int index=0; index<_variantTypeList.length; index++) {
        _fields.addAll(<String, String> {'price_${_variantTypeList[index].variantType.replaceAll(' ', '_')}': _variantTypeList[index].priceController.text.trim(),
          'stock_${_variantTypeList[index].variantType.replaceAll(' ', '_')}': _variantTypeList[index].stockController.text.trim().isEmpty ? '0'
              : _variantTypeList[index].stockController.text.trim()});
      }
    }
    Response response = await storeRepo.addItem(item, _rawLogo, _rawImages, _savedImages, _fields, isAdd);
    if(response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(isAdd ? 'product_added_successfully'.tr : 'product_updated_successfully'.tr, isError: false);
      getItemList('1', 'all');
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteItem(int itemID) async {
    _isLoading = true;
    update();
    Response response = await storeRepo.deleteItem(itemID);
    if(response.statusCode == 200) {
      Get.back();
      showCustomSnackBar('product_deleted_successfully'.tr, isError: false);
      getItemList('1', 'all');
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void generateVariantTypes(Item item) {
    List<List<String>> _mainList = [];
    int _length = 1;
    bool _hasData = false;
    List<int> _indexList = [];
    _variantTypeList = [];
    _totalStock = 0;
    _attributeList.forEach((attribute) {
      if(attribute.active) {
        _hasData = true;
        _mainList.add(attribute.variants);
        _length = _length * attribute.variants.length;
        _indexList.add(0);
      }
    });
    if(!_hasData) {
      _length = 0;
    }
    for(int i=0; i<_length; i++) {
      String _value = '';
      for(int j=0; j<_mainList.length; j++) {
        _value = _value + '${_value.isEmpty ? '' : '-'}' + _mainList[j][_indexList[j]].trim();
      }
      if(item != null) {
        double _price = 0;
        int _stock = 0;
        for(Variation variation in item.variations) {
          if(variation.type == _value) {
            _price = variation.price;
            _stock = variation.stock;
            break;
          }
        }
        _totalStock = _totalStock + _stock;
        _variantTypeList.add(VariantTypeModel(
          variantType: _value, priceController: TextEditingController(text: _price > 0 ? _price.toString() : ''), priceNode: FocusNode(),
          stockController: TextEditingController(text: _stock > 0 ? _stock.toString() : ''), stockNode: FocusNode(),
        ));
      }else {
        _variantTypeList.add(VariantTypeModel(
          variantType: _value, priceController: TextEditingController(), priceNode: FocusNode(),
          stockController: TextEditingController(), stockNode: FocusNode(),
        ));
      }

      for(int j=0; j<_mainList.length; j++) {
        if(_indexList[_indexList.length-(1+j)] < _mainList[_mainList.length-(1+j)].length-1) {
          _indexList[_indexList.length-(1+j)] = _indexList[_indexList.length-(1+j)] + 1;
          break;
        }else {
          _indexList[_indexList.length-(1+j)] = 0;
        }
      }
    }
  }

  bool hasAttribute() {
    bool _hasData = false;
    for(AttributeModel attribute in _attributeList) {
      if(attribute.active) {
        _hasData = true;
        break;
      }
    }
    return _hasData;
  }

  Future<void> getStoreReviewList(int storeID) async {
    _tabIndex = 0;
    Response response = await storeRepo.getStoreReviewList(storeID);
    if(response.statusCode == 200) {
      _storeReviewList = [];
      response.body.forEach((review) => _storeReviewList.add(ReviewModel.fromJson(review)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getItemReviewList(int itemID) async {
    _itemReviewList = null;
    Response response = await storeRepo.getItemReviewList(itemID);
    if(response.statusCode == 200) {
      _itemReviewList = [];
      response.body.forEach((review) => _itemReviewList.add(ReviewModel.fromJson(review)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setAvailability(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  void toggleAvailable(int productID) async {
    Response response = await storeRepo.updateItemStatus(productID, _isAvailable ? 0 : 1);
    if(response.statusCode == 200) {
      getItemList('1', 'all');
      _isAvailable = !_isAvailable;
      showCustomSnackBar('item_status_updated_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void initStoreData(Store store) {
    _rawLogo = null;
    _rawCover = null;
    _isGstEnabled = store.gstStatus;
    _scheduleList = [];
    _scheduleList.addAll(store.schedules);
    _isStoreVeg = store.veg == 1;
    _isStoreNonVeg = store.nonVeg == 1;

  }

  void toggleGst() {
    _isGstEnabled = !_isGstEnabled;
    update();
  }

  Future<void> addSchedule(Schedules schedule) async {
    schedule.openingTime = schedule.openingTime + ':00';
    schedule.closingTime = schedule.closingTime + ':00';
    _scheduleLoading = true;
    update();
    Response response = await storeRepo.addSchedule(schedule);
    if(response.statusCode == 200) {
      schedule.id = int.parse(response.body['id'].toString());
      _scheduleList.add(schedule);
      Get.back();
      showCustomSnackBar('schedule_added_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _scheduleLoading = false;
    update();
  }

  Future<void> deleteSchedule(int scheduleID) async {
    _scheduleLoading = true;
    update();
    Response response = await storeRepo.deleteSchedule(scheduleID);
    if(response.statusCode == 200) {
      _scheduleList.removeWhere((schedule) => schedule.id == scheduleID);
      Get.back();
      showCustomSnackBar('schedule_removed_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _scheduleLoading = false;
    update();
  }

  void setTabIndex(int index) {
    bool _notify = true;
    if(_tabIndex == index) {
      _notify = false;
    }
    _tabIndex = index;
    if(_notify) {
      update();
    }
  }

  void setVeg(bool isVeg, bool notify) {
    _isVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setStoreVeg(bool isVeg, bool notify) {
    _isStoreVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setStoreNonVeg(bool isNonVeg, bool notify) {
    _isStoreNonVeg = isNonVeg;
    if(notify) {
      update();
    }
  }

  Future<void> getUnitList(Item item) async {
    _unitIndex = 0;
    Response response = await storeRepo.getUnitList();
    if(response.statusCode == 200) {
      _unitList = [];
      for(int index=0; index<response.body.length; index++) {
        _unitList.add(UnitModel.fromJson(response.body[index]));
        if(item != null) {
          if (UnitModel.fromJson(response.body[index]).unit == item.unitType) {
            _unitIndex = index + 1;
          }
        }
      }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setTotalStock() {
    _totalStock = 0;
    _variantTypeList.forEach((variant) => _totalStock = variant.stockController.text.trim().isNotEmpty
        ? _totalStock + int.parse(variant.stockController.text.trim()) : _totalStock);
    update();
  }

  void pickImages() async {
    XFile _xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(_xFile != null) {
      _rawImages.add(await NetworkInfo.compressImage(_xFile));
    }
    update();
  }

  void removeImage(int index) {
    _rawImages.removeAt(index);
    update();
  }

  void removeSavedImage(int index) {
    _savedImages.removeAt(index);
    update();
  }

  void setImageIndex(int index, bool notify) {
    _imageIndex = index;
    if(notify) {
      update();
    }
  }

  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    if(notify) {
      update();
    }
  }

  void setSubCategoryIndex(int index, bool notify) {
    _subCategoryIndex = index;
    if(notify) {
      update();
    }
  }

  void setUnitIndex(int index, bool notify) {
    _unitIndex = index;
    if(notify) {
      update();
    }
  }

  void setDurationType(int index, bool notify) {
    _durationIndex = index;
    if(notify) {
      update();
    }
  }

}