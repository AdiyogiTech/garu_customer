import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/screens/add_to_cart/addto_cart_controller.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/place_order/place_order_screen.dart';
import '../../Environment/Environment.dart';
import '../../constant/api.dart';
import '../address/address_screen.dart';

class CheckoutController extends GetxController {
  var checkouttLoader = false.obs;
  final cartController = Get.put(AddCartController());
  var verifyErrorMsg = ''.obs;
  var canProceed = true.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var selectedFile = Rxn<File>();
  var selectedFileType = ''.obs;

  // Method to select a file (PDF or Image)
  Future<void> selectFile() async {
    // Show file picker dialog
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],  // Allow images and PDF
    );

    if (result != null) {
      // If a file was selected, store it in selectedFile
      selectedFile.value = File(result.files.single.path!);

      // Handle file type based on extension or MIME type
      String filePath = selectedFile.value!.path;
      String fileExtension = filePath.split('.').last.toLowerCase();  // Get the file extension

      if (fileExtension == 'pdf') {
        selectedFileType.value = 'PDF';  // Set file type as PDF
      } else if (['png', 'jpg', 'jpeg', 'png'].contains(fileExtension)) {
        selectedFileType.value = 'Image';  // Set file type as Image
      } else {
        toastMsg('Unsupported File !!', true);
        toastMsg('Please Select Image or PDF File!!', true);
        selectedFileType.value = 'Unknown';  // If file type is unsupported
      }

      print("Selected file: ${selectedFile.value?.path}");
      print("File Type: ${selectedFileType.value}");
    } else {
      print("No file selected");
    }
  }

  Future<bool> verifyCartAddress(String addressId) async {
    try {
      var url = Uri.parse(verifyCartAddressUrl);

      var body = jsonEncode({
        "session_id": Environment.deviceid.toString(),
        "address_id": addressId
      });

      var response = await ApiBaseHelper().postAPICall(url, body, true);
      var decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['status'] == true) {
        verifyErrorMsg.value = '';
        canProceed.value = true;
        return true;
      } else {
        verifyErrorMsg.value =
            decoded['message'] ?? 'Address verification failed';
        canProceed.value = false;
        return false;
      }
    } catch (e) {
      verifyErrorMsg.value = 'Something went wrong';
      canProceed.value = false;
      return false;
    }
  }


  CheckOutApi(url, parameter, String walletStatus, String addressId,
      String paymentmode, String comment,) async {
    checkouttLoader(true);
    update();
    try {
      print("checkout url>>>> $url");
      var response = await ApiBaseHelper().postAPICall(url, parameter, true);

      var decoded = jsonDecode(response.body);
      log("inside checkoutApi Resoponse ==> $decoded");
      if (response.statusCode == 200) {
        print('inside add to cart api  200');

        if (cartController.showUploadPrompt.value == true) {
          if (selectedFile.value == null) {
            toastMsg('Please select a file !!', true);
            return;
          }
        }

        Get.to(() => PlaceOrderPage(
          shipping: (decoded['data']['shipping'] as num).toDouble(),
          shippingDiscount: (decoded['data']['shipping_discount'] as num).toDouble(),
          walletStatus: walletStatus,
          addressId: addressId,
          paymentmode: paymentmode,
          comment: comment,
          canPlaceOrder: decoded['data']['can_place_order'].toString(),
          minCartValue: decoded['data']['min_cart_value'],
          total: decoded['data']['total'],
          subTotal: decoded['data']['subtotal'],
          tax: decoded['data']['tax'],
          discount: decoded['data']['discount'] ,
          warning: List<dynamic>.from(decoded['data']['warning'] ?? []), // ✅ full list
          cartItems: List<dynamic>.from(decoded['data']['items'] ?? []),
          user: decoded['data']['user'],
        ));
        log("checkout itemss>>>>> ${decoded['data']['items'].toList().toString()}");
      }else if (response.statusCode == 404) {
        toastMsg(decoded['message'] ?? 'Please add an address first', true);
        Get.off(() => AddressPage()); // prevents back crash
      }

      else {
        toastMsg('Something went wrong. Please try again.', true);
      }


        checkouttLoader(false);
        update();
        refresh();
    } catch (e) {
      print(' add to cart Catch 1----->>>${e}');
      checkouttLoader(false);
      update();
    }
  }
}
