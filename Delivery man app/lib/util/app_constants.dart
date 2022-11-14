import 'package:sixam_mart_delivery/data/model/response/language_model.dart';
import 'package:sixam_mart_delivery/util/images.dart';

class AppConstants {
  static const String APP_NAME = 'Dehkanbaba - Delivery Man App';
  static const double APP_VERSION = 1.4;

  static const String BASE_URL = 'http://dehkanbaba.uz/backend';
  static const String CONFIG_URI = '/api/v1/config';
  static const String FORGET_PASSWORD_URI =
      '/api/v1/auth/delivery-man/forgot-password';
  static const String VERIFY_TOKEN_URI =
      '/api/v1/auth/delivery-man/verify-token';
  static const String RESET_PASSWORD_URI =
      '/api/v1/auth/delivery-man/reset-password';
  static const String LOGIN_URI = '/api/v1/auth/delivery-man/login';
  static const String TOKEN_URI = '/api/v1/delivery-man/update-fcm-token';
  static const String CURRENT_ORDERS_URI =
      '/api/v1/delivery-man/current-orders?token=';
  static const String ALL_ORDERS_URI = '/api/v1/delivery-man/all-orders';
  static const String LATEST_ORDERS_URI =
      '/api/v1/delivery-man/latest-orders?token=';
  static const String RECORD_LOCATION_URI =
      '/api/v1/delivery-man/record-location-data';
  static const String PROFILE_URI = '/api/v1/delivery-man/profile?token=';
  static const String UPDATE_ORDER_STATUS_URI =
      '/api/v1/delivery-man/update-order-status';
  static const String UPDATE_PAYMENT_STATUS_URI =
      '/api/v1/delivery-man/update-payment-status';
  static const String ORDER_DETAILS_URI =
      '/api/v1/delivery-man/order-details?token=';
  static const String ACCEPT_ORDER_URI = '/api/v1/delivery-man/accept-order';
  static const String ACTIVE_STATUS_URI =
      '/api/v1/delivery-man/update-active-status';
  static const String UPDATE_PROFILE_URI =
      '/api/v1/delivery-man/update-profile';
  static const String NOTIFICATION_URI =
      '/api/v1/delivery-man/notifications?token=';
  static const String ABOUT_US_URI = '/about-us';
  static const String PRIVACY_POLICY_URI = '/privacy-policy';
  static const String TERMS_AND_CONDITIONS_URI = '/terms-and-conditions';
  static const String DRIVER_REMOVE =
      '/api/v1/delivery-man/remove-account?token=';

  // Shared Key
  static const String THEME = 'sixam_mart_delivery_theme';
  static const String TOKEN = 'sixam_mart_delivery_token';
  static const String COUNTRY_CODE = 'sixam_mart_delivery_country_code';
  static const String LANGUAGE_CODE = 'sixam_mart_delivery_language_code';
  static const String USER_PASSWORD = 'sixam_mart_delivery_user_password';
  static const String USER_ADDRESS = 'sixam_mart_delivery_user_address';
  static const String USER_NUMBER = 'sixam_mart_delivery_user_number';
  static const String USER_COUNTRY_CODE =
      'sixam_mart_delivery_user_country_code';
  static const String NOTIFICATION = 'sixam_mart_delivery_notification';
  static const String NOTIFICATION_COUNT =
      'sixam_mart_delivery_notification_count';
  static const String IGNORE_LIST = 'sixam_mart_delivery_ignore_list';
  static const String TOPIC = 'all_zone_delivery_man';
  static const String ZONE_TOPIC = 'zone_topic';
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
    LanguageModel(
        imageUrl: Images.english,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
  ];
}
