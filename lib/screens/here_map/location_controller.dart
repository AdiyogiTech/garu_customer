import 'dart:convert';
import 'package:get/get.dart';
import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';
import '../constant/validations.dart';
import 'location_services.dart';


class LocationController extends GetxController {
  var locationSendingDataLoading = false.obs;
  Rx<double> latDelivery = 0.0.obs;
  Rx<double> longDelivery = 0.0.obs;

  final LocationService locationService = LocationService();

  // Function to call the API with location data (latitude, longitude, and address)
  locationApiCalling({required int id}) async {
    locationSendingDataLoading.value = true;

    var url = "${baseurl}delivery-boy-location/$id";

    try {
      // Prepare the request data
      var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);

      print("Location 5 mins API Respons acha e: ${response.body} ${response.statusCode}");

      // Handle success response
      if (response.statusCode == 200) {

        var responseData = jsonDecode(response.body);

        latDelivery.value = double.tryParse(responseData['data']['latitude'] ?? '0.0') ?? 0.0;
        longDelivery.value = double.tryParse(responseData['data']['longitude'] ?? '0.0') ?? 0.0;

        print("Location 5 mins API Response: ${response.body} $latDelivery $longDelivery");

        locationSendingDataLoading.value = false;

        toastMsg('Location fetch successfully !!', true);
      } else {
        toastMsg('Failed to update location', false);
      }
    } catch (e) {
      print("Error: $e");
      toastMsg('An error occurred while updating location', false);
    } finally {
      locationSendingDataLoading.value = false;
      update();
    }
  }

}

