class WithdrawModel {
  int id;
  double amount;
  String updatedAt;
  String status;
  String bankName;
  String requestedAt;

  WithdrawModel({this.id, this.amount, this.updatedAt, this.status, this.bankName, this.requestedAt});

  WithdrawModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'].toDouble();
    updatedAt = json['updated_at'];
    status = json['status'];
    bankName = json['bank_name'];
    requestedAt = json['requested_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['bank_name'] = this.bankName;
    data['requested_at'] = this.requestedAt;
    return data;
  }
}
