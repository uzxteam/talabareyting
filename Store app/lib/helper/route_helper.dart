import 'dart:convert';

import 'package:sixam_mart_store/data/model/response/campaign_model.dart';
import 'package:sixam_mart_store/data/model/response/category_model.dart';
import 'package:sixam_mart_store/data/model/response/delivery_man_model.dart';
import 'package:sixam_mart_store/data/model/response/order_model.dart';
import 'package:sixam_mart_store/data/model/response/item_model.dart';
import 'package:sixam_mart_store/data/model/response/profile_model.dart';
import 'package:sixam_mart_store/view/screens/addon/addon_screen.dart';
import 'package:sixam_mart_store/view/screens/auth/sign_in_screen.dart';
import 'package:sixam_mart_store/view/screens/bank/bank_info_screen.dart';
import 'package:sixam_mart_store/view/screens/bank/wallet_screen.dart';
import 'package:sixam_mart_store/view/screens/bank/withdraw_history_screen.dart';
import 'package:sixam_mart_store/view/screens/campaign/campaign_details_screen.dart';
import 'package:sixam_mart_store/view/screens/campaign/campaign_screen.dart';
import 'package:sixam_mart_store/view/screens/category/category_screen.dart';
import 'package:sixam_mart_store/view/screens/dashboard/dashboard_screen.dart';
import 'package:sixam_mart_store/view/screens/deliveryman/add_delivery_man_screen.dart';
import 'package:sixam_mart_store/view/screens/deliveryman/delivery_man_details_screen.dart';
import 'package:sixam_mart_store/view/screens/deliveryman/delivery_man_screen.dart';
import 'package:sixam_mart_store/view/screens/forget/forget_pass_screen.dart';
import 'package:sixam_mart_store/view/screens/forget/new_pass_screen.dart';
import 'package:sixam_mart_store/view/screens/forget/verification_screen.dart';
import 'package:sixam_mart_store/view/screens/html/html_viewer_screen.dart';
import 'package:sixam_mart_store/view/screens/language/language_screen.dart';
import 'package:sixam_mart_store/view/screens/notification/notification_screen.dart';
import 'package:sixam_mart_store/view/screens/order/order_details_screen.dart';
import 'package:sixam_mart_store/view/screens/pos/pos_screen.dart';
import 'package:sixam_mart_store/view/screens/profile/profile_screen.dart';
import 'package:sixam_mart_store/view/screens/profile/update_profile_screen.dart';
import 'package:sixam_mart_store/view/screens/store/add_name_screen.dart';
import 'package:sixam_mart_store/view/screens/store/add_item_screen.dart';
import 'package:sixam_mart_store/view/screens/store/image_viewer_screen.dart';
import 'package:sixam_mart_store/view/screens/store/item_details_screen.dart';
import 'package:sixam_mart_store/view/screens/store/store_screen.dart';
import 'package:sixam_mart_store/view/screens/store/store_settings_screen.dart';
import 'package:sixam_mart_store/view/screens/splash/splash_screen.dart';
import 'package:sixam_mart_store/view/screens/update/update_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String signIn = '/sign-in';
  static const String verification = '/verification';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String notification = '/notification';
  static const String bankInfo = '/bank-info';
  static const String wallet = '/wallet';
  static const String withdrawHistory = '/withdraw-history';
  static const String store = '/store';
  static const String campaign = '/campaign';
  static const String campaignDetails = '/campaign-details';
  static const String item = '/item';
  static const String addItem = '/add-item';
  static const String categories = '/categories';
  static const String subCategories = '/sub-categories';
  static const String storeSettings = '/store-settings';
  static const String addons = '/addons';
  static const String itemDetails = '/item-details';
  static const String pos = '/pos';
  static const String deliveryMan = '/delivery-man';
  static const String addDeliveryMan = '/add-delivery-man';
  static const String deliveryManDetails = '/delivery-man-details';
  static const String terms = '/terms-and-condition';
  static const String privacy = '/privacy-policy';
  static const String update = '/update';
  static String itemImages = '/item-images';

  static String getInitialRoute() => '$initial';
  static String getSplashRoute() => '$splash';
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getSignInRoute() => '$signIn';
  static String getVerificationRoute(String email) => '$verification?email=$email';
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute() => '$forgotPassword';
  static String getResetPasswordRoute(String phone, String token, String page) => '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getOrderDetailsRoute(int orderID) => '$orderDetails?id=$orderID';
  static String getProfileRoute() => '$profile';
  static String getUpdateProfileRoute() => '$updateProfile';
  static String getNotificationRoute() => '$notification';
  static String getBankInfoRoute() => '$bankInfo';
  static String getWalletRoute() => '$wallet';
  static String getWithdrawHistoryRoute() => '$withdrawHistory';
  static String getStoreRoute() => '$store';
  static String getCampaignRoute() => '$campaign';
  static String getCampaignDetailsRoute(int id) => '$campaignDetails?id=$id';
  static String getUpdateRoute(bool isUpdate) => '$update?update=${isUpdate.toString()}';
  static String getItemRoute(Item itemModel) {
    if(itemModel == null) {
      return '$item?data=null';
    }
    List<int> _encoded = utf8.encode(jsonEncode(itemModel.toJson()));
    String _data = base64Encode(_encoded);
    return '$item?data=$_data';
  }
  static String getAddItemRoute(Item itemModel, List<Translation> translations) {
    String _translations = base64Encode(utf8.encode(jsonEncode(translations)));
    if(itemModel == null) {
      return '$addItem?data=null&translations=$_translations';
    }
    String _data = base64Encode(utf8.encode(jsonEncode(itemModel.toJson())));
    return '$addItem?data=$_data&translations=$_translations';
  }
  static String getCategoriesRoute() => '$categories';
  static String getSubCategoriesRoute(CategoryModel categoryModel) {
    List<int> _encoded = utf8.encode(jsonEncode(categoryModel.toJson()));
    String _data = base64Encode(_encoded);
    return '$subCategories?data=$_data';
  }
  static String getStoreSettingsRoute(Store store) {
    List<int> _encoded = utf8.encode(jsonEncode(store.toJson()));
    String _data = base64Encode(_encoded);
    return '$storeSettings?data=$_data';
  }
  static String getAddonsRoute() => '$addons';
  static String getItemDetailsRoute(Item itemModel) {
    List<int> _encoded = utf8.encode(jsonEncode(itemModel.toJson()));
    String _data = base64Encode(_encoded);
    return '$itemDetails?data=$_data';
  }
  static String getPosRoute() => '$pos';
  static String getDeliveryManRoute() => '$deliveryMan';
  static String getAddDeliveryManRoute(DeliveryManModel deliveryMan) {
    if(deliveryMan == null) {
      return '$addDeliveryMan?data=null';
    }
    List<int> _encoded = utf8.encode(jsonEncode(deliveryMan.toJson()));
    String _data = base64Encode(_encoded);
    return '$addDeliveryMan?data=$_data';
  }
  static String getDeliveryManDetailsRoute(DeliveryManModel deliveryMan) {
    List<int> _encoded = utf8.encode(jsonEncode(deliveryMan.toJson()));
    String _data = base64Encode(_encoded);
    return '$deliveryManDetails?data=$_data';
  }
  static String getTermsRoute() => '$terms';
  static String getPrivacyRoute() => '$privacy';
  static String getItemImagesRoute(Item item) {
    String _data = base64Url.encode(utf8.encode(jsonEncode(item.toJson())));
    return '$itemImages?item=$_data';
  }

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => DashboardScreen(pageIndex: 0)),
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: language, page: () => LanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: verification, page: () => VerificationScreen(email: Get.parameters['email'])),
    GetPage(name: main, page: () => DashboardScreen(
      pageIndex: Get.parameters['page'] == 'home' ? 0 : Get.parameters['page'] == 'favourite' ? 1
          : Get.parameters['page'] == 'cart' ? 2 : Get.parameters['page'] == 'order' ? 3 : Get.parameters['page'] == 'menu' ? 4 : 0,
    )),
    GetPage(name: forgotPassword, page: () => ForgetPassScreen()),
    GetPage(name: resetPassword, page: () => NewPassScreen(
      resetToken: Get.parameters['token'], email: Get.parameters['phone'], fromPasswordChange: Get.parameters['page'] == 'password-change',
    )),
    GetPage(name: orderDetails, page: () {
      return Get.arguments != null ? Get.arguments : OrderDetailsScreen(
        orderModel: OrderModel(id: int.parse(Get.parameters['id'])), isRunningOrder: false,
      );
    }),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: updateProfile, page: () => UpdateProfileScreen()),
    GetPage(name: notification, page: () => NotificationScreen()),
    GetPage(name: bankInfo, page: () => BankInfoScreen()),
    GetPage(name: wallet, page: () => WalletScreen()),
    GetPage(name: withdrawHistory, page: () => WithdrawHistoryScreen()),
    GetPage(name: store, page: () => StoreScreen()),
    GetPage(name: campaign, page: () => CampaignScreen()),
    GetPage(name: campaignDetails, page: () {
      return Get.arguments != null ? Get.arguments : CampaignDetailsScreen(
        campaignModel: CampaignModel(id: int.parse(Get.parameters['id'])),
      );
    }),
    GetPage(name: item, page: () {
      if(Get.parameters['data'] == 'null') {
        return AddNameScreen(item: null);
      }
      List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
      Item _data = Item.fromJson(jsonDecode(utf8.decode(_decode)));
      return AddNameScreen(item: _data);
    }),
    GetPage(name: addItem, page: () {
      List<Translation> _translations = [];
      jsonDecode(utf8.decode(base64Decode(Get.parameters['translations'].replaceAll(' ', '+')))).forEach((data) {
        _translations.add(Translation.fromJson(data));
      });
      if(Get.parameters['data'] == 'null') {
        return AddItemScreen(item: null, translations: _translations);
      }
      List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
      Item _data = Item.fromJson(jsonDecode(utf8.decode(_decode)));
      return AddItemScreen(item: _data, translations: _translations);
    }),
    GetPage(name: categories, page: () => CategoryScreen(categoryModel: null)),
    GetPage(name: subCategories, page: () {
      List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
      CategoryModel _data = CategoryModel.fromJson(jsonDecode(utf8.decode(_decode)));
      return CategoryScreen(categoryModel: _data);
    }),
    GetPage(name: storeSettings, page: () {
      List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
      Store _data = Store.fromJson(jsonDecode(utf8.decode(_decode)));
      return StoreSettingsScreen(store: _data);
    }),
    GetPage(name: addons, page: () => AddonScreen()),
    GetPage(name: itemDetails, page: () {
      List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
      Item _data = Item.fromJson(jsonDecode(utf8.decode(_decode)));
      return ItemDetailsScreen(item: _data);
    }),
    GetPage(name: pos, page: () => PosScreen()),
    GetPage(name: deliveryMan, page: () => DeliveryManScreen()),
    GetPage(name: addDeliveryMan, page: () {
      if(Get.parameters['data'] == 'null') {
        return AddDeliveryManScreen(deliveryMan: null);
      }
      List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
      DeliveryManModel _data = DeliveryManModel.fromJson(jsonDecode(utf8.decode(_decode)));
      return AddDeliveryManScreen(deliveryMan: _data);
    }),
    GetPage(name: deliveryManDetails, page: () {
      List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
      DeliveryManModel _data = DeliveryManModel.fromJson(jsonDecode(utf8.decode(_decode)));
      return DeliveryManDetailsScreen(deliveryMan: _data);
    }),
    GetPage(name: terms, page: () => HtmlViewerScreen(isPrivacyPolicy: false)),
    GetPage(name: privacy, page: () => HtmlViewerScreen(isPrivacyPolicy: true)),
    GetPage(name: update, page: () => UpdateScreen(isUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: itemImages, page: () => ImageViewerScreen(
      item: Item.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['item'].replaceAll(' ', '+'))))),
    )),
  ];
}