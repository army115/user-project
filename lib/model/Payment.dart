class Payment {
  bool ok;
  List<Pay> pay;

  Payment({this.ok, this.pay});

  Payment.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['pay'] != null) {
      pay = new List<Pay>();
      json['pay'].forEach((v) {
        pay.add(new Pay.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.pay != null) {
      data['pay'] = this.pay.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pay {
  int payId;
  String payImg;
  String payDate;
  String payTime;
  String payBank;
  double paySale;
  int orId;
  String orDate;
  String orTime;
  int orNum;
  String orDetail;
  int orStatus;
  double orLat;
  double orLng;
  String orAddress;
  int uId;

  Pay(
      {this.payId,
      this.payImg,
      this.payDate,
      this.payTime,
      this.payBank,
      this.paySale,
      this.orId,
      this.orDate,
      this.orTime,
      this.orNum,
      this.orDetail,
      this.orStatus,
      this.orLat,
      this.orLng,
      this.orAddress,
      this.uId});

  Pay.fromJson(Map<String, dynamic> json) {
    payId = json['pay_id'];
    payImg = json['pay_img'];
    payDate = json['pay_date'];
    payTime = json['pay_time'];
    payBank = json['pay_bank'];
    paySale = json['pay_sale'];
    orId = json['or_id'];
    orDate = json['or_date'];
    orTime = json['or_time'];
    orNum = json['or_num'];
    orDetail = json['or_detail'];
    orStatus = json['or_status'];
    orLat = json['or_lat'];
    orLng = json['or_lng'];
    orAddress = json['or_address'];
    uId = json['u_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_id'] = this.payId;
    data['pay_img'] = this.payImg;
    data['pay_date'] = this.payDate;
    data['pay_time'] = this.payTime;
    data['pay_bank'] = this.payBank;
    data['pay_sale'] = this.paySale;
    data['or_id'] = this.orId;
    data['or_date'] = this.orDate;
    data['or_time'] = this.orTime;
    data['or_num'] = this.orNum;
    data['or_detail'] = this.orDetail;
    data['or_status'] = this.orStatus;
    data['or_lat'] = this.orLat;
    data['or_lng'] = this.orLng;
    data['or_address'] = this.orAddress;
    data['u_id'] = this.uId;
    return data;
  }
}