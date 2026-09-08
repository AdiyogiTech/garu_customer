import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/auth_textformfield_widget.dart';
import 'package:garu_customer/helper_widget/authentication_back_widget.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
// import 'package:garu_customer/screens/bottom_bar/garu_customer.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/strings.dart';

import '../bottom_bar/BottomBar.dart';
import '../constant/validations.dart';
import '../home/dashboard_controller.dart';

class DeliveryLocation extends StatefulWidget {
  const DeliveryLocation({super.key});

  @override
  State<DeliveryLocation> createState() => _DeliveryLocationState();
}

class _DeliveryLocationState extends State<DeliveryLocation> {
  final formKey = GlobalKey<FormState>();
  LooocationController locationController = Get.put(LooocationController());
  Future<void> SaveLocation() async {
    if (formKey.currentState!.validate()) {
      var pincodeNo = locationController.pincodeController.text;
      print('inside Pincode ..::.. ${pincodeNo}');
      var locationUrl = Uri.parse(location_url);
      var locationbody = json.encode({"pincode": pincodeNo.toString()});
      await locationController.SetLocation(locationUrl, locationbody, true);
      // Get.to(BottomBar(bottomindex: 2,));
      // Get.to(BottomBar(bottomIndex: 2));
      // Get.to(BottomBar(bottomindex: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,

        body: AuthBackground(
      labelname: deliveryLocation,
      childs: Form(
        key: formKey,
        child: Column(
          children: [
            sizebox_height_60,
            AuthTextField(
              hintText: enter_pincode,
              // length: 6,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: locationController.pincodeController,
              IconImage: 'assets/images/locationIcon.png',
              // validator: Validations.validatePincode,
            ),
            sizebox_height_60,
            GestureDetector(
              onTap: () {
                SaveLocation();
              },
              child: CircleAvatar(
                radius: 35,
                backgroundColor: primary3,
                child: Center(
                    child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: white,
                  size: 55,
                )),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class LooocationController extends GetxController {
  var locationLoader = false.obs;
  var locationData;

  TextEditingController pincodeController = TextEditingController();
  TextEditingController errormsgController = TextEditingController();

  var _geterrorMsg;
  get errorMsg => _geterrorMsg;

  var _getpincode;
  get getpincode => _getpincode;
  var _getcityname;
  get getcityname => _getcityname;

  void updateLocationData(String pincode, String cityName) {
    _getpincode = pincode;
    _getcityname = cityName;
    update();
    refresh();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  SetLocation(url, parameter, splashOrNot) async {
    locationLoader(true);
    try {
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      locationData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        locationData = jsonDecode(response.body);
        print("inside locationData....." + locationData['data'].toString());
        _getpincode = locationData['data']['pincode'].toString();
        _getcityname = locationData['data']['city_name'].toString();
        print("inside _getpincode-->>>" + _getpincode.toString());
        print("inside _getcityname-->>>" + _getcityname.toString());
        final homeController = Get.isRegistered<HomeController>()
            ? Get.find<HomeController>()
            : Get.put(HomeController());
        await homeController.getHistoricalData(cityName: _getcityname.toString());
        update();

        refresh();

        if (locationData['status'] == true) {
          if(splashOrNot){

            Get.offAll(
              BottomBar(bottomindex:2),
            );

          }

          ApiBaseHelper().locationdata(locationData);

          pincodeController.clear();
          locationLoader(false);
          update();
          refresh();
        } else {
          var msg = locationData['message'];
          toastMsg(msg.toString(), false);
          locationLoader(false);
        }
        update();
        refresh();
      } else if (response.statusCode == 404) {
        var msg = locationData['message'];
        // errormsgController.text =msg.toString();
        toastMsg(msg.toString(), false);
        Get.to(DeliveryLocation());
        locationLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      locationLoader(false);
      print("..... ${e}  :: in catch");
      update();
    }
  }
}
