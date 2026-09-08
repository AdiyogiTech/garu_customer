import 'dart:convert';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';

import '../../main.dart';

class SettingController extends GetxController {
  var setting_response;
  var isOtpAllow;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  SettingData(url) async {
    try {
// Do not redeclare setting_response, instead, use a different variable
      var apiResponse = await ApiBaseHelper().getAPICall(url, false);
      print('inside setting controller SettingData ${apiResponse}');
      if (apiResponse != null) {
        print('inside if apiResponse'); // Check if the API call was successful
        if (apiResponse.statusCode == 200) {
          print('inside if if apiResponse 200');
          var response = jsonDecode(apiResponse.body);
          setting_response =
              response['data']; // Update the global variable here
          print("inside setting_response: " + setting_response.toString());
          print('inside setting response... otp: ' +
              setting_response['settings']['is_otp_allow'].toString());
          isOtpAllow = setting_response['settings']['is_otp_allow'].toString();
          final facebook =
              setting_response['settings']['facebook']?.toString() ?? '';

          final twitter =
              setting_response['settings']['twitter']?.toString() ?? '';

          final youtube =
              setting_response['settings']['youtube']?.toString() ?? '';

          final instagram =
              setting_response['settings']['instagram']?.toString() ?? '';

          final vendorLink =
              setting_response['settings']['become_vendor_link']?.toString() ?? '';

final razorpayKey =
              setting_response['settings']['razorpay_key']?.toString() ?? '';

          await prefs!.setString('facebook_url', facebook);
          await prefs!.setString('twitter_url', twitter);
          await prefs!.setString('youtube_url', youtube);
          await prefs!.setString('instagram_url', instagram);
          await prefs!.setString('vendor_link', vendorLink);
          await prefs!.setString('razorpay_key', razorpayKey);

          print("Facebook => $facebook");
          print("Twitter => $twitter");
          print("Youtube => $youtube");
          print("Instagram => $instagram");
          print("Vendor Link => $vendorLink");
          print("razorpay_key => $razorpayKey");

          ApiBaseHelper()
              .settingdata(response); // Call helper method if required
          update(); // Notify listeners of data change
        } else {
          print('API status code is not 200: ${apiResponse.statusCode}');
          update();
        }
      } else {
        print('apiResponse is null');
      }
    } catch (e) {
      print("SettingData catch error => " + e.toString());
      update();
    }
  }
}
