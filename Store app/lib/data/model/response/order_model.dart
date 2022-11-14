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
  double orderAmount;
  double couponDiscountAmount;
  String couponDiscountTitle;
  String paymentStatus;
  String orderStatus;
  double totalTaxAmount;
  String paymentMethod;
  String orderNote;
  String orderType;
  String createdAt;
  String updatedAt;
  double deliveryCharge;
  String scheduleAt;
  String otp;
  String pending;
  String accepted;
  String confirmed;
  String processing;
  String handover;
  String pickedUp;
  String delivered;
  String canceled;
  String refundRequested;
  String refunded;
  DeliveryAddress deliveryAddress;
  int scheduled;
  double storeDiscountAmount;
  String storeName;
  String storeAddress;
  String storePhone;
  String storeLat;
  String storeLng;
  String storeLogo;
  int itemCampaign;
  int detailsCount;
  String orderAttachment;
  String moduleType;
  Customer customer;

  OrderModel(
      {this.id,
        this.orderAmount,
        this.couponDiscountAmount,
        this.couponDiscountTitle,
        this.paymentStatus,
        this.orderStatus,
        this.totalTaxAmount,
        this.paymentMethod,
        this.orderNote,
        this.orderType,
        this.createdAt,
        this.updatedAt,
        this.deliveryCharge,
        this.scheduleAt,
        this.otp,
        this.pending,
        this.accepted,
        this.confirmed,
        this.processing,
        this.handover,
        this.pickedUp,
        this.delivered,
        this.canceled,
        this.refundRequested,
        this.refunded,
        this.deliveryAddress,
        this.scheduled,
        this.storeDiscountAmount,
        this.storeName,
        this.storeAddress,
        this.storePhone,
        this.storeLat,
        this.storeLng,
        this.storeLogo,
        this.itemCampaign,
        this.detailsCount,
        this.customer,
        this.orderAttachment,
        this.moduleType,
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderAmount = json['order_amount'].toDouble();
    couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount'].toDouble();
    paymentMethod = json['payment_method'];
    orderNote = json['order_note'];
    orderType = json['order_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge'].toDouble();
    scheduleAt = json['schedule_at'];
    otp = json['otp'];
    pending = json['pending'];
    accepted = json['accepted'];
    confirmed = json['confirmed'];
    processing = json['processing'];
    handover = json['handover'];
    pickedUp = json['picked_up'];
    delivered = json['delivered'];
    canceled = json['canceled'];
    refundRequested = json['refund_requested'];
    refunded = json['refunded'];
    deliveryAddress = json['delivery_address'] != null
        ? new DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    scheduled = json['scheduled'];
    storeDiscountAmount = json['store_discount_amount'].toDouble();
    storeName = json['store_name'];
    storeAddress = json['store_address'];
    storePhone = json['store_phone'];
    storeLat = json['store_lat'];
    storeLng = json['store_lng'];
    storeLogo = json['store_logo'];
    itemCampaign = json['item_campaign'];
    detailsCount = json['details_count'];
    orderAttachment = json['order_attachment'];
    moduleType = json['module_type'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_amount'] = this.orderAmount;
    data['coupon_discount_amount'] = this.couponDiscountAmount;
    data['coupon_discount_title'] = this.couponDiscountTitle;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['payment_method'] = this.paymentMethod;
    data['order_note'] = this.orderNote;
    data['order_type'] = this.orderType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_charge'] = this.deliveryCharge;
    data['schedule_at'] = this.scheduleAt;
    data['otp'] = this.otp;
    data['pending'] = this.pending;
    data['accepted'] = this.accepted;
    data['confirmed'] = this.confirmed;
    data['processing'] = this.processing;
    data['handover'] = this.handover;
    data['picked_up'] = this.pickedUp;
    data['delivered'] = this.delivered;
    data['canceled'] = this.canceled;
    data['refund_requested'] = this.refundRequested;
    data['refunded'] = this.refunded;
    if (this.deliveryAddress != null) {
      data['delivery_address'] = this.deliveryAddress.toJson();
    }
    data['scheduled'] = this.scheduled;
    data['store_discount_amount'] = this.storeDiscountAmount;
    data['store_name'] = this.storeName;
    data['store_address'] = this.storeAddress;
    data['store_phone'] = this.storePhone;
    data['store_lat'] = this.storeLat;
    data['store_lng'] = this.storeLng;
    data['store_logo'] = this.storeLogo;
    data['item_campaign'] = this.itemCampaign;
    data['details_count'] = this.detailsCount;
    data['order_attachment'] = this.orderAttachment;
    data['module_type'] = this.moduleType;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class DeliveryAddress {
  String contactPersonName;
  String contactPersonNumber;
  String addressType;
  String address;
  String longitude;
  String latitude;
  String streetNumber;
  String house;
  String floor;

  DeliveryAddress(
      {this.contactPersonName,
        this.contactPersonNumber,
        this.addressType,
        this.address,
        this.longitude,
        this.latitude,
        this.streetNumber,
        this.house,
        this.floor});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    addressType = json['address_type'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    streetNumber = json['road'];
    house = json['house'];
    floor = json['floor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact_person_name'] = this.contactPersonName;
    data['contact_person_number'] = this.contactPersonNumber;
    data['address_type'] = this.addressType;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
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

  Customer(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.image,
        this.createdAt,
        this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
