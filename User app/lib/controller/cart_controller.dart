import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/data/repository/cart_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({@required this.cartRepo});

  List<CartModel> _cartList = [];

  List<CartModel> get cartList => _cartList;

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
  }

  void addToCart(CartModel cartModel, int index) {
    if(index != null && index != -1) {
      _cartList.replaceRange(index, index+1, [cartModel]);
    }else {
      _cartList.add(cartModel);
    }
    Get.find<ItemController>().setExistInCart(cartModel.item, notify: true);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void setQuantity(bool isIncrement, int cartIndex, int stock) {
    if (isIncrement) {
      if(Get.find<SplashController>().configModel.moduleConfig.module.stock && cartList[cartIndex].quantity >= stock) {
        showCustomSnackBar('out_of_stock'.tr);
      }else {
        _cartList[cartIndex].quantity = _cartList[cartIndex].quantity + 1;
      }
    } else {
      _cartList[cartIndex].quantity = _cartList[cartIndex].quantity - 1;
    }
    cartRepo.addToCartList(_cartList);

    update();
  }

  void removeFromCart(int index) {
    _cartList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    if(Get.find<ItemController>().item != null) {
      Get.find<ItemController>().setExistInCart(Get.find<ItemController>().item, notify: true);
    }
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void clearCartList() {
    _cartList = [];
    cartRepo.addToCartList(_cartList);
    update();
  }

  int isExistInCart(int itemID, String variationType, bool isUpdate, int cartIndex) {
    for(int index=0; index<_cartList.length; index++) {
      if(_cartList[index].item.id == itemID && (_cartList[index].variation.length > 0 ? _cartList[index].variation[0].type
          == variationType : true)) {
        if((isUpdate && index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }

  bool existAnotherStoreItem(int storeID) {
    for(CartModel cartModel in _cartList) {
      if(cartModel.item.storeId != storeID) {
        return true;
      }
    }
    return false;
  }

  void removeAllAndAddToCart(CartModel cartModel) {
    _cartList = [];
    _cartList.add(cartModel);
    Get.find<ItemController>().setExistInCart(cartModel.item, notify: true);
    cartRepo.addToCartList(_cartList);
    update();
  }


}
