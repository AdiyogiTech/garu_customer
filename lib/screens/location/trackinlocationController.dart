import 'dart:convert';
import 'dart:developer';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/location/location_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/home/dashboard_controller.dart';

class GetCurrentLocationController extends GetxController {
  /// Declare the postion also the lat long just for example
  Position? posinitial;
  RxString VerifyMsg = "".obs;
  RxString VerifyMsgTitle = "".obs;
  RxBool VerifyMsgstatus = false.obs;
  RxBool VerifyMsgstatusloading = false.obs;
  final lat = 0.0.obs, lng = 0.0.obs;
  var address = 'Getting Address..'.obs;
  var address_pincode = '000000'.obs;
  RxBool _verifylocationstatus = false.obs;
  get verifylocationstatus => _verifylocationstatus;
  LocationPermission? permission;
  var locationLoader = false.obs;
  var locationData;
  RxBool isLoadingLocation = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  getPermissionverification() async {
    VerifyMsgstatusloading.value = true;

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    log("isLocationEnabled >> " + isLocationEnabled.toString());
    if (!isLocationEnabled) {
      print('Turn on location services before requesting permission.');
      String title = "Location";
      String content = "Location is disable";

      VerifyMsgTitle.value = title;
      VerifyMsg.value = content;
      address.value = 'Getting Address..';
      address_pincode.value = '000000';
      VerifyMsgstatus.value = false;
      VerifyMsgstatusloading.value = false;
      update();

      Geolocator.openLocationSettings();
      return isLocationEnabled;
    } else {
      permission = await Geolocator.checkPermission();

    /*  if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }*/

      log("Geolocator permission >> " + permission.toString());
      if (permission == LocationPermission.unableToDetermine) {
        log("Geolocator permission >1> " + permission.toString());
        var title = "Permission";
        var content = "Location permissions are Unable To Determine";
        address.value = 'Getting Address..';
        address_pincode.value = '000000';
        // _showDialog(title,content);
        VerifyMsgTitle.value = title;
        VerifyMsg.value = content;
        VerifyMsgstatus.value = false;
        VerifyMsgstatusloading.value = false;
        update();
        Geolocator.openAppSettings();
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        log("Geolocator permission >2> " + permission.toString());
        var title = "Permission";
        var content = "Location permissions are permanently denied, we cannot request permissions.";
        // _showDialog(title,content);
        address.value = 'Getting Address..';
        address_pincode.value = '000000';
        VerifyMsgTitle.value = title;
        VerifyMsg.value = content;
        VerifyMsgstatus.value = false;
        VerifyMsgstatusloading.value = false;
        update();

      }
      if (permission == LocationPermission.denied) {

        VerifyMsg.value = "Location permission denied";
        VerifyMsgstatus.value = false;
        VerifyMsgstatusloading.value = false;

        update();

        return;
      } else {
        log("Geolocator permission >4> " + permission.toString());
        var content = "permission verified";

        VerifyMsg.value = content;
        VerifyMsgstatus.value = true;
        VerifyMsgstatusloading.value = false;
        update();
        await getPositionData();
      }

    }
  }

  getPositionData() async {
    isLoadingLocation.value = true;
    update();
    try {
      // try to log the data if its not empty
      String content = "permission verified";
      VerifyMsgTitle.value = "Veified";
      VerifyMsg.value = content;
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      print("position> : " + position.toString());
      print("Check P > : ");
      if (position != null) {
        log("${position.latitude}", name: "latitude");
        log("${position.longitude}", name: "longtitude");
        print("latitude> : " + position.latitude.toString());
        print("longtitude> : " + position.longitude.toString());
        var bodys = jsonEncode({
          'latitute': position.latitude.toString(),
          'longitute': position.longitude.toString(),
        });
        print("verifylocation_body position--> " + bodys.toString());

        /// just pass this to ui to use
        lat(position.latitude);
        lng(position.longitude);
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        address_pincode.value = placemarks[0].postalCode.toString();
        address.value = placemarks[0].name.toString() +
            ", " +
            placemarks[0].subLocality.toString() +
            ", " +
            placemarks[0].locality.toString() +
            ", \n" +
            placemarks[0].administrativeArea.toString() +
            ", " +
            placemarks[0].postalCode.toString();

        print(placemarks.first.locality);
        print(placemarks.first.postalCode);

        update();
      } else {
        String content = "Location Not Fetched";
        VerifyMsg.value = content;
        VerifyMsgstatus.value = true;
      }
    } catch (e) {
      print("Error in getPositionData: $e");
    } finally {
      isLoadingLocation.value = false;
      update();
    }
  }
  String? getcityname;
  String? getpincode;
  SetLocation(url, parameter, splashOrNot) async {
    locationLoader(true);
    try {
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      locationData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("locationData....." + locationData['data'].toString());

        // if (locationData['status'] == true) {
        //   if (splashOrNot == true) {
        //     Get.to(BottomBar(
        //       bottomindex: 2,
        //     ));
        //   } else {
        //     Get.back();
        //   }
        //   ApiBaseHelper().locationdata(locationData);
        //   // var msg= locationData['message'];
        //   // toastMsg(msg.toString(),true);
        //
        //   locationLoader(false);
        //   update();
        // }
        if (locationData['status'] == true) {

          // ⭐ ADD THIS
          getcityname = locationData['data']['city_name'];
          getpincode = locationData['data']['pincode'];

          // Update LooocationController with new location data
          Get.find<LooocationController>().updateLocationData(
            getpincode.toString(),
            getcityname.toString(),
          );

          // Fetch historical data based on city name
          final homeController = Get.isRegistered<HomeController>()
              ? Get.find<HomeController>()
              : Get.put(HomeController());
          await homeController.getHistoricalData(cityName: getcityname.toString());

          if (splashOrNot == true) {
            Get.offAll(BottomBar(bottomindex: 2));
          } else {
            Get.back();
          }

          ApiBaseHelper().locationdata(locationData);

          locationLoader(false);
          update();   // ⭐ IMPORTANT
        }
        else {
          var msg = locationData['message'];
          toastMsg(msg.toString(), false);
          locationLoader(false);
        }
        update();
        refresh();
      } else if (response.statusCode == 404) {
        var msg = locationData['message'];
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
