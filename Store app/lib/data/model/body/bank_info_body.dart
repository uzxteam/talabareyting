class BankInfoBody {
  String bankName;
  String branch;
  String holderName;
  String accountNo;

  BankInfoBody({this.bankName, this.branch, this.holderName, this.accountNo});

  BankInfoBody.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    branch = json['branch'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_name'] = this.bankName;
    data['branch'] = this.branch;
    data['holder_name'] = this.holderName;
    data['account_no'] = this.accountNo;
    return data;
  }
}
