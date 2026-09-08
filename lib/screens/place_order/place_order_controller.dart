  import 'dart:convert';
  import 'dart:developer';
  import 'package:garu_customer/screens/orders/order_history_screen.dart';
import 'package:http/http.dart' as http;
  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:get/get.dart';
  import 'package:garu_customer/constant/ApiBaseHelper.dart';
  import 'package:garu_customer/constant/api.dart';
  import 'package:garu_customer/main.dart';
  import 'package:garu_customer/screens/constant/validations.dart';
  import 'package:garu_customer/screens/order_confirmed/confirmed_screen.dart';
  import 'package:garu_customer/screens/splash/setting_controller.dart';
  import 'package:razorpay_flutter/razorpay_flutter.dart';
  import '../../Environment/Environment.dart';
  import '../add_to_cart/add_to_cart_screen.dart';
import '../add_to_cart/addto_cart_controller.dart';
import '../bottom_bar/BottomBar.dart';
  
  class PlaceOrderController extends GetxController {
    RxMap<String, dynamic> pendingOrderData = <String, dynamic>{}.obs;
    RxBool isPaymentInProgress = false.obs;
    var placeLoader = false.obs;
    var placeOrderData;
    Map<String, dynamic>? result;
    var PAYMENT_ID;
    Razorpay? _razorpay;
    var completeLoader = false.obs;
    var completeOrderData;

    late AddCartController data;
    late SettingController settingData;

    var razorpayOrderId = ''.obs;
    var totalRazorpayAmount = 0.0.obs;

    // Store place order data for retry
    Map<String, dynamic>? _pendingPlaceOrderData;
    String? _pendingSelectedFilePath;
    double? _pendingAmount;
    String? _pendingProductName;
    String? _pendingProductDescription;

    // Flag to prevent cart clearing during payment initialization
    bool _isPaymentInitMode = false;
  
    @override
    void onInit() {
      super.onInit();

      if (Get.isRegistered<SettingController>()) {
        settingData = Get.find<SettingController>();
      } else {
        settingData = Get.put(SettingController(), permanent: true);
      }

      if (Get.isRegistered<AddCartController>()) {
        data = Get.find<AddCartController>();
      } else {
        data = Get.put(AddCartController());
      }
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    }
  
    @override
    void onClose() {
      _razorpay?.clear();
      super.onClose();
    }
  
    // ==================== METHOD 1: INITIALIZE ONLINE PAYMENT (NO CART CLEAR) ====================
    // Using existing API but with special flag
    Future<void> initializeOnlinePayment({
      required double amount,
      required String productName,
      required String productDescription,
      required String userContact,
      required String userEmail,
      required Uri url,
      required Map<String, String> parameter,
      required String? selectedFilePath,
    }) async {
      placeLoader(true);
      update();

      log("url>>>$url");
      log("parameter>>>$parameter");
      var token = prefs?.getString("token");
      if (token == null || token.isEmpty) {
        toastMsg("Session expired. Please login again.", false);
        placeLoader(false);
        return;
      }
  
      try {
        // Set flag to prevent cart clearing
        _isPaymentInitMode = true;
  
        // Add special parameter to indicate this is just payment initialization
        parameter.addAll({
          'is_payment_init': '1', // Backend ko batayega ki cart clear mat karo
        });
  
        // No file selected
        if (selectedFilePath == null || selectedFilePath.isEmpty) {
          var headers = {
            'x-api-key': 'ZJhxjDlpTeJhiuXeDMDB2aA7zaK75rli',
            'Authorization': 'Bearer $token',
          };
  
          var request = http.MultipartRequest('POST', url);
          request.headers.addAll(headers);
          request.fields.addAll(parameter);
  
          http.StreamedResponse response = await request.send();
          var responseBody = await response.stream.bytesToString();
          var placeOrderData = jsonDecode(responseBody);

          log('status code: ${response.statusCode.toString()}');
          log('Payment Init Response: ${placeOrderData.toString()}');
  
          if (response.statusCode == 200) {
            // Wallet se pura payment ho gaya
            if (placeOrderData['data'] is List) {

              clearPendingPayment();

              Get.offAll(const ConfirmedOrderPage());

              placeLoader(false);
              update();
              return;
            }
            if (placeOrderData['data'] is Map) {
              // ✅ Save order data for retry
              pendingOrderData.value = placeOrderData;
              isPaymentInProgress.value = true;

              totalRazorpayAmount.value = amount;
              razorpayOrderId.value =
                  placeOrderData['data']['order_id']?.toString() ?? '';

              // Store checkout data
              _pendingSelectedFilePath = selectedFilePath;
              _pendingAmount = amount;
              _pendingProductName = productName;
              _pendingProductDescription = productDescription;
  
              String orderId =
                  placeOrderData['data']['order_id']?.toString() ?? '';
  
              if (orderId.isEmpty) {
                toastMsg('Failed to get order ID', false);
                placeLoader(false);
                _isPaymentInitMode = false;
                return;
              }
  
              var razorpayKey = settingData.setting_response['settings']
                      ['razorpay_key']
                  .toString();
  
              // Open Razorpay checkout
              openCheckout(
                amount,
                orderId,
                productName,
                productDescription,
                userContact,
                userEmail,
                razorpayKey,
              );
            }
          } else {
            toastMsg(placeOrderData['message'] ?? 'Payment initialization failed',
                false);
          }
        }
        // With file upload
        else {
          // Check file size
          File file = File(selectedFilePath);
          int fileSizeInBytes = await file.length();
  
          if (fileSizeInBytes > 512 * 1024) {
            toastMsg("File is too large. Max 512 KB", false);
            placeLoader(false);
            _isPaymentInitMode = false;
            return;
          }
  
          var headers = {
            'x-api-key': 'ZJhxjDlpTeJhiuXeDMDB2aA7zaK75rli',
            'Authorization': 'Bearer $token',
          };
  
          var request = http.MultipartRequest('POST', url);
          request.headers.addAll(headers);
          request.fields.addAll(parameter);
          request.files.add(await http.MultipartFile.fromPath(
              'prescription_attachment', selectedFilePath));
  
          http.StreamedResponse response = await request.send();
          var responseBody = await response.stream.bytesToString();
          var placeOrderData = jsonDecode(responseBody);
  
          log('Payment Init With File Response: $placeOrderData');
  
          if (response.statusCode == 200) {
            if (placeOrderData['data'] is Map) {
              pendingOrderData.value = placeOrderData;
              isPaymentInProgress.value = true;
  
              totalRazorpayAmount.value = amount;
              razorpayOrderId.value =
                  placeOrderData['data']['order_id']?.toString() ?? '';
  
              _pendingSelectedFilePath = selectedFilePath;
              _pendingAmount = amount;
              _pendingProductName = productName;
              _pendingProductDescription = productDescription;
  
              String orderId =
                  placeOrderData['data']['order_id']?.toString() ?? '';
  
              if (orderId.isEmpty) {
                toastMsg('Failed to get order ID', false);
                placeLoader(false);
                _isPaymentInitMode = false;
                return;
              }
  
              var razorpayKey = settingData.setting_response['settings']
                      ['razorpay_key']
                  .toString();
  
              openCheckout(
                amount,
                orderId,
                productName,
                productDescription,
                userContact,
                userEmail,
                razorpayKey,
              );
            }
          } else {
            toastMsg(placeOrderData['message'] ?? 'Payment initialization failed',
                false);
          }
        }
  
        placeLoader(false);
        _isPaymentInitMode = false;
        update();
      } catch (e) {
        log('Payment initialization error: $e');
        toastMsg('Payment initialization failed', false);
        placeLoader(false);
        _isPaymentInitMode = false;
        update();
      }
    }
  
    // ==================== METHOD 2: PLACE ORDER AFTER PAYMENT SUCCESS ====================
    Future<void> placeOrderAfterPayment({
      required Uri url,
      required Map<String, String> parameter,
      required String? selectedFilePath,
      required String razorpayPaymentId,
      required String razorpayOrderId,
      required String razorpaySignature,
    }) async {
      placeLoader(true);
      update();
  
      var token = prefs?.getString("token");
      if (token == null || token.isEmpty) {
        toastMsg("Session expired. Please login again.", false);
        placeLoader(false);
        return;
      }
  
      try {
        // Add payment details to parameters
        parameter.addAll({
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_order_id': razorpayOrderId,
          'razorpay_signature': razorpaySignature,
          'is_payment_complete': '1', // Backend ab cart clear kar sakta hai
        });
  
        // Remove payment init flag if present
        parameter.remove('is_payment_init');
  
        // No file selected
        if (selectedFilePath == null || selectedFilePath.isEmpty) {
          var headers = {
            'x-api-key': 'ZJhxjDlpTeJhiuXeDMDB2aA7zaK75rli',
            'Authorization': 'Bearer $token',
          };
  
          var request = http.MultipartRequest('POST', url);
          request.headers.addAll(headers);
          request.fields.addAll(parameter);
  
          http.StreamedResponse response = await request.send();
          var responseBody = await response.stream.bytesToString();
          var placeOrderData = jsonDecode(responseBody);
  
          log('Place Order After Payment Response: ${placeOrderData.toString()}');
  
          if (response.statusCode == 200) {
            clearPendingPayment();
            Get.offAll(const ConfirmedOrderPage());
          } else if (response.statusCode == 422) {
            toastMsg(placeOrderData['message'] ?? "Order failed", false);
          } else {
            log("Failed response: ${responseBody}");
            toastMsg("Order failed. Please contact support.", false);
          }
        }
        // With file upload
        else {
          File file = File(selectedFilePath);
          int fileSizeInBytes = await file.length();
  
          if (fileSizeInBytes > 512 * 1024) {
            toastMsg("File is too large. Max 512 KB", false);
            placeLoader(false);
            return;
          }
  
          var headers = {
            'x-api-key': 'ZJhxjDlpTeJhiuXeDMDB2aA7zaK75rli',
            'Authorization': 'Bearer $token',
          };
  
          var request = http.MultipartRequest('POST', url);
          request.headers.addAll(headers);
          request.fields.addAll(parameter);
          request.files.add(await http.MultipartFile.fromPath(
              'prescription_attachment', selectedFilePath));
  
          http.StreamedResponse response = await request.send();
          var responseBody = await response.stream.bytesToString();
          var placeOrderData = jsonDecode(responseBody);
  
          log('Place Order With File Response: $placeOrderData');
  
          if (response.statusCode == 200) {
            Get.offAll(const ConfirmedOrderPage());
          } else if (response.statusCode == 422) {
            toastMsg(placeOrderData['message'] ?? "Order failed", false);
          } else {
            log("Failed response: ${responseBody}");
            toastMsg("Order failed. Please try again.", false);
          }
        }
      } catch (e) {
        log('Error during place order after payment: $e');
        toastMsg('Order failed. Please try again.', false);
      } finally {
        placeLoader(false);
        update();
        refresh();
      }
    }
  
    // ==================== METHOD 3: PLACE ORDER FOR COD ====================
    Future<void> placeOrderForCOD(
      Uri url,
      Map<String, String> parameter,
      String? selectedFilePath,
    ) async {
      placeLoader(true);
      update();
  
      var token = prefs?.getString("token");
      if (token == null || token.isEmpty) {
        toastMsg("Session expired. Please login again.", false);
        placeLoader(false);
        return;
      }
  
      try {
        // No file selected
        if (selectedFilePath == null || selectedFilePath.isEmpty) {
          var headers = {
            'x-api-key': 'ZJhxjDlpTeJhiuXeDMDB2aA7zaK75rli',
            'Authorization': 'Bearer $token',
          };
  
          var request = http.MultipartRequest('POST', url);
          request.headers.addAll(headers);
          request.fields.addAll(parameter);
  
          http.StreamedResponse response = await request.send();
          var responseBody = await response.stream.bytesToString();
          var placeOrderData = jsonDecode(responseBody);
          log("url>>>$url");
          log("parameter>>>$parameter");
          log('COD Order Response: ${placeOrderData.toString()}');
  
          if (response.statusCode == 200) {
            Get.offAll(const ConfirmedOrderPage());
          } else if (response.statusCode == 422) {
            toastMsg(
                placeOrderData['message'] ??
                    "Your wallet balance is insufficient.",
                false);
          } else {
            log("Failed response: ${responseBody}");
            toastMsg("Order failed. Please try again.", false);
          }
        }
        // With file upload
        else {
          File file = File(selectedFilePath);
          int fileSizeInBytes = await file.length();
  
          if (fileSizeInBytes > 512 * 1024) {
            toastMsg("File is too large. Max 512 KB", false);
            placeLoader(false);
            return;
          }
  
          var headers = {
            'x-api-key': 'ZJhxjDlpTeJhiuXeDMDB2aA7zaK75rli',
            'Authorization': 'Bearer $token',
          };
  
          var request = http.MultipartRequest('POST', url);
          request.headers.addAll(headers);
          request.fields.addAll(parameter);
          request.files.add(await http.MultipartFile.fromPath(
              'prescription_attachment', selectedFilePath));
  
          http.StreamedResponse response = await request.send();
          var responseBody = await response.stream.bytesToString();
          var placeOrderData = jsonDecode(responseBody);
  
          log('COD Order With File Response: $placeOrderData');
  
          if (response.statusCode == 200) {
            Get.offAll(const ConfirmedOrderPage());
          } else if (response.statusCode == 422) {
            toastMsg(placeOrderData['message'] ?? "Order failed", false);
          } else {
            log("Failed response: ${responseBody}");
            toastMsg("Order failed. Please try again.", false);
          }
        }
      } catch (e) {
        log('Error during COD order: $e');
        toastMsg('Order failed. Please try again.', false);
      } finally {
        placeLoader(false);
        update();
        refresh();
      }
    }
  
    // ==================== OPEN RAZORPAY CHECKOUT ====================
    void openCheckout(
      double amt,
      String orderId,
      String productName,
      String productDescription,
      String userContact,
      String userEmail,
      String key,
    ) async {
      var options = {
        'key': key,
        'amount': (amt * 100).toInt(),
        'order_id': orderId.toString(),
        'name': 'Garu',
        'description': productDescription,
        'prefill': {'contact': userContact, 'email': userEmail},
        'retry': {'enabled': true},
        'remember_customer': true,
      };
  
      log("Razorpay options: ${options.toString()}");
  
      try {
        _razorpay!.open(options);
      } catch (e) {
        debugPrint('Error opening Razorpay: $e');
        toastMsg('Failed to open payment gateway', false);
      }
    }
  
    // ==================== HANDLE PAYMENT SUCCESS ====================
    void handlePaymentSuccess(PaymentSuccessResponse response) {
  
      var completeBody = jsonEncode({
        'razorpay_order_id': response.orderId.toString(),
        'razorpay_payment_id': response.paymentId.toString(),
        'razorpay_signature': response.signature.toString(),
      });
  
      CompleteOrderApi(
        Uri.parse(complete_payment_url),
        completeBody,
      );
    }
  
    Future<void> cancelPaymentApi(String orderId) async {
      try {
        var token = prefs?.getString("token");

        if (token == null || token.isEmpty) {
          log("Token is null");
          return;
        }
        var headers = {
          'x-api-key': 'ZJhxjDlpTeJhiuXeDMDB2aA7zaK75rli',
          'Authorization': 'Bearer $token',
        };
  
        var url = Uri.parse(cancel_payment_url);
        log('cancel url>>$url');
  
        var request = http.MultipartRequest('POST', url);
        request.headers.addAll(headers);
  
        request.fields.addAll({
          'razorpay_payment_Id': orderId.toString(),
        });
        print("cancel order id>>> ${orderId.toString()}");
  
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
  
        log("Cancel Payment Response: $responseBody");
        if (response.statusCode == 200) {
          Get.offNamedUntil(
            '/AddToCartPage',
                (route) => route.settings.name == '/BottomBar',
          );
        }

      } catch (e) {
        log("Cancel Payment Error: $e");
      }
    }
  
    // ==================== HANDLE PAYMENT ERROR ====================

    void handlePaymentError(PaymentFailureResponse response) {
      log("Payment Error Code: ${response.code}");
      log("Payment Error Msg: ${response.message}");

      final orderId = razorpayOrderId.value;

      if (orderId.isEmpty) {
        log("OrderId empty - skip cancel API");
        return;
      }

      Fluttertoast.showToast(
        msg: response.code == 0
            ? "Payment cancelled."
            : "Payment Failed: ${response.message}",
        backgroundColor: response.code == 0 ? Colors.orange : Colors.red,
        textColor: Colors.white,
      );

      log("payment fail>>>orderlistScreen");
      Get.offAll(OrderHistory());
      // cancelPaymentApi(orderId);

      // VERY IMPORTANT
      razorpayOrderId.value = '';   // reset after calling cancel
      isPaymentInProgress.value = false;
    }
  
    // ==================== HANDLE EXTERNAL WALLET ====================
    void handleExternalWallet(ExternalWalletResponse response) {
      Fluttertoast.showToast(
        msg: "External Wallet: " + response.walletName.toString(),
        gravity: ToastGravity.BOTTOM,
      );
    }
  
    // ==================== COMPLETE ORDER API ====================
    CompleteOrderApi(Uri completeUrl, String parameter) async {
      completeLoader(true);
      update();
  
      try {
        var response =
            await ApiBaseHelper().postAPICall(completeUrl, parameter, true);
  
        if (response.statusCode == 200) {
          clearPendingPayment();
          completeOrderData = jsonDecode(response.body);
          completeLoader(false);
          Get.offAll(const ConfirmedOrderPage());
        } else {
          completeOrderData = jsonDecode(response.body);
          toastMsg(
              completeOrderData['message'] ?? 'Order completion failed', false);
          completeLoader(false);
        }
      } catch (e) {
        log('Complete order error: $e');
        toastMsg('Order completion failed', false);
        completeLoader(false);
      } finally {
        update();
        refresh();
      }
    }
  
    // ==================== UTILITY METHODS ====================
    bool hasPendingPayment() {
      return isPaymentInProgress.value && pendingOrderData.isNotEmpty;
    }
  
    void clearPendingPayment() {
      pendingOrderData.clear();
      isPaymentInProgress.value = false;
      razorpayOrderId.value = '';
      totalRazorpayAmount.value = 0.0;
      _pendingPlaceOrderData = null;
      _pendingSelectedFilePath = null;
      _pendingAmount = null;
      _pendingProductName = null;
      _pendingProductDescription = null;
      _isPaymentInitMode = false;
  
      // Clear prefs
      prefs?.remove('checkout_address_id');
      prefs?.remove('checkout_comment');
      prefs?.remove('checkout_wallet_status');
    }
  
    // Store checkout data before payment
    void storeCheckoutData({
      required String addressId,
      required String comment,
      required String walletStatus,
      String? selectedFilePath,
    }) {
      prefs?.setString('checkout_address_id', addressId);
      prefs?.setString('checkout_comment', comment);
      prefs?.setString('checkout_wallet_status', walletStatus);
      _pendingSelectedFilePath = selectedFilePath;
    }
  
    // ==================== DEPRECATED ====================
    @Deprecated('Use initializeOnlinePayment + placeOrderAfterPayment instead')
    Future<void> PlaceOrderApi(
      Uri url,
      Map<String, String> parameter,
      double amount,
      String productName,
      String productDescription,
      String paymentMode,
      String? selectedFilePath,
    ) async {
      toastMsg('This method is deprecated', false);
      return;
    }
  }
  

