// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  bool status;
  String message;
  Data data;

  LocationModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
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
  String areaId;
  String name;
  String pincode;
  String countryName;
  String stateName;
  String cityName;
  String latitude;
  String longitude;

  Data({
    required this.areaId,
    required this.name,
    required this.pincode,
    required this.countryName,
    required this.stateName,
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    areaId: json["area_id"],
    name: json["name"],
    pincode: json["pincode"],
    countryName: json["country_name"],
    stateName: json["state_name"],
    cityName: json["city_name"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "area_id": areaId,
    "name": name,
    "pincode": pincode,
    "country_name": countryName,
    "state_name": stateName,
    "city_name": cityName,
    "latitude": latitude,
    "longitude": longitude,
  };
}
