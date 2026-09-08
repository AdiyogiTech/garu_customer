import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Constant/ApiBaseHelper.dart';
import '../../Environment/Environment.dart';

class ReturnResponseController extends GetxController {
  // Initialize with proper types
  final isLoading = false.obs;
  final returnRequestData = <dynamic>[].obs; // Explicitly typed as List
  final errorMessage = ''.obs;

  final ApiBaseHelper _apiHelper = ApiBaseHelper();

  @override
  void onInit() {
    super.onInit();
    // Clear any existing data on init
    returnRequestData.clear();
  }

  Future<void> fetchReturnRequests() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      String? baseUrl = Environment.apibaseurl;
      String url = '${baseUrl}return-requests';

      Uri uri = Uri.parse(url);

      print('Fetching return requests from: $url');

      final response = await _apiHelper.getAPICall(uri, true);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('API Response: $jsonResponse');

        if (jsonResponse['status'] == true) {
          // Clear existing data
          returnRequestData.clear();

          // Add new data
          if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
            returnRequestData.addAll(List.from(jsonResponse['data']));
            print('Return request fetched successfully: ${returnRequestData.length} items');
          } else {
            print('Data is not a list or is null');
          }
        } else {
          errorMessage.value = jsonResponse['message'] ?? 'Something went wrong';
        }
      } else {
        errorMessage.value = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
      print('Error fetching return requests: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get full attachment URL
  String getFullAttachmentUrl(String? attachmentPath) {
    if (attachmentPath == null || attachmentPath.isEmpty) return '';
    // If it's already a full URL, return as is
    if (attachmentPath.startsWith('http')) return attachmentPath;
    // Otherwise, prepend base URL
    return '${Environment.apibaseurl}$attachmentPath';
  }
}