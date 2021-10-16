class OrderSentUser {
  bool ok;
  List<Sentuser> sentuser;

  OrderSentUser({this.ok, this.sentuser});

  OrderSentUser.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['sentuser'] != null) {
      sentuser = new List<Sentuser>();
      json['sentuser'].forEach((v) {
        sentuser.add(new Sentuser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.sentuser != null) {
      data['sentuser'] = this.sentuser.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sentuser {
  int sentId;
  String sentDate;
  String sentTime;
  int sentNum;
  int sentSale;
  int checkId;
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

  Sentuser(
      {this.sentId,
      this.sentDate,
      this.sentTime,
      this.sentNum,
      this.sentSale,
      this.checkId,
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

  Sentuser.fromJson(Map<String, dynamic> json) {
    sentId = json['sent_id'];
    sentDate = json['sent_date'];
    sentTime = json['sent_time'];
    sentNum = json['sent_num'];
    sentSale = json['sent_sale'];
    checkId = json['check_id'];
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
    data['sent_id'] = this.sentId;
    data['sent_date'] = this.sentDate;
    data['sent_time'] = this.sentTime;
    data['sent_num'] = this.sentNum;
    data['sent_sale'] = this.sentSale;
    data['check_id'] = this.checkId;
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