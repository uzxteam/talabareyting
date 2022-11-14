import 'package:sixam_mart_store/data/model/response/language_model.dart';
import 'package:sixam_mart_store/util/images.dart';

class AppConstants {
  static const String APP_NAME = 'Store App';
  static const double APP_VERSION = 1.4;

  static const String BASE_URL = 'http://dehkanbaba.uz/backend';
  static const String CONFIG_URI = '/api/v1/config';
  static const String LOGIN_URI = '/api/v1/auth/vendor/login';
  static const String FORGET_PASSWORD_URI =
      '/api/v1/auth/vendor/forgot-password';
  static const String VERIFY_TOKEN_URI = '/api/v1/auth/vendor/verify-token';
  static const String RESET_PASSWORD_URI = '/api/v1/auth/vendor/reset-password';
  static const String TOKEN_URI = '/api/v1/vendor/update-fcm-token';
  static const String ALL_ORDERS_URI = '/api/v1/vendor/all-orders';
  static const String CURRENT_ORDERS_URI = '/api/v1/vendor/current-orders';
  static const String COMPLETED_ORDERS_URI = '/api/v1/vendor/completed-orders';
  static const String ORDER_DETAILS_URI =
      '/api/v1/vendor/order-details?order_id=';
  static const String UPDATE_ORDER_STATUS_URI =
      '/api/v1/vendor/update-order-status';
  static const String NOTIFICATION_URI = '/api/v1/vendor/notifications';
  static const String PROFILE_URI = '/api/v1/vendor/profile';
  static const String UPDATE_PROFILE_URI = '/api/v1/vendor/update-profile';
  static const String BASIC_CAMPAIGN_URI = '/api/v1/vendor/get-basic-campaigns';
  static const String JOIN_CAMPAIGN_URI = '/api/v1/vendor/campaign-join';
  static const String LEAVE_CAMPAIGN_URI = '/api/v1/vendor/campaign-leave';
  static const String WITHDRAW_LIST_URI = '/api/v1/vendor/get-withdraw-list';
  static const String ITEM_LIST_URI = '/api/v1/vendor/get-items-list';
  static const String UPDATE_BANK_INFO_URI = '/api/v1/vendor/update-bank-info';
  static const String WITHDRAW_REQUEST_URI = '/api/v1/vendor/request-withdraw';
  static const String CATEGORY_URI = '/api/v1/vendor/categories';
  static const String SUB_CATEGORY_URI = '/api/v1/vendor/categories/childes/';
  static const String ADDON_URI = '/api/v1/vendor/addon';
  static const String ADD_ADDON_URI = '/api/v1/vendor/addon/store';
  static const String UPDATE_ADDON_URI = '/api/v1/vendor/addon/update';
  static const String DELETE_ADDON_URI = '/api/v1/vendor/addon/delete';
  static const String ATTRIBUTE_URI = '/api/v1/vendor/attributes';
  static const String VENDOR_UPDATE_URI =
      '/api/v1/vendor/update-business-setup';
  static const String ADD_ITEM_URI = '/api/v1/vendor/item/store';
  static const String UPDATE_ITEM_URI = '/api/v1/vendor/item/update';
  static const String DELETE_ITEM_URI = '/api/v1/vendor/item/delete';
  static const String VENDOR_REVIEW_URI = '/api/v1/vendor/item/reviews';
  static const String ITEM_REVIEW_URI = '/api/v1/items/reviews';
  static const String UPDATE_ITEM_STATUS_URI = '/api/v1/vendor/item/status';
  static const String UPDATE_VENDOR_STATUS_URI =
      '/api/v1/vendor/update-active-status';
  static const String SEARCH_ITEM_LIST_URI = '/api/v1/vendor/item/search';
  static const String PLACE_ORDER_URI = '/api/v1/vendor/pos/place-order';
  static const String POS_ORDERS_URI = '/api/v1/vendor/pos/orders';
  static const String SEARCH_CUSTOMERS_URI = '/api/v1/vendor/pos/customers';
  static const String DM_LIST_URI = '/api/v1/vendor/delivery-man/list';
  static const String ADD_DM_URI = '/api/v1/vendor/delivery-man/store';
  static const String UPDATE_DM_URI = '/api/v1/vendor/delivery-man/update/';
  static const String DELETE_DM_URI = '/api/v1/vendor/delivery-man/delete';
  static const String UPDATE_DM_STATUS_URI =
      '/api/v1/vendor/delivery-man/status';
  static const String DM_REVIEW_URI = '/api/v1/vendor/delivery-man/preview';
  static const String ADD_SCHEDULE = '/api/v1/vendor/schedule/store';
  static const String DELETE_SCHEDULE = '/api/v1/vendor/schedule/';
  static const String UNIT_LIST_URI = '/api/v1/vendor/unit';
  static const String ABOUT_US_URI = '/about-us';
  static const String PRIVACY_POLICY_URI = '/privacy-policy';
  static const String TERMS_AND_CONDITIONS_URI = '/terms-and-conditions';
  static const String VENDOR_REMOVE = '/api/v1/vendor/remove-account';

  // Shared Key
  static const String THEME = '6am_mart_store_theme';
  static const String INTRO = '6am_mart_store_intro';
  static const String TOKEN = '6am_mart_store_token';
  static const String COUNTRY_CODE = '6am_mart_store_country_code';
  static const String LANGUAGE_CODE = '6am_mart_store_language_code';
  static const String CART_LIST = '6am_mart_store_cart_list';
  static const String USER_PASSWORD = '6am_mart_store_user_password';
  static const String USER_ADDRESS = '6am_mart_store_user_address';
  static const String USER_NUMBER = '6am_mart_store_user_number';
  static const String NOTIFICATION = '6am_mart_store_notification';
  static const String NOTIFICATION_COUNT = '6am_mart_store_notification_count';
  static const String SEARCH_HISTORY = '6am_mart_store_search_history';

  static const String TOPIC = 'all_zone_store';
  static const String ZONE_TOPIC = 'zone_topic';
  static const String MODULE_ID = 'moduleId';
  static const String LOCALIZATION_KEY = 'X-localization';

  // Status
  static const String PENDING = 'pending';
  static const String CONFIRMED = 'confirmed';
  static const String ACCEPTED = 'accepted';
  static const String PROCESSING = 'processing';
  static const String HANDOVER = 'handover';
  static const String PICKED_UP = 'picked_up';
  static const String DELIVERED = 'delivered';
  static const String CANCELED = 'canceled';
  static const String FAILED = 'failed';
  static const String REFUNDED = 'refunded';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.uzbek,
        languageName: 'Uzbek',
        countryCode: 'UZ',
        languageCode: 'uz'),

  ];
}
