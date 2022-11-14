class ProfileModel {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String createdAt;
  String updatedAt;
  String bankName;
  String branch;
  String holderName;
  String accountNo;
  String image;
  int orderCount;
  int todaysOrderCount;
  int thisWeekOrderCount;
  int thisMonthOrderCount;
  int memberSinceDays;
  double cashInHands;
  double balance;
  double totalEarning;
  double todaysEarning;
  double thisWeekEarning;
  double thisMonthEarning;
  List<Store> stores;

  ProfileModel(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.createdAt,
        this.updatedAt,
        this.bankName,
        this.branch,
        this.holderName,
        this.accountNo,
        this.image,
        this.orderCount,
        this.todaysOrderCount,
        this.thisWeekOrderCount,
        this.thisMonthOrderCount,
        this.memberSinceDays,
        this.cashInHands,
        this.balance,
        this.totalEarning,
        this.todaysEarning,
        this.thisWeekEarning,
        this.thisMonthEarning,
        this.stores});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    branch = json['branch'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
    image = json['image'];
    orderCount = json['order_count'];
    todaysOrderCount = json['todays_order_count'];
    thisWeekOrderCount = json['this_week_order_count'];
    thisMonthOrderCount = json['this_month_order_count'];
    memberSinceDays = json['member_since_days'];
    cashInHands = json['cash_in_hands'].toDouble();
    balance = json['balance'].toDouble();
    totalEarning = json['total_earning'].toDouble();
    todaysEarning = json['todays_earning'].toDouble();
    thisWeekEarning = json['this_week_earning'].toDouble();
    thisMonthEarning = json['this_month_earning'].toDouble();
    if (json['stores'] != null) {
      stores = [];
      json['stores'].forEach((v) {
        stores.add(new Store.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['bank_name'] = this.bankName;
    data['branch'] = this.branch;
    data['holder_name'] = this.holderName;
    data['account_no'] = this.accountNo;
    data['image'] = this.image;
    data['order_count'] = this.orderCount;
    data['todays_order_count'] = this.todaysOrderCount;
    data['this_week_order_count'] = this.thisWeekOrderCount;
    data['this_month_order_count'] = this.thisMonthOrderCount;
    data['member_since_days'] = this.memberSinceDays;
    data['cash_in_hands'] = this.cashInHands;
    data['balance'] = this.balance;
    data['total_earning'] = this.totalEarning;
    data['todays_earning'] = this.todaysEarning;
    data['this_week_earning'] = this.thisWeekEarning;
    data['this_month_earning'] = this.thisMonthEarning;
    if (this.stores != null) {
      data['stores'] = this.stores.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Store {
  int id;
  String name;
  String phone;
  String email;
  String logo;
  String latitude;
  String longitude;
  String address;
  double minimumOrder;
  bool scheduleOrder;
  String currency;
  String createdAt;
  String updatedAt;
  bool freeDelivery;
  String coverPhoto;
  bool delivery;
  bool takeAway;
  double tax;
  bool reviewsSection;
  bool itemSection;
  double avgRating;
  int ratingCount;
  bool active;
  bool gstStatus;
  String gstCode;
  int selfDeliverySystem;
  bool posSystem;
  double deliveryCharge;
  String deliveryTime;
  int veg;
  int nonVeg;
  int orderPlaceToScheduleInterval;
  Module module;
  Discount discount;
  List<Schedules> schedules;

  Store(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.logo,
        this.latitude,
        this.longitude,
        this.address,
        this.minimumOrder,
        this.scheduleOrder,
        this.currency,
        this.createdAt,
        this.updatedAt,
        this.freeDelivery,
        this.coverPhoto,
        this.delivery,
        this.takeAway,
        this.tax,
        this.reviewsSection,
        this.itemSection,
        this.avgRating,
        this.ratingCount,
        this.active,
        this.gstStatus,
        this.gstCode,
        this.selfDeliverySystem,
        this.posSystem,
        this.deliveryCharge,
        this.deliveryTime,
        this.veg,
        this.nonVeg,
        this.orderPlaceToScheduleInterval,
        this.module,
        this.discount,
        this.schedules,
      });

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    minimumOrder = json['minimum_order'].toDouble();
    scheduleOrder = json['schedule_order'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    freeDelivery = json['free_delivery'];
    coverPhoto = json['cover_photo'];
    delivery = json['delivery'];
    takeAway = json['take_away'];
    tax = json['tax'].toDouble();
    reviewsSection = json['reviews_section'];
    itemSection = json['item_section'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count '];
    active = json['active'];
    gstStatus = json['gst_status'];
    gstCode = json['gst_code'];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    deliveryCharge = json['delivery_charge'].toDouble();
    deliveryTime = json['delivery_time'];
    veg = json['veg'];
    nonVeg = json['non_veg'];
    orderPlaceToScheduleInterval = json['order_place_to_schedule_interval'];
    module = json['module'] != null ? new Module.fromJson(json['module']) : null;
    discount = json['discount'] != null ? new Discount.fromJson(json['discount']) : null;
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules.add(new Schedules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['minimum_order'] = this.minimumOrder;
    data['schedule_order'] = this.scheduleOrder;
    data['currency'] = this.currency;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['free_delivery'] = this.freeDelivery;
    data['cover_photo'] = this.coverPhoto;
    data['delivery'] = this.delivery;
    data['take_away'] = this.takeAway;
    data['tax'] = this.tax;
    data['reviews_section'] = this.reviewsSection;
    data['item_section'] = this.itemSection;
    data['avg_rating'] = this.avgRating;
    data['rating_count '] = this.ratingCount;
    data['active'] = this.active;
    data['gst_status'] = this.gstStatus;
    data['gst_code'] = this.gstCode;
    data['self_delivery_system'] = this.selfDeliverySystem;
    data['pos_system'] = this.posSystem;
    data['delivery_charge'] = this.deliveryCharge;
    data['delivery_time'] = this.deliveryTime;
    data['veg'] = this.veg;
    data['non_veg'] = this.nonVeg;
    data['order_place_to_schedule_interval'] = this.orderPlaceToScheduleInterval;
    if (this.module != null) {
      data['module'] = this.module.toJson();
    }
    if (this.discount != null) {
      data['discount'] = this.discount.toJson();
    }
    if (this.schedules != null) {
      data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Discount {
  int id;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  double minPurchase;
  double maxDiscount;
  double discount;
  String discountType;
  int storeId;
  String createdAt;
  String updatedAt;

  Discount(
      {this.id,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.minPurchase,
        this.maxDiscount,
        this.discount,
        this.discountType,
        this.storeId,
        this.createdAt,
        this.updatedAt});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    minPurchase = json['min_purchase'].toDouble();
    maxDiscount = json['max_discount'].toDouble();
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['min_purchase'] = this.minPurchase;
    data['max_discount'] = this.maxDiscount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['store_id'] = this.storeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Schedules {
  int id;
  int storeId;
  int day;
  String openingTime;
  String closingTime;

  Schedules(
      {this.id,
        this.storeId,
        this.day,
        this.openingTime,
        this.closingTime});

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    day = json['day'];
    openingTime = json['opening_time'].substring(0, 5);
    closingTime = json['closing_time'].substring(0, 5);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['day'] = this.day;
    data['opening_time'] = this.openingTime;
    data['closing_time'] = this.closingTime;
    return data;
  }
}

class Module {
  int id;
  String moduleName;
  String moduleType;
  String thumbnail;
  String status;
  int storesCount;
  String createdAt;
  String updatedAt;

  Module(
      {this.id,
        this.moduleName,
        this.moduleType,
        this.thumbnail,
        this.status,
        this.storesCount,
        this.createdAt,
        this.updatedAt});

  Module.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['module_name'];
    moduleType = json['module_type'];
    thumbnail = json['thumbnail'];
    status = json['status'];
    storesCount = json['stores_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['module_name'] = this.moduleName;
    data['module_type'] = this.moduleType;
    data['thumbnail'] = this.thumbnail;
    data['status'] = this.status;
    data['stores_count'] = this.storesCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}