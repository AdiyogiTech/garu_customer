import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/Model/Location_model.dart';
import 'package:garu_customer/Model/settingModel.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/main.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/login/login_screen.dart';

var setting_json_data;
var location_data;

class ApiBaseHelper {
  //late Map<String, String> mainHeaders;

  var token = prefs!.getString("token");
  Map<String, String> headers = {
    // 'Content-Type': 'application/json',
    Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
  };
  late Map<String, String> mainHeaders;

  mainheaderTrue(token) {
    mainHeaders = {
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    print("inside mainheaderTrue: mainHeaders initialized: $mainHeaders");
  }

  locationdata(response) {
    print('inside response $response');
    var JWTmodel = LocationModel.fromJson(response);
    print('inside  pref data setting${json.encode(JWTmodel).toString()}');
    prefs!.setString("location", json.encode(JWTmodel).toString());
    location_data = json.decode(prefs!.getString("location").toString());
    print('inside preference location data $location_data');
  }

  Future<void> gettinSettingData() async {
    setting_json_data = json.decode(prefs!.getString("setting").toString());
  }

  settingdata(response) {
    print('inside prefrence instance $prefs');
    print('inside setting ');
    print('inside settingdata ApiBaseHelper Response ${response}');
    print('inside Response type: ${response.runtimeType}');
    log('inside Response structure: ${json.encode(response)}');

    var JWTmodel = SettingModel.fromJson(response);
    prefs!.setString("setting", json.encode(JWTmodel).toString());
    setting_json_data = json.decode(prefs!.getString("setting").toString());
    log(
        'inside setting data setting_json_data  ApiBaseHelper$setting_json_data');
    // var JWTmodel = SettingModel.fromJson(response);
    // print('inside JWTMOdel$JWTmodel');// Assuming `response` is your JSON data
    // String settingJsonString = json.encode(JWTmodel);
    // print('inside settingJsonString  $settingJsonString');// Convert SettingModel to JSON string
    // prefs!.setString("setting", settingJsonString); // Store JSON string in SharedPreferences
  }

  // mainheaderTrue(token){
  //   mainHeaders = {
  //     Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  // }
  Future<void> getPrefance() async {
    var is_login = prefs!.getBool("loggedin") ?? false;
    print("is_login : " + is_login.toString());
    // Future.delayed(
    //   Duration(seconds: 4),
    //   () {
    //     Get.to(is_login == true ? bottomBar(bottom: 1) : CompanyNameScreen());
    //   },
    // );
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      prefs!.setString(
          "deviceid", iosDeviceInfo.identifierForVendor.toString());
      return iosDeviceInfo.identifierForVendor.toString(); // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      prefs!.setString("deviceid", androidDeviceInfo.id.toString());
      log("check android id --->>${prefs!.getString("deviceid")}");
      return androidDeviceInfo.id.toString();
    }
  }

  Future<void> AppLogout() async {
    // prefs!.clear();
    // prefs!.setBool("loggedin", false);
    //
    // prefs!.remove("profileImage_url");
    // prefs!.remove("user_name");
    //
    // Get.offAll(LoginPage());
    try {
      // SharedPreferences clear
      prefs!.setBool("loggedin", false);
      prefs!.setBool("notifications_enabled", false);

      prefs!.remove("facebook_url");
      prefs!.remove("twitter_url");
      prefs!.remove("youtube_url");
      prefs!.remove("instagram_url");
      prefs!.remove("vendor_link");
      prefs!.remove("razorpay_key");
      prefs!.remove("profileImage_url");
      prefs!.remove("user_name");
      prefs!.remove("user_mobile");
      prefs!.remove("referral_code");
      prefs!.remove("token");

      // Optional: temp cache files bhi delete karna ho to
      final tempDir = Directory.systemTemp;
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      Get.offAll(() => const LoginPage()); // back stack bhi clear
    } catch (e) {
      print("Logout error: $e");
    }
  }

  Future<void> loginRedirect() async {
    // get to the login page when api responce 401
    Get.to(LoginPage());
  }

  Future submitFeedbackApi(String rating, String message) async {
    final Uri url =
    Uri.parse("${Environment.apibaseurl}submit-feedback");

    try {
      final response = await postAPICall(
        url,
        jsonEncode({
          "rating": rating,
          "message": message,
        }),
        true,
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true || data['status'] == true) {
        toastMsg(
          data['message']?.toString() ?? "Feedback submitted successfully",
          true,
        );

        Get.back();
      } else {
        // First priority: data.message
        String errorMessage =
            data['data']?['message']?.toString() ??
                data['message']?.toString() ??
                "Something went wrong";

        toastMsg(errorMessage, false);
      }
    } catch (e) {
      print("submitFeedbackApi error: $e");
      toastMsg("Something went wrong", false);
    }
  }

