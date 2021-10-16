class User {
  bool ok;
  Userinfo userinfo;

  User({this.ok, this.userinfo});

  User.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    userinfo = json['userinfo'] != null
        ? new Userinfo.fromJson(json['userinfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.userinfo != null) {
      data['userinfo'] = this.userinfo.toJson();
    }
    return data;
  }
}

class Userinfo {
  int uId;
  String uUser;
  String uPass;
  String uName;
  String uLastname;
  String uTel;
  String uEmail;

  Userinfo(
      {this.uId,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLastname,
      this.uTel,
      this.uEmail});

  Userinfo.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    uUser = json['u_user'];
    uPass = json['u_pass'];
    uName = json['u_name'];
    uLastname = json['u_lastname'];
    uTel = json['u_tel'];
    uEmail = json['u_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['u_id'] = this.uId;
    data['u_user'] = this.uUser;
    data['u_pass'] = this.uPass;
    data['u_name'] = this.uName;
    data['u_lastname'] = this.uLastname;
    data['u_tel'] = this.uTel;
    data['u_email'] = this.uEmail;
    return data;
  }
}