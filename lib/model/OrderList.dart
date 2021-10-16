class OrderListUser {
  bool ok;
  List<Orderuser> orderuser;

  OrderListUser({this.ok, this.orderuser});

  OrderListUser.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['orderuser'] != null) {
      orderuser = new List<Orderuser>();
      json['orderuser'].forEach((v) {
        orderuser.add(new Orderuser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.orderuser != null) {
      data['orderuser'] = this.orderuser.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orderuser {
  int orId;
  String orDate;
  String orTime;
  int orNum;
  String orDetail;
  int orStatus;
  double orLat;
  double orLng;
  String orAddress;
  String orOffice;
  int uId;

  Orderuser(
      {this.orId,
      this.orDate,
      this.orTime,
      this.orNum,
      this.orDetail,
      this.orStatus,
      this.orLat,
      this.orLng,
      this.orAddress,
      this.orOffice,
      this.uId});

  Orderuser.fromJson(Map<String, dynamic> json) {
    orId = json['or_id'];
    orDate = json['or_date'];
    orTime = json['or_time'];
    orNum = json['or_num'];
    orDetail = json['or_detail'];
    orStatus = json['or_status'];
    orLat = json['or_lat'];
    orLng = json['or_lng'];
    orAddress = json['or_address'];
    orOffice = json['or_office'];
    uId = json['u_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['or_id'] = this.orId;
    data['or_date'] = this.orDate;
    data['or_time'] = this.orTime;
    data['or_num'] = this.orNum;
    data['or_detail'] = this.orDetail;
    data['or_status'] = this.orStatus;
    data['or_lat'] = this.orLat;
    data['or_lng'] = this.orLng;
    data['or_address'] = this.orAddress;
    data['or_office'] = this.orOffice;
    data['u_id'] = this.uId;
    return data;
  }
}