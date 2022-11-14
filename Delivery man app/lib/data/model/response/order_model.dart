class PaginatedOrderModel {
  int totalSize;
  String limit;
  String offset;
  List<OrderModel> orders;

  PaginatedOrderModel({this.totalSize, this.limit, this.offset, this.orders});

  PaginatedOrderModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = json['offset'].toString();
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders.add(new OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class OrderModel {
  int id;
  int itemCampaignId;
  int userId;
  double orderAmount;
  double couponDiscountAmount;
  String paymentStatus;
  String orderStatus;
  double totalTaxAmount;
  String paymentMethod;
  String transactionReference;
  int deliveryAddressId;
  int deliveryManId;
  String orderType;
  int storeId;
  String createdAt;
  String updatedAt;
  double deliveryCharge;
  double originalDeliveryCharge;
  String scheduleAt;
  String storeName;
  String storeAddress;
  String storeLat;
  String storeLng;
  String storeLogo;
  String storePhone;
  int detailsCount;
  String orderNote;
  String orderAttachment;
  String chargePayer;
  String moduleType;
  DeliveryAddress deliveryAddress;
  DeliveryAddress receiverDetails;
  ParcelCategory parcelCategory;
  Customer customer;

  OrderModel(
      {this.id,
        this.itemCampaignId,
        this.userId,
        this.orderAmount,
        this.couponDiscountAmount,
        this.paymentStatus,
        this.orderStatus,
        this.totalTaxAmount,
        this.paymentMethod,
        this.transactionReference,
        this.deliveryAddressId,
        this.deliveryManId,
        this.orderType,
        this.storeId,
        this.createdAt,
        this.updatedAt,
        this.deliveryCharge,
        this.originalDeliveryCharge,
        this.scheduleAt,
        this.storeName,
        this.storeAddress,
        this.storeLat,
        this.storeLng,
        this.storeLogo,
        this.storePhone,
        this.detailsCount,
        this.chargePayer,
        this.orderAttachment,
        this.orderNote,
        this.moduleType,
        this.deliveryAddress,
        this.receiverDetails,
        this.parcelCategory,
        this.customer,
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemCampaignId = json['item_campaign_id'];
    userId = json['user_id'];
    orderAmount = json['order_amount'].toDouble();
    couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount'].toDouble();
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    deliveryAddressId = json['delivery_address_id'];
    deliveryManId = json['delivery_man_id'];
    orderType = json['order_type'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge'].toDouble();
    originalDeliveryCharge = json['original_delivery_charge'].toDouble();
    scheduleAt = json['schedule_at'];
    storeName = json['store_name'];
    storeAddress = json['store_address'];
    storeLat = json['store_lat'];
    storeLng = json['store_lng'];
    storeLogo = json['store_logo'];
    storePhone = json['store_phone'];
    detailsCount = json['details_count'];
    orderNote = json['order_note'];
    chargePayer = json['charge_payer'];
    moduleType = json['module_type'];
    orderAttachment = json['order_attachment'];
    deliveryAddress = json['delivery_address'] != null ? new DeliveryAddress.fromJson(json['delivery_address']) : null;
    receiverDetails = json['receiver_details'] != null ? new DeliveryAddress.fromJson(json['receiver_details']) : null;
    parcelCategory = json['parcel_category'] != null ? new ParcelCategory.fromJson(json['parcel_category']) : null;
    customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_campaign_id'] = this.itemCampaignId;
    data['user_id'] = this.userId;
    data['order_amount'] = this.orderAmount;
    data['coupon_discount_amount'] = this.couponDiscountAmount;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['payment_method'] = this.paymentMethod;
    data['transaction_reference'] = this.transactionReference;
    data['delivery_address_id'] = this.deliveryAddressId;
    data['delivery_man_id'] = this.deliveryManId;
    data['order_type'] = this.orderType;
    data['store_id'] = this.storeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_charge'] = this.deliveryCharge;
    data['original_delivery_charge'] = this.originalDeliveryCharge;
    data['schedule_at'] = this.scheduleAt;
    data['store_name'] = this.storeName;
    data['store_address'] = this.storeAddress;
    data['store_lat'] = this.storeLat;
    data['store_lng'] = this.storeLng;
    data['store_logo'] = this.storeLogo;
    data['store_phone'] = this.storePhone;
    data['details_count'] = this.detailsCount;
    data['order_attachment'] = this.orderAttachment;
    data['order_attachment'] = this.chargePayer;
    data['order_note'] = this.orderNote;
    data['module_type'] = this.moduleType;
    if (this.deliveryAddress != null) {
      data['delivery_address'] = this.deliveryAddress.toJson();
    }
    if (this.receiverDetails != null) {
      data['receiver_details'] = this.receiverDetails.toJson();
    }
    if (this.parcelCategory != null) {
      data['parcel_category'] = this.parcelCategory.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class DeliveryAddress {
  int id;
  String addressType;
  String contactPersonNumber;
  String address;
  String latitude;
  String longitude;
  int userId;
  String contactPersonName;
  String createdAt;
  String updatedAt;
  int zoneId;
  String streetNumber;
  String house;
  String floor;


  DeliveryAddress(
      {this.id,
        this.addressType,
        this.contactPersonNumber,
        this.address,
        this.latitude,
        this.longitude,
        this.userId,
        this.contactPersonName,
        this.createdAt,
        this.updatedAt,
        this.zoneId,
        this.streetNumber,
        this.house,
        this.floor});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    userId = json['user_id'];
    contactPersonName = json['contact_person_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zoneId = json['zone_id'];
    streetNumber = json['road'];
    house = json['house'];
    floor = json['floor'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_type'] = this.addressType;
    data['contact_person_number'] = this.contactPersonNumber;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['user_id'] = this.userId;
    data['contact_person_name'] = this.contactPersonName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['zone_id'] = this.zoneId;
    data['road'] = this.streetNumber;
    data['house'] = this.house;
    data['floor'] = this.floor;
    return data;
  }
}

class Customer {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String image;
  String createdAt;
  String updatedAt;
  String cmFirebaseToken;

  Customer(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.cmFirebaseToken});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cmFirebaseToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    return data;
  }
}

class ParcelCategory {
  int id;
  String image;
  String name;
  String description;
  String createdAt;
  String updatedAt;

  ParcelCategory(
      {this.id,
        this.image,
        this.name,
        this.description,
        this.createdAt,
        this.updatedAt});

  ParcelCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