  Future<void> deleteAccountApi() async {
    final Uri url =
    Uri.parse("${Environment.apibaseurl}delete-account");

    try {
      final response = await postAPICall(
        url,
        jsonEncode({}), // empty body
        true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          toastMsg(data['message'], true);
          await AppLogout();
        } else {
          toastMsg(data['message'], false);
        }
      } else {
        toastMsg("Server error (${response.statusCode})", false);
      }
    } catch (e) {
      toastMsg("Something went wrong", false);
    }
  }



  // Map<String, String> headers = {
  //   // 'Content-Type': 'application/json',
  //   Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
  // };
  Future<http.Response> deleteAPICall(Uri url) async {
    print('Deleting address from URL: $url');

    var headers = {
      //  'x-api-key': '538169906bf099c756e010bcf0684eead23b051ca0b5ad6b9e79dec5',
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      // 'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWJlZTVlOGFkZGU1MGE5ZWQyZTc1OWI4ZDgxMGNiOGM4ZGI4NWI1MzYyMjViMTE2ZGQzNmVkMjVhYjkxY2ZhOWVlOTA5ZTNiODg1MzBiMGYiLCJpYXQiOjE3MTk2NjU5ODguMjg2NzA2LCJuYmYiOjE3MTk2NjU5ODguMjg2NzA4LCJleHAiOjE3NTEyMDE5ODguMTE2MTUxLCJzdWIiOiI1Iiwic2NvcGVzIjpbImN1c3RvbWVyIl19.DPdjKRXfOHP6ZcoRrCf5s_yQVnsJRJ0hU3FlwgPgvhN5AZ3X6dGH9Su8okTBwNpNBmd_gAWp-01R8UOUNGAS2SGL8WQE9erAnTVAdlK97QPV5WoTXaPy1TiJYsy4vpjgyrXT6155qeUiXbyU01XrSVXr-CZRjEj7KwADz0XdL6jcokGW99tMsBj4TN3xZa8KzW0Fk9luKMBwehvQ7h75Gxyrctb-3YPs2N3uXHrTxr0zKIE03VQsnI_Kbkvscea-HhdxH4a53RphCvTCKpjFS_LMVBQJnqKK24QR5A351zFavf048cDEkOF95bVaVZDmcEM3pG-J4U6Z8cOnvEZTkNWMZ2el2FtiACHt2G5vbwe5KykTYuD6iu1Y2-MaAGobrTWZIPzwom9Onq_WQS4zDleYie8gl1CK2h56T41eQ6VXxYw2UgoZ2-Kc3zj9bJ9XDpkT1q5wqpCI9ydyMhesfy80CamJVPmP6AUy_h7encPBXw_yJ39xpxCDaoRrGSA3V09pp5yOTf0lTbhyNM_Ra3quBeFbmnqElGNZE8KR9kY4dpZ0dbcGh1Y3iRw_7wENu7lhccY_ipG-bn_kXkk9u9ppsEoJdyzA779meqlFDn2ROmDDas7nDhFDp7cl3gV9m7Hfn0kEoUJYpDs9EzNtNFDJyrhfMe2lNA7QzFe5zAA'
      'Authorization': 'Bearer $token'
    };

    try {
      var request = http.Request('DELETE', url);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseBody = await response.stream.bytesToString();
      print("DELETE statusCode : ${response.statusCode}");
      print("DELETE response : ${responseBody}");

      return http.Response(responseBody, response.statusCode);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Request timeout, please try again later');
    } catch (e) {
      print('Exception in DELETE request: $e');
      throw FetchDataException('An unexpected error occurred');
    }
  }

  Future<http.Response> getAPICall(Uri url, bool header) async {
    print("get url 1: $url");
    print("get headers 1: $headers");
    print("get status 1: $header");

    var token = prefs!.getString("token");
    log('inside getApi token>>> $token');
    if (header == true) {
      var token = prefs!.getString("token");
      log('inside getApi token>>>$token');
      mainheaderTrue(token);
    }
    //   print("Using headers: ${header == true ? mainHeaders : headers}");
    try {
      //print('inside mainheaders $mainHeaders');
      // print('inside headers $headers');


      final response = await http
          .get(
        url,
        headers: header == true ? mainHeaders : headers,
      )
          .timeout(
        Duration(
          seconds: int.parse(Environment.apptimeout.toString()),
        ),
      );

      print("get statusCode : ${response.statusCode.toString()}");
      print("get response : ${response.body.toString()}");
      return _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }


  Future<http.Response> postAPICall(Uri url, parameter, header) async {
    print("post url : $url");
    print("post parameter : $parameter");
    print("post parameter : $header");


    var mainHeaders;
    var headers;
    if (header == true) {
      var token = prefs!.getString("token");

      mainHeaders = {
        Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
    } else {
      headers = {
        Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
        'Content-Type': 'application/json'
      };
    }

    print("headers :: " + headers.toString());
    print("mainHeaders ::x " + mainHeaders.toString());
    try {
      var request = http.Request('POST', url);

      request.body = parameter;
      request.headers.addAll(header == true ? mainHeaders : headers);
      // request.files.add(await http.MultipartFile.fromPath('prescription_attachment', '/C:/Users/pc/Pictures/Screenshots/Screenshot (1).png'));

      http.StreamedResponse responsed = await request.send();

      var response = await http.Response.fromStream(responsed);
      print("post statusCode : ${response.statusCode.toString()}");
      print("post response : ${response.body.toString()}");
      return _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    } catch (e) {
      print("excp : " + e.toString());
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  Future<http.Response> multipartAPICall(url, parameter, header) async {
    print("multipart url : $url");
    print("multipart parameter : $parameter");
    print("multipart header : $header");

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(parameter);

      request.headers.addAll(header == true ? mainHeaders : header);

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);

      print("multipart statusCode : ${responsedata.statusCode.toString()}");
      print("multipart response : ${responsedata.body.toString()}");

      return _response(responsedata);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  Future<http.Response> multipartAPICallNew(url, parameter, File? selectedImage,
      header) async {
    print("multipart url : $url");
    print("multipart parameter : $parameter");
    print("multipart header : $header");
    // final Map<String, String> fixedHeaders = {
    //   'x-api-key': '538169906bf099c756e010bcf0684eead23b051ca0b5ad6b9e79dec5',
    //   'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiODQxZGM3ODg2OTUwYWY5YTg4Njk1ZjcwYmU2MWNkNTcxN2RkZjM3NTU5NjEwZTEwZGFhNzM1MmRlYmZiZjRlNmYyNWIxNTgxYmZjZjkxNWYiLCJpYXQiOjE3MjIyMzkxOTAuOTE1OTI2LCJuYmYiOjE3MjIyMzkxOTAuOTE1OTI3LCJleHAiOjE3NTM3NzUxOTAuOTExMjYzLCJzdWIiOiI0Iiwic2NvcGVzIjpbImN1c3RvbWVyIl19.XtadHI3xgbflaNT-254n_j4DL1UufQq_kJHRZLy1cVdfqNWkJeIdK0065BBe311jUSApv6d06by341RN5swNIIyZPZ9fpKG_X-xOhoT7wofhDq0MjYVwLYshx5JLX65fpwcPoBq8NfYrHow3TWYwn6UPjMg50I7vjLne6Gs5pKar2e4cFDJt5lLPNApXmKapGJg3L_6fRtBceIsm_ZQ5_1LGg53W5ElCl6RXZbbIrN3gasXU-p2OdT1dmQGlR3SVxGlFz0V1BVyDzCUeOKKgdlCDtXW6vZbwnitv_t2QsISNhusvSsgF8LNgBLHcf7NmUk2xWlIwhuTo7N3Vs11uUqAIHdz6hT0dFWSTl-2Xf7kMQ3W1akU0FtjWMTuYMdLPCUGek0szwqH-y2njiwm2lpEBW_h7XCjX8rekh3Dz6xazrIjZ1FhzsbfBxGVbx-zi2YGNBbpPW6Nc4b-IvTTSRhSJyDKgtk1nO3avHg1ykHnIglhHEVBUP036kf22tyCetdhkMNrYZ36OW_D_a3thJDsxMks8pCSI0_tWGG4pM6rHNtmbpKGtFSLMbwdZnsn64bLJsAbvNUyhKSDKEmUHIRXl_g2L4jBZH8G23-ZrGJsKLs4v1E8vHeYHHk2HTn_XL4y5t5-PTX4q-aUc65WtVQMln20n2xaqfZlqtTEdj8U',
    //   'Content-Type': 'multipart/form-data'
    // };
    if (header == true) {
      var token = prefs!.getString("token");

      mainHeaders = {
        Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token'
      };
    } else {
      headers = {
        Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
        'Content-Type': 'application/json'
      };
    }
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      // request.fields.addAll(parameter);
      parameter.forEach((key, value) {
        if (value is String) {
          request.fields[key] = value;
        } else if (value is int) {
          request.fields[key] = value.toString();
        }
      });
      // Add file to the request if it's not null
      if (selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('attachment', selectedImage.path),
        );
      }
      //request.headers.addAll(fixedHeaders);
      request.headers.addAll(header == true ? mainHeaders : header);
      // Add headers to the request
      //request.headers.addAll(header);
      // request.fields.addAll(parameter);
      //
      // request.headers.addAll(header == true ? mainHeaders : header);
      //
      //  request.headers.addAll(header == true ? mainHeaders : header);
      // request.fields.addAll(parameter);
      http.StreamedResponse responses = await request.send();
      var responsedata = await http.Response.fromStream(responses);
      //
      print("multipart statusCode : ${responsedata.statusCode.toString()}");
      print("multipart response : ${responsedata.body.toString()}");

      return _response(responsedata);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  Future<http.Response> multipartAPICallWithGet(String url,
      Map<String, dynamic> parameter, header) async
  {
    print('inside multipartAPICallWithGet $token');
    //var token =prefs!.getString("token");
    var customHeaders = {
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      // 'Authorization': 'Bearer $token',
      'Authorization': 'Bearer $token'
      // 'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWJlZTVlOGFkZGU1MGE5ZWQyZTc1OWI4ZDgxMGNiOGM4ZGI4NWI1MzYyMjViMTE2ZGQzNmVkMjVhYjkxY2ZhOWVlOTA5ZTNiODg1MzBiMGYiLCJpYXQiOjE3MTk2NjU5ODguMjg2NzA2LCJuYmYiOjE3MTk2NjU5ODguMjg2NzA4LCJleHAiOjE3NTEyMDE5ODguMTE2MTUxLCJzdWIiOiI1Iiwic2NvcGVzIjpbImN1c3RvbWVyIl19.DPdjKRXfOHP6ZcoRrCf5s_yQVnsJRJ0hU3FlwgPgvhN5AZ3X6dGH9Su8okTBwNpNBmd_gAWp-01R8UOUNGAS2SGL8WQE9erAnTVAdlK97QPV5WoTXaPy1TiJYsy4vpjgyrXT6155qeUiXbyU01XrSVXr-CZRjEj7KwADz0XdL6jcokGW99tMsBj4TN3xZa8KzW0Fk9luKMBwehvQ7h75Gxyrctb-3YPs2N3uXHrTxr0zKIE03VQsnI_Kbkvscea-HhdxH4a53RphCvTCKpjFS_LMVBQJnqKK24QR5A351zFavf048cDEkOF95bVaVZDmcEM3pG-J4U6Z8cOnvEZTkNWMZ2el2FtiACHt2G5vbwe5KykTYuD6iu1Y2-MaAGobrTWZIPzwom9Onq_WQS4zDleYie8gl1CK2h56T41eQ6VXxYw2UgoZ2-Kc3zj9bJ9XDpkT1q5wqpCI9ydyMhesfy80CamJVPmP6AUy_h7encPBXw_yJ39xpxCDaoRrGSA3V09pp5yOTf0lTbhyNM_Ra3quBeFbmnqElGNZE8KR9kY4dpZ0dbcGh1Y3iRw_7wENu7lhccY_ipG-bn_kXkk9u9ppsEoJdyzA779meqlFDn2ROmDDas7nDhFDp7cl3gV9m7Hfn0kEoUJYpDs9EzNtNFDJyrhfMe2lNA7QzFe5zAA'
    };
    print("inside multipart url : $url");
    print("inside multipart parameter : $parameter");
    print("inside multipart useMainHeaders : $header");

    try {
      final request = http.MultipartRequest('GET', Uri.parse(url));
      parameter.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      request.headers.addAll(customHeaders);

      http.StreamedResponse responses = await request.send();
      var responsedata = await http.Response.fromStream(responses);

      print("inside multipart get statusCode : ${responsedata.statusCode}");
      print("inside multipart get response : ${responsedata.body}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  Future<http.Response> GetMultipartWithQueryParams(String url, String param,
      header) async
  {
    print('inside GetMultipartWithQueryParams $token');
    //var token =prefs!.getString("token");
    var customHeaders = {
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      // 'Authorization': 'Bearer $token',
      'Authorization': 'Bearer $token'
      //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWJlZTVlOGFkZGU1MGE5ZWQyZTc1OWI4ZDgxMGNiOGM4ZGI4NWI1MzYyMjViMTE2ZGQzNmVkMjVhYjkxY2ZhOWVlOTA5ZTNiODg1MzBiMGYiLCJpYXQiOjE3MTk2NjU5ODguMjg2NzA2LCJuYmYiOjE3MTk2NjU5ODguMjg2NzA4LCJleHAiOjE3NTEyMDE5ODguMTE2MTUxLCJzdWIiOiI1Iiwic2NvcGVzIjpbImN1c3RvbWVyIl19.DPdjKRXfOHP6ZcoRrCf5s_yQVnsJRJ0hU3FlwgPgvhN5AZ3X6dGH9Su8okTBwNpNBmd_gAWp-01R8UOUNGAS2SGL8WQE9erAnTVAdlK97QPV5WoTXaPy1TiJYsy4vpjgyrXT6155qeUiXbyU01XrSVXr-CZRjEj7KwADz0XdL6jcokGW99tMsBj4TN3xZa8KzW0Fk9luKMBwehvQ7h75Gxyrctb-3YPs2N3uXHrTxr0zKIE03VQsnI_Kbkvscea-HhdxH4a53RphCvTCKpjFS_LMVBQJnqKK24QR5A351zFavf048cDEkOF95bVaVZDmcEM3pG-J4U6Z8cOnvEZTkNWMZ2el2FtiACHt2G5vbwe5KykTYuD6iu1Y2-MaAGobrTWZIPzwom9Onq_WQS4zDleYie8gl1CK2h56T41eQ6VXxYw2UgoZ2-Kc3zj9bJ9XDpkT1q5wqpCI9ydyMhesfy80CamJVPmP6AUy_h7encPBXw_yJ39xpxCDaoRrGSA3V09pp5yOTf0lTbhyNM_Ra3quBeFbmnqElGNZE8KR9kY4dpZ0dbcGh1Y3iRw_7wENu7lhccY_ipG-bn_kXkk9u9ppsEoJdyzA779meqlFDn2ROmDDas7nDhFDp7cl3gV9m7Hfn0kEoUJYpDs9EzNtNFDJyrhfMe2lNA7QzFe5zAA'
    };
    print("inside multipart url : $url");

    print("inside multipart useMainHeaders : $header");
    final urlWithSessionId = Uri.parse(url).replace(queryParameters: {
      'session': param,
      ...Uri
          .parse(url)
          .queryParameters,
    }).toString();

    print("inside multipart url : $urlWithSessionId");
    print("inside multipart useMainHeaders : $header");

    try {
      final request = http.MultipartRequest('GET', Uri.parse(urlWithSessionId));
      // parameter.forEach((key, value) {
      //   request.fields[key] = value.toString();
      // });

      request.headers.addAll(customHeaders);

      http.StreamedResponse responses = await request.send();
      var responsedata = await http.Response.fromStream(responses);

      // print("inside multipart get statusCode : ${responsedata.statusCode}");
      // print("inside multipart get response : ${responsedata.body}");
      //
      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  Future<http.Response> deleteRequest(String url, Map<String, String> headers,
      Map<String, String> queryParams) async {
    print('inside deleteRequest $url');

    final urlWithQueryParams = Uri.parse(url).replace(
        queryParameters: queryParams).toString();

    try {
      final request = http.Request('DELETE', Uri.parse(urlWithQueryParams))
        ..headers.addAll(headers);

      final response = await http.Response.fromStream(await request.send());

      print("inside deleteRequest statusCode : ${response.statusCode}");
      print("inside deleteRequest response : ${response.body}");

      return response;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  http.Response _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 201:
      // toastMsg(jsonDecode(response.body)['messages'][0], false);
        return response;
      case 400:
      // toastMsg(jsonDecode(response.body)['messages'][0], false);
        return response;
    // toastMsg(jsonDecode(response.body)['messages'][0], true);
    // throw BadRequestException(response.body.toString());
      case 404:
      // toastMsg(jsonDecode(response.body)['messages'][0], false);
      // throw BadRequestException(response.body.toString());
        return response;
      case 401:
      // print('inside 401');
      //   loginRedirect();
        // toastMsg(jsonDecode(response.body)['messages'][0], false);

        return response;
      case 422:
      // var decodedata = jsonDecode(response.body);
      // print("decodedata..."+decodedata.toString());
      // toastMsg(decodedata['messages'].toString(), false);
        return response;
    //
    // throw BadRequestException(response.body.toString());
      case 429: // ← ADD THIS LINE
        return response;
      case 403:
        print("403 Forbidden received");
        return response;

      case 500:
        return response;
      default:
      // toastMsg(jsonDecode(response.body)['messages'][0], false);
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode: ${response
                .statusCode}');
    }
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}