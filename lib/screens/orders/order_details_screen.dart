  import 'dart:async';
  import 'dart:convert';
  import 'dart:developer';
  import 'dart:io';
  import 'package:dio/dio.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:garu_customer/screens/place_order/place_order_controller.dart';
  import 'package:geolocator/geolocator.dart';
  import 'package:get/get.dart';
  import 'package:here_sdk/core.dart';
  import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
  import 'package:garu_customer/constant/api.dart';
  import 'package:garu_customer/helper_widget/ReviewField.dart';
  import 'package:garu_customer/helper_widget/appbar_helper.dart';
  import 'package:garu_customer/helper_widget/location_label.dart';
  import 'package:garu_customer/helper_widget/sized_box.dart';
  import 'package:garu_customer/screens/constant/colors.dart';
  import 'package:garu_customer/screens/return_product/return_product_screen.dart';
  import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
  import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
  import '../../main.dart';
  import '../constant/validations.dart';
  import '../here_map/locationScreen.dart';
  import '../here_map/location_controller.dart';
  import 'order_controller.dart';
  import 'package:path/path.dart';
  import 'package:http/http.dart' as http;
  import 'order_tracking_screen.dart'; // Import the tracking screen
  
  class OrderDetailsPage extends StatefulWidget {
    const OrderDetailsPage({super.key});
  
    @override
    State<OrderDetailsPage> createState() => _OrderDetailsPageState();
  }
  
  class _OrderDetailsPageState extends State<OrderDetailsPage> {
    late Razorpay _razorpay;

    OrderController orderListController = Get.put(OrderController());
    PlaceOrderController placeOrderController = Get.put(PlaceOrderController());
  
    late Position position;
  
    LocationController locationController = Get.put(LocationController());
  
    ///download file
    Dio dio = Dio();
    bool isDownloading = false;
    String? token;
  
    @override
    void initState() {
      super.initState();
      _razorpay = Razorpay();

      _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        _handlePaymentSuccess,
      );

      _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR,
        _handlePaymentError,
      );

      _razorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        _handleExternalWallet,
      );

      getDetailsData();
      // fetchCustomerLocation();
      getToken();
      // Timer(
      //   const Duration(seconds: 4),
      //   () => locationController.locationApiCalling(
      //       id: orderListController.OrderDetailsData[0]['delivery_boy_id']),
      // );
      loadOrderDetails();
    }

    @override
    void dispose() {
      _razorpay.clear();
      super.dispose();
    }

    Future<void> retryPayment() async {
      try {
        if (orderListController.OrderDetailsData.isEmpty) {
          toastMsg("Order details not available", false);
          return;
        }

        final orderData =
        orderListController.OrderDetailsData[0];

        // Razorpay Key from SharedPreferences
        final razorpayKey =
        prefs?.getString("razorpay_key")?.trim();

        if (razorpayKey == null || razorpayKey.isEmpty) {
          toastMsg("Razorpay key not found", false);
          return;
        }

        // Razorpay Order ID
        final razorpayOrderId =
        orderData['razorpay_payment_Id']?.toString();

        if (razorpayOrderId == null ||
            razorpayOrderId.isEmpty ||
            razorpayOrderId == 'null') {
          toastMsg("Razorpay order ID not found", false);
          return;
        }

        // Amount
        final amountString =
        orderData['to_pay_amount']?.toString();

        final amount =
            double.tryParse(amountString ?? '0') ?? 0;

        if (amount <= 0) {
          toastMsg("Invalid payment amount", false);
          return;
        }

        final options = {
          'key': razorpayKey,

          // Razorpay amount is always in paise
          'amount': (amount * 100).round(),

          'name': 'Garu',
          'description': 'Retry payment for order',

          'order_id': razorpayOrderId,

          'prefill': {
            'name':
            orderData['customer_name']?.toString() ?? '',
            'email':
            orderData['customer_email']?.toString() ?? '',
            'contact':
            orderData['customer_mobile']?.toString() ?? '',
          },

        };

        log("Razorpay Options: $options");

        _razorpay.open(options);
      } catch (e) {
        log("Retry Razorpay Error: $e");
        toastMsg("Unable to open payment", false);
      }
    }

    void _handlePaymentSuccess(
        PaymentSuccessResponse response) {

      log("Payment Success");
      log("Payment ID: ${response.paymentId}");
      log("Order ID: ${response.orderId}");
      log("Signature: ${response.signature}");


      placeOrderController.CompleteOrderApi(
        Uri.parse(complete_payment_url),
        jsonEncode({
          'razorpay_order_id': response.orderId.toString(),
          'razorpay_payment_id': response.paymentId.toString(),
          'razorpay_signature': response.signature.toString(),
        }),
      );

     /* completePayment(
        paymentId: response.paymentId ?? '',
        orderId: response.orderId ?? '',
        signature: response.signature ?? '',
      );*/
    }

    void _handlePaymentError(
        PaymentFailureResponse response) {

      log("Payment Failed");
      log("Code: ${response.code}");
      log("Message: ${response.message}");

      toastMsg(
        response.message ?? "Payment failed",
        false,
      );
    }

    void _handleExternalWallet(
        ExternalWalletResponse response) {

      log("External Wallet: ${response.walletName}");
    }

    

    Future<void> loadOrderDetails() async {
      await getDetailsData();
  
      if (orderListController.OrderDetailsData.isNotEmpty &&
          orderListController.OrderDetailsData[0]['delivery_boy_id'] != null) {
        Timer(
          const Duration(seconds: 2),
              () => locationController.locationApiCalling(
            id: orderListController.OrderDetailsData[0]['delivery_boy_id'],
          ),
        );
      }
    }
  
    getToken() {
      token = prefs!.getString("token").toString();
    }
  
    fetchCustomerLocation() async {
      bool serviceEnabled;
      LocationPermission permission;
  
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        toastMsg('Location services are disabled.', false);
        return;
      }
  
      // Check for permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          toastMsg('Location permission denied.', true);
          return;
        }
      }
  
      if (permission == LocationPermission.deniedForever) {
        log('Location permissions are permanently denied. We cannot request permissions.');
        return;
      }
  
      // Fetch location
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      log('Latitude and Longitude: ${position.latitude}, ${position.longitude}');
    }
  
    ///
    getDetailsData() async {
      await orderListController.OrderDetailsApiCalling(
          orderListController.OrderId.value);
    }
  
    @override
    Widget build(BuildContext context) {

      Future<void> downloadFile(String url) async {
        try {
          setState(() {
            isDownloading = true;
          });
          String fileName = url.split('/').last;

          // Step 1: temp download
          final tempDir = Directory.systemTemp;
          String tempPath = "${tempDir.path}/$fileName";

          await Dio().download(url, tempPath);

          // Step 2: save to Downloads
          await MediaStore().saveFile(
            tempFilePath: tempPath,
            dirType: DirType.download,
            dirName:DirName.download, // optional folder inside Downloads
          );
          setState(() {
            isDownloading = false;
          });

          toastMsg("Download Completed", true);
          print("✅ File saved in Downloads");

        } catch (e) {
          setState(() {
            isDownloading = false;
          });
          toastMsg("Download Failed", false);
          print("❌ Error: $e");
        }
      }

      var size = MediaQuery.of(context).size;
      var width = size.width;
      var height = size.height;
  
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: HelperAppBar(
          title: 'Order Detail',
          displaySearch: false,
          displayCart: false,
        ),
        body: GetBuilder<OrderController>(builder: (orderListController) {
          if (orderListController.OrderDetailsDataLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (orderListController.OrderDetailsData.isEmpty) {
            return const Center(child: Text('Orders details not available..!!'));
          } else {
            log('orders detail here : ${orderListController.OrderDetailsData[0]['order_status_id']}');
            final products =
            orderListController.OrderDetailsData[0]['order_products'];
  
            // Check if waybill exists and is not null/empty
            String? waybill = orderListController.OrderDetailsData[0]['waybill'];
            bool hasWaybill = waybill != null && waybill.isNotEmpty && waybill != 'null';
  
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // const LocationLabel(),
  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Shipping Address Section
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: height * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: primarylogin,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Shipping Info",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),

                                Spacer(),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColorId(orderListController
                                        .OrderDetailsData[0]['order_status_id'].toString()).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    getPaymentStatusId2(orderListController
                                        .OrderDetailsData[0]['order_status_id'].toString()),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: getStatusColorId(orderListController
                                          .OrderDetailsData[0]['order_status_id'].toString()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                       /* // Address Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primarylogin.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: primarylogin,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${orderListController.OrderDetailsData[0]['shipping_address_1'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_address_2'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_city'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_state'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_country'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_postcode'].toString()}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/

                        // Customer Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${orderListController.OrderDetailsData[0]['shipping_address_1'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_address_2'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_city'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_state'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_country'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_postcode'].toString()}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[700],
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Customer Details
                              _buildInfoRow(
                                icon: Icons.person_outline,
                                label: orderListController.OrderDetailsData[0]['customer_name'].toString(),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.receipt_outlined,
                                label: orderListController.OrderDetailsData[0]['order_no'].toString(),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.email_outlined,
                                label: orderListController.OrderDetailsData[0]['customer_email'].toString(),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.phone_outlined,
                                label: orderListController.OrderDetailsData[0]['customer_mobile'].toString(),
                              ),
  
                              // Show waybill if exists
                              if (hasWaybill) ...[
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  icon: Icons.receipt,
                                  label: 'Waybill: $waybill',
                                ),
                              ],
                            ],
                          ),
                        ),
  
                        const SizedBox(height: 15),
  
                        // Order Products Section
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: primarylogin,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Order Items",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
  
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderListController
                              .OrderDetailsData[0]['order_products'].length,
                          itemBuilder: (context, index) {
                            log('here needed : ${orderListController.OrderDetailsData[0]['order_products'][index]['show_return']}');
  
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Product Image
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            orderListController
                                                .OrderDetailsData[0]
                                            ['order_products'][index]
                                            ['main_image']
                                                .toString(),
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey[400],
                                                size: 30,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
  
                                      // Product Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: size.width*0.5,
                                              child: Text(
                                                orderListController
                                                    .OrderDetailsData[0]
                                                ['order_products'][index]
                                                ['product_name']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: Colors.grey[900]),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              orderListController
                                                  .OrderDetailsData[0]
                                              ['order_products'][index]
                                              ['attribute_name']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11,
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
  
                                      // Price
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₹${orderListController.OrderDetailsData[0]['order_products'][index]['unit_price'].toString()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                color: primarylogin),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Qty: ${orderListController.OrderDetailsData[0]['order_products'][index]['quantity'].toString()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

  
                                  // Action Buttons Row
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ///Review
                                        if (orderListController.OrderDetailsData[0]
                                        ['order_status_id'] == 4)
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(25),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 6),
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return _showproductReviewDialog(
                                                    context,
                                                    orderListController,
                                                    orderListController
                                                        .OrderDetailsData[0]['order_products'][index]['id']
                                                        .toString(),
                                                    orderListController
                                                        .OrderDetailsData[0]['order_products'][index]['vendor_order_id']
                                                        .toString(),
                                                    orderListController
                                                        .OrderDetailsData[0]['main_order_id']
                                                        .toString(),
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text(
                                              'Write Review',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),

                                        const SizedBox(width: 8),

                                        orderListController.OrderDetailsData[0]['order_status_id'] == 4 &&
                                            orderListController.OrderDetailsData[0]['invoice'] != null
                                            ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primarylogin,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 6),
                                            elevation: 0,
                                          ),
                                          onPressed: () {
                                            downloadFile(
                                              orderListController.OrderDetailsData[0]['invoice_url']
                                                  .toString(),
                                            );
                                          },
                                          child: isDownloading
                                              ? const Text(
                                            'Downloading...',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                              : const Text(
                                            'Invoice',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
  
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: primarylogin,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Payment Info",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                color: orderListController
                                    .OrderDetailsData[0]['orders_payment_status'] == 1
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                getPaidStatusId(orderListController
                                    .OrderDetailsData[0]['orders_payment_status']
                                    .toString()),
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Order Information Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Payment Method
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Mode',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primarylogin.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      getPaymentStatusId(orderListController
                                          .OrderDetailsData[0]['payment_type']
                                          .toString()),
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: primarylogin),
                                    ),
                                  ),
                                ],
                              ),
                              if(orderListController.OrderDetailsData[0]['razorpay_payment_Id']!=null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: _buildPriceRow('Payment ID', '${orderListController.OrderDetailsData[0]['razorpay_payment_Id'].toString()}'),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: _buildPriceRow('Payable Amount', '₹${orderListController.OrderDetailsData[0]['to_pay_amount'].toString()}',
                                isTotal: true),
                              ),

                              // const SizedBox(height: 20),

                           /*   // Vendor Details
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: primarylogin,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Vendor Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              orderListController.OrderDetailsData[0]
                              ['vendor_name'] ==
                                  null
                                  ? Text(
                                'NA',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              )
                                  : Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    icon: Icons.person_outline,
                                    label: orderListController.OrderDetailsData[0]['vendor_name'].toString(),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    icon: Icons.email_outlined,
                                    label: orderListController.OrderDetailsData[0]['vendor_email'].toString(),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    icon: Icons.phone_outlined,
                                    label: orderListController.OrderDetailsData[0]['vendor_mobile'].toString(),
                                  ),
                                ],
                              ),*/
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: primarylogin,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Order Summary",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),

                          ],
                        ),
                        const SizedBox(height: 12),
                        // Order Information Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Price Breakdown
                              _buildPriceRow('Subtotal', '₹${orderListController.OrderDetailsData[0]['subtotal'].toString()}'),
                              const SizedBox(height: 8),
                              _buildPriceRow('Tax', '₹${orderListController.OrderDetailsData[0]['tax'].toString()}'),
                              const SizedBox(height: 8),
                              _buildPriceRow('Shipping Charge', '₹${orderListController.OrderDetailsData[0]['shipping'].toString()}'),
                              const SizedBox(height: 8),
                              _buildPriceRow('Discount', '- ₹${orderListController.OrderDetailsData[0]['discount'].toString()}'),
                              const SizedBox(height: 8),
                              _buildPriceRow('Shipping Discount', '- ₹${orderListController.OrderDetailsData[0]['shipping_discount'].toString()}'),
                              const SizedBox(height: 8),
                              _buildPriceRow('Total', '₹${orderListController.OrderDetailsData[0]['total'].toString()}'),
                              if(orderListController.OrderDetailsData[0]['wallet_amount'] != 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: _buildPriceRow('Wallet Used', '₹${orderListController.OrderDetailsData[0]['wallet_amount'].toString()}'),
                              ),

                              const Divider(height: 20),
                              _buildPriceRow('Total Payable', '₹${orderListController.OrderDetailsData[0]['to_pay_amount'].toString()}',isTotal: true),

                            ],
                          ),
                        ),


                        // Action Buttons Row
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                             /* if (orderListController.OrderDetailsData[0]
                              ['order_status_id'] == 1 && orderListController.OrderDetailsData[0]
                              ['orders_payment_status'] == 0 && orderListController.OrderDetailsData[0]
                              ['payment_type'] == 2 )
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    elevation: 0,
                                  ),
                                  onPressed: () async {
                                    await retryPayment();
                                  },
                                  child: const Text(
                                    'Retry Payment',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),*/

                              ///cancel
                              if (orderListController.OrderDetailsData[0]
                              ['order_status_id'] ==
                                  1)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    cancelOrder(
                                        context,
                                        orderListController
                                            .OrderDetailsData[0]['id']);
                                  },
                                  child: const Text(
                                    'Cancel Order',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),

                              ///return
                              (products != null &&
                                  products.isNotEmpty &&
                                  products[0]['show_return'] == true)
                                  ? const SizedBox(width: 8)
                                  : Container(),

                              (products != null &&
                                  products.isNotEmpty &&
                                  products[0]['show_return'] == true)
                                  ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  var productData = {
                                    'order_no':
                                    orderListController.OrderDetailsData[0]['order_no'].toString(),
                                    'date': orderListController.OrderDetailsData[0]['date'].toString(),
                                    'product_name':
                                    orderListController
                                        .OrderDetailsData[0]
                                    ['order_products']
                                    [0]
                                    ['product_name']
                                        .toString(),
                                    'attribute_name':
                                    orderListController
                                        .OrderDetailsData[0]
                                    ['order_products']
                                    [0]['attribute_name'],
                                    'product_no': orderListController
                                        .OrderDetailsData[
                                    0]['order_products']
                                    [0]['product_no'],
                                    'total_price': orderListController
                                        .OrderDetailsData[
                                    0]['order_products']
                                    [0]['total_price'],
                                    'quantity': orderListController
                                        .OrderDetailsData[
                                    0]['order_products']
                                    [0]['quantity'],
                                    'tax': orderListController
                                        .OrderDetailsData[
                                    0]['order_products']
                                    [0]['tax'],
                                    'main_image': orderListController
                                        .OrderDetailsData[
                                    0]['order_products']
                                    [0]['main_image'],
                                    'vendor_order_id':
                                    orderListController
                                        .OrderDetailsData[0]
                                    ['order_products']
                                    [
                                    0]['vendor_order_id'],
                                    'vendor_product_id':
                                    orderListController
                                        .OrderDetailsData[0]
                                    ['order_products']
                                    [
                                    0]['vendor_product_id'],
                                    'order_product_id':  orderListController
                                        .OrderDetailsData[0]['order_products'][0]['id']
                                        .toString(),
                                    'order_id': orderListController
                                        .OrderDetailsData[0]['id']
                                        .toString(),
                                  };

                                  print('orderId>>>${ orderListController
                                      .OrderDetailsData[0]['id']
                                      .toString()},orderProductId>>>${orderListController
                                      .OrderDetailsData[0]['order_products'][0]['id']
                                      .toString()}');
                                  Get.to(() => ReturnProduct(
                                      productData: productData));
                                },
                                child: const Text(
                                  'Return',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                        ),


                        // Order History Section
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: primarylogin,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Order History",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
  
                              Spacer(),
                              /// Track Order Button - Only shows when waybill exists
                              if (hasWaybill)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    // Navigate to tracking screen with waybill
                                    Get.to(() => OrderTrackingScreen(
                                      initialWaybill: waybill,
                                    ));
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.local_shipping, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Track Order',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
  
                              if (hasWaybill) const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
  
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timeline Dots
                              Column(
                                children: List.generate(
                                  orderListController
                                      .OrderDetailsData[0]['order_history']
                                      .length,
                                      (index) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffb5e550),
                                          ),
                                        ),
                                        if (index <
                                            orderListController
                                                .OrderDetailsData[0]
                                            ['order_history']
                                                .length -
                                                1)
                                          Container(
                                            height: 50,
                                            width: 2,
                                            color: const Color(0xffb5e550),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
  
                              // History Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    orderListController
                                        .OrderDetailsData[0]['order_history']
                                        .length,
                                        (index) {
                                      final orderHistory =
                                      orderListController.OrderDetailsData[0]
                                      ['order_history'][index];
  
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: index <
                                                orderListController
                                                    .OrderDetailsData[0]
                                                ['order_history']
                                                    .length -
                                                    1
                                                ? 20
                                                : 0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              orderHistory['comment']
                                                  .toString() ??
                                                  'NA',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${DateFormat('d MMM, yyyy | hh:mm a').format(DateTime.parse(orderHistory['created_at'].toString()).toLocal())}",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
  
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
  
                  ///working here
                  ///if order_status_id == 2 and delivery_assign_by == 1 and is_global == 0 <or>  order_status_id == 3 and is_global == 0
  
                  orderListController.OrderDetailsData[0]["order_status_id"] ==
                      3 &&
                      orderListController.OrderDetailsData[0]["is_global"] ==
                          0
                      ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        double vendorLat = double.parse(orderListController
                            .OrderDetailsData[0]['vendors_latitude']);
                        double vendorLong = double.parse(orderListController
                            .OrderDetailsData[0]['vendors_longitude']);
  
                        double shippingLat = double.parse(
                            orderListController.OrderDetailsData[0]
                            ['shipping_latitude']);
                        double shippingLong = double.parse(
                            orderListController.OrderDetailsData[0]
                            ['shipping_longitude']);
  
                        GeoCoordinates customerLocation =
                        GeoCoordinates(shippingLat, shippingLong);
                        GeoCoordinates vendorLocation =
                        GeoCoordinates(vendorLat, vendorLong);
  
                        log('id here ${orderListController.OrderDetailsData[0]}');
  
                        double deliveryLat = double.parse(locationController
                            .latDelivery.value
                            .toString());
                        double deliveryLong = double.parse(
                            locationController.longDelivery.value
                                .toString());
  
                        log('delivery lat long $deliveryLat');
                        log('delivery lat long $deliveryLong');
  
                        GeoCoordinates deliveryBoyLocation =
                        GeoCoordinates(deliveryLat, deliveryLong);
  
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationTrackerScreen(
                              Start: vendorLocation,
                              end: customerLocation,
                              id: orderListController.OrderDetailsData[0]
                              ['delivery_boy_id'],
                              deliveryBoy: deliveryBoyLocation,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: primarylogin,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: primarylogin.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                                locationController
                                    .locationSendingDataLoading.value
                                    ? 'Please Wait'
                                    : 'Track Order',
                                style: const TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  )
                      : Container(),
                ],
              ),
            );
          }
        }),
      );
    }
  
    Widget _buildInfoRow({required IconData icon, required String label}) {
      return Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[500],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey[800],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
  
    Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? Colors.grey[900] : Colors.grey[700],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal ? primarylogin : Colors.grey[800],
            ),
          ),
        ],
      );
    }
  
    ///delete order
    Future<void> cancelOrder(BuildContext context, int orderId) async {
      bool confirm = await showCancelDialog(context);
  
      if (!confirm) return;
  
      var headers = {
        'x-api-key': 'ZJhxjDlpTeJhiuXeDMDB2aA7zaK75rli',
        'Authorization': 'Bearer $token'
      };
  
      var request = http.MultipartRequest(
        'DELETE',
        Uri.parse('${baseurl}cancel-order/$orderId'),
      );
  
      request.headers.addAll(headers);
  
      try {
        http.StreamedResponse response = await request.send();
        String responseBody = await response.stream.bytesToString();
  
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(responseBody);
          String message =
              jsonResponse['data']['message'] ?? "Order cancelled successfully";
          log('------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $jsonResponse');
          toastMsg(message, true);
          Get.back(result: true);
          // setState(() {
          //   orderListController.orderListPaginationSearch('');
          //   Get.back();
          // });
        } else {
          toastMsg(
              "Error ${response.reasonPhrase ?? 'Failed to cancel order'}", true);
        }
      } catch (e) {
        toastMsg("Error An error occurred: $e", false);
      }
    }
  
    Future<bool> showCancelDialog(BuildContext context) async {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "Cancel Order",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: const Text(
              "Are you sure you want to cancel this order?",
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes"),
              ),
            ],
          );
        },
      ) ??
          false;
    }
  
    ///for payments status....
    String getPaymentStatusId(String fullDay) {
      Map<String, String> dayMapping = {
        '1': 'Cash on delivery',
        '2': 'Online payment',
      };
      return dayMapping[fullDay] ?? fullDay;
    }
  
    String getPaidStatusId(String fullDay) {
      Map<String, String> dayMapping = {
        '1': 'Paid',
        '0': 'Unpaid',
      };
      return dayMapping[fullDay] ?? fullDay;
    }
  
    ///for payments status....
    String getPaymentStatusId2(String fullDay) {
      Map<String, String> dayMapping = {
        '1': 'Order Placed',
        '2': 'Order Confirmed',
        '3': 'Order Dispatched',
        '4': 'Delivered',
        '5': 'Cancelled',
      };
      return dayMapping[fullDay] ?? fullDay;
    }
  
    Color getStatusColorId(String fullDay) {
      Map<String, Color> dayMapping = {
        '1': Colors.orange,
        '2': Colors.green,
        '3': Colors.blue,
        '4': Colors.green,
        '5': Colors.red,
      };
  
      return dayMapping[fullDay] ?? Colors.grey;
    }
  
    Widget _showproductReviewDialog(
        BuildContext context,
        OrderController orderListController,
        String order_product_id,
        String vendor_order_id,
        String order_id) {
      int _rating = 0;
      TextEditingController _commentController = TextEditingController();
  
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primarylogin.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rate,
                color: primarylogin,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Write a Review',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: StatefulBuilder(builder: (context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rate this product:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1;
                        print('inside Rating updated to rtaing: $_rating');
                        print('inside review  updated index: $index');
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        _rating > index ? Icons.star : Icons.star_border,
                        color: primarylogin,
                        size: 28,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              ReviewField(
                hintText: 'Share your experience...',
                validator: Validations.validateComment,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]"))
                ],
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                controller: _commentController,
              ),
            ],
          );
        }),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarylogin,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    String comment = _commentController.text;
                    var reviewProduct_Url = Uri.parse(reviewProduct_url);
                    final ReviewBody = jsonEncode({
                      'order_product_id': order_product_id,
                      'vendor_order_id': vendor_order_id,
                      'order_id': order_id,
                      'rating': _rating,
                      'comment': comment
                    });
  
                    print('inside reviewbody $ReviewBody');
                    orderListController.ReviewApi(
                        reviewProduct_Url, ReviewBody);
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }