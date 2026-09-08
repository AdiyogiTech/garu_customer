// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  bool status;
  String message;
  Data data;

  SettingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Settings settings;

  Data({
    required this.settings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    settings: Settings.fromJson(json["settings"]),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
  };
}

class Settings {
  dynamic favicon;
  dynamic logo;
  dynamic applicationName;
  dynamic copyright;
  dynamic address;
  dynamic email;
  dynamic phone;
  dynamic isOtpAllow;
  dynamic facebook;
  dynamic twitter;
  dynamic youtube;
  dynamic instagram;
  dynamic emailFrom;
  dynamic smtpHost;
  dynamic smtpPort;
  dynamic smtpUser;
  dynamic smtpPass;
  dynamic razorpayKey;
  dynamic razorpaySecret;
  dynamic textlocalKey;
  dynamic textlocalUrl;
  dynamic textlocalHash;
  dynamic textlocalSender;
  dynamic forceUpdateAndroid;
  dynamic forceUpdateIos;
  dynamic appVersionAndroid;
  dynamic appVersionIos;
  dynamic appUrlAndroid;
  dynamic appUrlIos;
  dynamic forceUpdateMessageAndroid;
  dynamic forceUpdateMessageIos;
  dynamic maintenance;
  dynamic maintenanceToggle;
  dynamic defaultAddressPincode;
  dynamic footerText;
  dynamic refferMessage;
  dynamic allowCod;
  dynamic deliveryDayAfterOrder;
  dynamic deliveryMaxDay;
  dynamic deliveryOrderAfterHours;
  dynamic referralPorfitPer;
  dynamic firebaseKey;
  dynamic fixChargePer;
  dynamic deliveryChargePer;
  dynamic minCartValueForCustomer;
  dynamic minCartValueForWholesaler;
  dynamic freeShippingAboveAmountForCustomer;
  dynamic freeShippingAboveAmountForWholesaler;
  dynamic shippingChargeForLocalOrders;
  dynamic returnPeriodForLocalOrders;
  dynamic returnPeriodForGlobalOrders;
  dynamic basePath;
  Map<String, String> genderList;
  Map<String, String> addressType;
  dynamic googleMapKey;
  List<String> attributeGroup;
  List<String> isNonVeg;

  Settings({
    required this.favicon,
    required this.logo,
    required this.applicationName,
    required this.copyright,
    required this.address,
    required this.email,
    required this.phone,
    required this.isOtpAllow,
    required this.facebook,
    required this.twitter,
    required this.youtube,
    required this.instagram,
    required this.emailFrom,
    required this.smtpHost,
    required this.smtpPort,
    required this.smtpUser,
    required this.smtpPass,
    required this.razorpayKey,
    required this.razorpaySecret,
    required this.textlocalKey,
    required this.textlocalUrl,
    required this.textlocalHash,
    required this.textlocalSender,
    required this.forceUpdateAndroid,
    required this.forceUpdateIos,
    required this.appVersionAndroid,
    required this.appVersionIos,
    required this.appUrlAndroid,
    required this.appUrlIos,
    required this.forceUpdateMessageAndroid,
    required this.forceUpdateMessageIos,
    required this.maintenance,
    required this.maintenanceToggle,
    required this.defaultAddressPincode,
    required this.footerText,
    required this.refferMessage,
    required this.allowCod,
    required this.deliveryDayAfterOrder,
    required this.deliveryMaxDay,
    required this.deliveryOrderAfterHours,
    required this.referralPorfitPer,
    required this.firebaseKey,
    required this.fixChargePer,
    required this.deliveryChargePer,
    required this.minCartValueForCustomer,
    required this.minCartValueForWholesaler,
    required this.freeShippingAboveAmountForCustomer,
    required this.freeShippingAboveAmountForWholesaler,
    required this.shippingChargeForLocalOrders,
    required this.returnPeriodForLocalOrders,
    required this.returnPeriodForGlobalOrders,
    required this.basePath,
    required this.genderList,
    required this.addressType,
    required this.googleMapKey,
    required this.attributeGroup,
    required this.isNonVeg,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    favicon: json["favicon"],
    logo: json["logo"],
    applicationName: json["application_name"],
    copyright: json["copyright"],
    address: json["address"],
    email: json["email"],
    phone: json["phone"],
    isOtpAllow: json["is_otp_allow"],
    facebook: json["facebook"],
    twitter: json["twitter"],
    youtube: json["youtube"],
    instagram: json["instagram"],
    emailFrom: json["email_from"],
    smtpHost: json["smtp_host"],
    smtpPort: json["smtp_port"],
    smtpUser: json["smtp_user"],
    smtpPass: json["smtp_pass"],
    razorpayKey: json["razorpay_key"],
    razorpaySecret: json["razorpay_secret"],
    textlocalKey: json["textlocal_key"],
    textlocalUrl: json["textlocal_url"],
    textlocalHash: json["textlocal_hash"],
    textlocalSender: json["textlocal_sender"],
    forceUpdateAndroid: json["force_update_android"],
    forceUpdateIos: json["force_update_ios"],
    appVersionAndroid: json["app_version_android"],
    appVersionIos: json["app_version_ios"],
    appUrlAndroid: json["app_url_android"],
    appUrlIos: json["app_url_ios"],
    forceUpdateMessageAndroid: json["force_update_message_android"],
    forceUpdateMessageIos: json["force_update_message_ios"],
    maintenance: json["maintenance"],
    maintenanceToggle: json["maintenance_toggle"],
    defaultAddressPincode: json["default_address_pincode"],
    footerText: json["footer_text"],
    refferMessage: json["reffer_message"],
    allowCod: json["allow_cod"],
    deliveryDayAfterOrder: json["delivery_day_after_order"],
    deliveryMaxDay: json["delivery_max_day"],
    deliveryOrderAfterHours: json["delivery_order_after_hours"],
    referralPorfitPer: json["referral_porfit_per"],
    firebaseKey: json["firebase_key"],
    fixChargePer: json["fix_charge_per"],
    deliveryChargePer: json["delivery_charge_per"],
    minCartValueForCustomer: json["min_cart_value_for_customer"],
    minCartValueForWholesaler: json["min_cart_value_for_wholesaler"],
    freeShippingAboveAmountForCustomer: json["free_shipping_above_amount_for_customer"],
    freeShippingAboveAmountForWholesaler: json["free_shipping_above_amount_for_wholesaler"],
    shippingChargeForLocalOrders: json["shipping_charge_for_local_orders"],
    returnPeriodForLocalOrders: json["return_period_for_local_orders"],
    returnPeriodForGlobalOrders: json["return_period_for_global_orders"],
    basePath: json["base_path"],
    genderList: Map.from(json["gender_list"]).map((k, v) => MapEntry<String, String>(k, v)),
    addressType: Map.from(json["address_type"]).map((k, v) => MapEntry<String, String>(k, v)),
    googleMapKey: json["google_map_key"],
    attributeGroup: List<String>.from(json["attribute_group"].map((x) => x)),
    isNonVeg: List<String>.from(json["is_non_veg"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "favicon": favicon,
    "logo": logo,
    "application_name": applicationName,
    "copyright": copyright,
    "address": address,
    "email": email,
    "phone": phone,
    "is_otp_allow": isOtpAllow,
    "facebook": facebook,
    "twitter": twitter,
    "youtube": youtube,
    "instagram": instagram,
    "email_from": emailFrom,
    "smtp_host": smtpHost,
    "smtp_port": smtpPort,
    "smtp_user": smtpUser,
    "smtp_pass": smtpPass,
    "razorpay_key": razorpayKey,
    "razorpay_secret": razorpaySecret,
    "textlocal_key": textlocalKey,
    "textlocal_url": textlocalUrl,
    "textlocal_hash": textlocalHash,
    "textlocal_sender": textlocalSender,
    "force_update_android": forceUpdateAndroid,
    "force_update_ios": forceUpdateIos,
    "app_version_android": appVersionAndroid,
    "app_version_ios": appVersionIos,
    "app_url_android": appUrlAndroid,
    "app_url_ios": appUrlIos,
    "force_update_message_android": forceUpdateMessageAndroid,
    "force_update_message_ios": forceUpdateMessageIos,
    "maintenance": maintenance,
    "maintenance_toggle": maintenanceToggle,
    "default_address_pincode": defaultAddressPincode,
    "footer_text": footerText,
    "reffer_message": refferMessage,
    "allow_cod": allowCod,
    "delivery_day_after_order": deliveryDayAfterOrder,
    "delivery_max_day": deliveryMaxDay,
    "delivery_order_after_hours": deliveryOrderAfterHours,
    "referral_porfit_per": referralPorfitPer,
    "firebase_key": firebaseKey,
    "fix_charge_per": fixChargePer,
    "delivery_charge_per": deliveryChargePer,
    "min_cart_value_for_customer": minCartValueForCustomer,
    "min_cart_value_for_wholesaler": minCartValueForWholesaler,
    "free_shipping_above_amount_for_customer": freeShippingAboveAmountForCustomer,
    "free_shipping_above_amount_for_wholesaler": freeShippingAboveAmountForWholesaler,
    "shipping_charge_for_local_orders": shippingChargeForLocalOrders,
    "return_period_for_local_orders": returnPeriodForLocalOrders,
    "return_period_for_global_orders": returnPeriodForGlobalOrders,
    "base_path": basePath,
    "gender_list": Map.from(genderList).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "address_type": Map.from(addressType).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "google_map_key": googleMapKey,
    "attribute_group": List<dynamic>.from(attributeGroup.map((x) => x)),
    "is_non_veg": List<dynamic>.from(isNonVeg.map((x) => x)),
  };
}
