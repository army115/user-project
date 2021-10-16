class CheckOrderUser {
  bool ok;
  List<Checkuser> checkuser;

  CheckOrderUser({this.ok, this.checkuser});

  CheckOrderUser.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['checkuser'] != null) {
      checkuser = new List<Checkuser>();
      json['checkuser'].forEach((v) {
        checkuser.add(new Checkuser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.checkuser != null) {
      data['checkuser'] = this.checkuser.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Checkuser {
  int checkId;
  int checkNum;
  Null checkSale;
  String checkDate;
  String checkTime;
  int orId;
  int psId;
  String orDate;
  String orTime;
  int orNum;
  String orDetail;
  String orOffice;
  int orStatus;
  double orLat;
  double orLng;
  String orAddress;
  int uId;

  Checkuser(
      {this.checkId,
      this.checkNum,
      this.checkSale,
      this.checkDate,
      this.checkTime,
      this.orId,
      this.psId,
      this.orDate,
      this.orTime,
      this.orNum,
      this.orDetail,
      this.orOffice,
      this.orStatus,
      this.orLat,
      this.orLng,
      this.orAddress,
      this.uId});

  Checkuser.fromJson(Map<String, dynamic> json) {
    checkId = json['check_id'];
    checkNum = json['check_num'];
    checkSale = json['check_sale'];
    checkDate = json['check_date'];
    checkTime = json['check_time'];
    orId = json['or_id'];
    psId = json['ps_id'];
    orDate = json['or_date'];
    orTime = json['or_time'];
    orNum = json['or_num'];
    orDetail = json['or_detail'];
    orOffice = json['or_office'];
    orStatus = json['or_status'];
    orLat = json['or_lat'];
    orLng = json['or_lng'];
    orAddress = json['or_address'];
    uId = json['u_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['check_id'] = this.checkId;
    data['check_num'] = this.checkNum;
    data['check_sale'] = this.checkSale;
    data['check_date'] = this.checkDate;
    data['check_time'] = this.checkTime;
    data['or_id'] = this.orId;
    data['ps_id'] = this.psId;
    data['or_date'] = this.orDate;
    data['or_time'] = this.orTime;
    data['or_num'] = this.orNum;
    data['or_detail'] = this.orDetail;
    data['or_office'] = this.orOffice;
    data['or_status'] = this.orStatus;
    data['or_lat'] = this.orLat;
    data['or_lng'] = this.orLng;
    data['or_address'] = this.orAddress;
    data['u_id'] = this.uId;
    return data;
  }
}