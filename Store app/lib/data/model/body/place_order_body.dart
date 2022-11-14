class PlaceOrderBody {
  List<Cart> cart;
  String orderNote;
  int storeId;
  double discount;
  String discountType;
  double tax;
  double paidAmount;
  String paymentMethod;

  PlaceOrderBody(
      {this.cart,
        this.orderNote,
        this.storeId,
        this.discount,
        this.discountType,
        this.tax,
        this.paidAmount,
        this.paymentMethod});

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      cart = [];
      json['cart'].forEach((v) {
        cart.add(new Cart.fromJson(v));
      });
    }
    orderNote = json['order_note'];
    storeId = json['store_id'];
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    tax = json['tax'].toDouble();
    paidAmount = json['paid_amount'].toDouble();
    paymentMethod = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cart != null) {
      data['cart'] = this.cart.map((v) => v.toJson()).toList();
    }
    data['order_note'] = this.orderNote;
    data['store_id'] = this.storeId;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['tax'] = this.tax;
    data['paid_amount'] = this.paidAmount;
    data['payment_method'] = this.paymentMethod;
    return data;
  }
}

class Cart {
  int itemId;
  int itemCampaignId;
  double price;
  List<String> variant;
  List<Variation> variation;
  double discountAmount;
  int quantity;
  double taxAmount;
  List<int> addOnIds;
  List<int> addOnQtys;

  Cart(
      {this.itemId,
        this.itemCampaignId,
        this.price,
        this.variant,
        this.variation,
        this.discountAmount,
        this.quantity,
        this.taxAmount,
        this.addOnIds,
        this.addOnQtys});

  Cart.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemCampaignId = json['item_campaign_id'];
    price = json['price'].toDouble();
    variant = json['variant'].cast<String>();
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation.add(new Variation.fromJson(v));
      });
    }
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    taxAmount = json['tax_amount'].toDouble();
    addOnIds = json['add_on_ids'].cast<int>();
    addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['item_campaign_id'] = this.itemCampaignId;
    data['price'] = this.price;
    data['variant'] = this.variant;
    if (this.variation != null) {
      data['variation'] = this.variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this.discountAmount;
    data['quantity'] = this.quantity;
    data['tax_amount'] = this.taxAmount;
    data['add_on_ids'] = this.addOnIds;
    data['add_on_qtys'] = this.addOnQtys;
    return data;
  }
}

class Variation {
  String type;
  double price;

  Variation({this.type, this.price});

  Variation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}
