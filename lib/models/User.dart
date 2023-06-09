///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class User {
/*
{
  "ID": "3",
  "user_login": "sun@sun.com",
  "user_nicename": "sunsun-com",
  "user_email": "sun@sun.com",
  "user_url": "",
  "user_status": "0",
  "display_name": "ashar",
  "one_signal_id": "",
  "loginType": "normal",
  "isUserActivated": "",
  "phone": "",
  "firmname": "firmname kksklajsas",
  "billing_address_1": "",
  "billing_address_2": "",
  "billing_postcode": "",
  "billing_city": "",
  "billing_country": "",
  "shipping_address_1": "",
  "shipping_address_2": "",
  "shipping_city": "",
  "shipping_country": "",
  "shipping_postcode": "",
  "shipping_company": "",
  "shipping_first_name": "",
  "shipping_last_name": "",
  "isSameAddress": false,
  "err": -1
} 
*/

  String? ID;
  String? userLogin;
  String? userNicename;
  String? userEmail;
  String? userUrl;
  String? userStatus;
  String? displayName;
  String? oneSignalId;
  String? loginType;
  String? isUserActivated;
  String? phone;
  String? firmname;
  String? billingAddress_1;
  String? billingAddress_2;
  String? billingPostcode;
  String? billingCity;
  String? billingCountry;
  String? shippingAddress_1;
  String? shippingAddress_2;
  String? shippingCity;
  String? shippingCountry;
  String? shippingPostcode;
  String? shippingCompany;
  String? shippingFirstName;
  String? shippingLastName;
  bool? isSameAddress;
  int? err;

  User({
    this.ID,
    this.userLogin,
    this.userNicename,
    this.userEmail,
    this.userUrl,
    this.userStatus,
    this.displayName,
    this.oneSignalId,
    this.loginType,
    this.isUserActivated,
    this.phone,
    this.firmname,
    this.billingAddress_1,
    this.billingAddress_2,
    this.billingPostcode,
    this.billingCity,
    this.billingCountry,
    this.shippingAddress_1,
    this.shippingAddress_2,
    this.shippingCity,
    this.shippingCountry,
    this.shippingPostcode,
    this.shippingCompany,
    this.shippingFirstName,
    this.shippingLastName,
    this.isSameAddress,
    this.err,
  });
  User.fromJson(Map<String, dynamic> json) {
    ID = json['ID']?.toString();
    userLogin = json['user_login']?.toString();
    userNicename = json['user_nicename']?.toString();
    userEmail = json['user_email']?.toString();
    userUrl = json['user_url']?.toString();
    userStatus = json['user_status']?.toString();
    displayName = json['display_name']?.toString();
    oneSignalId = json['one_signal_id']?.toString();
    loginType = json['loginType']?.toString();
    isUserActivated = json['isUserActivated']?.toString();
    phone = json['phone']?.toString();
    firmname = json['firmname']?.toString();
    billingAddress_1 = json['billing_address_1']?.toString();
    billingAddress_2 = json['billing_address_2']?.toString();
    billingPostcode = json['billing_postcode']?.toString();
    billingCity = json['billing_city']?.toString();
    billingCountry = json['billing_country']?.toString();
    shippingAddress_1 = json['shipping_address_1']?.toString();
    shippingAddress_2 = json['shipping_address_2']?.toString();
    shippingCity = json['shipping_city']?.toString();
    shippingCountry = json['shipping_country']?.toString();
    shippingPostcode = json['shipping_postcode']?.toString();
    shippingCompany = json['shipping_company']?.toString();
    shippingFirstName = json['shipping_first_name']?.toString();
    shippingLastName = json['shipping_last_name']?.toString();
    isSameAddress = json['isSameAddress'];
    err = json['err']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ID'] = ID;
    data['user_login'] = userLogin;
    data['user_nicename'] = userNicename;
    data['user_email'] = userEmail;
    data['user_url'] = userUrl;
    data['user_status'] = userStatus;
    data['display_name'] = displayName;
    data['one_signal_id'] = oneSignalId;
    data['loginType'] = loginType;
    data['isUserActivated'] = isUserActivated;
    data['phone'] = phone;
    data['firmname'] = firmname;
    data['billing_address_1'] = billingAddress_1;
    data['billing_address_2'] = billingAddress_2;
    data['billing_postcode'] = billingPostcode;
    data['billing_city'] = billingCity;
    data['billing_country'] = billingCountry;
    data['shipping_address_1'] = shippingAddress_1;
    data['shipping_address_2'] = shippingAddress_2;
    data['shipping_city'] = shippingCity;
    data['shipping_country'] = shippingCountry;
    data['shipping_postcode'] = shippingPostcode;
    data['shipping_company'] = shippingCompany;
    data['shipping_first_name'] = shippingFirstName;
    data['shipping_last_name'] = shippingLastName;
    data['isSameAddress'] = isSameAddress;
    data['err'] = err;
    return data;
  }
}
