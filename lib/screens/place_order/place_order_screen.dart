import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/address/address_controller.dart';
import 'package:garu_customer/screens/checkout/checkout_controller.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/style.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/place_order/place_order_controller.dart';
import '../../helper_widget/appbar_helper.dart';
import '../../helper_widget/location_label.dart';
import '../../main.dart';
import '../add_to_cart/addto_cart_controller.dart';
import '../bottom_bar/BottomBar.dart';

class PlaceOrderPage extends StatefulWidget {
  final double shipping;
  final double shippingDiscount;
  final dynamic total;
  final dynamic subTotal;
  final dynamic tax;
  final dynamic discount;
  final String walletStatus;
  final String addressId;
  final String comment;
  final String paymentmode;
  final dynamic minCartValue;
  final String canPlaceOrder;
  final List<dynamic> warning;
  final List cartItems;
  final Map<String, dynamic> user;


  PlaceOrderPage({
    required this.shipping,
    required this.shippingDiscount,
    required this.total,
    required this.subTotal,
    required this.tax,
    required this.discount,
    required this.walletStatus,
    required this.addressId,
    required this.paymentmode,
    required this.comment,
    required this.minCartValue,
    required this.canPlaceOrder,
    required this.warning,
    required this.cartItems,
    required this.user,
  });

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  // AddCartController addCartController = Get.put(AddCartController());
  // CheckoutController checkOutController = Get.put(CheckoutController());
  // PlaceOrderController placeOrderController = Get.put(PlaceOrderController());
  // late final AddCartController addCartController;
  late final CheckoutController checkOutController;
  late final PlaceOrderController placeOrderController;


  var tierId;
  var checklogin;

  var productName = '';
  var description = '';

  @override
  void dispose() {
    super.dispose();
    // Access the instance of CheckoutController
    var checkoutController = Get.find<CheckoutController>();

    // Check if selectedFile is not null before accessing its properties
    if (checkoutController.selectedFile.value != null) {
      checkoutController.selectedFile.value = null;
    }
  }

  @override
  void initState() {
    super.initState();
 /*   try {
      addCartController = Get.find<AddCartController>();
    } catch (e) {
      addCartController = Get.put(AddCartController());
    }
*/
    try {
      checkOutController = Get.find<CheckoutController>();
    } catch (e) {
      checkOutController = Get.put(CheckoutController());
    }

    try {
      placeOrderController = Get.find<PlaceOrderController>();
    } catch (e) {
      placeOrderController = Get.put(PlaceOrderController());
    }

/*    // Product details set kare
    if (addCartController.getcartProductList.isNotEmpty) {
      productName = addCartController.getcartProductList[0]['name'] ?? '';
      description = addCartController.getcartProductList[0]['sort_description'] ?? '';
    }*/
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List cartItems =  widget.cartItems;
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: HelperAppBar(
          title: 'Place Order',
          displayCart: false,displaySearch: false,
        ),
        body: GetBuilder<AddressController>(builder: (addressController) {
          if (addressController.addListLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: primarylogin,
                strokeWidth: 2,
              ),
            );
          }
          return GetBuilder<CheckoutController>(builder: (checkOutController) {
            if (checkOutController.checkouttLoader.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: primarylogin,
                  strokeWidth: 2,
                ),
              );
            }
            bool canPlace = widget.canPlaceOrder.toString() == "true";
            double totalAmount = double.tryParse(widget.total.toString()) ?? 0.0;
            double walletBalance = double.tryParse(widget.user["user_balance"].toString()) ?? 0.0;

// Wallet use hone par hi minus hoga
            double payableAmount = widget.walletStatus=="1"
                ? (totalAmount - walletBalance)
                : totalAmount;

// Negative nahi hone dena
            if (payableAmount < 0) {
              payableAmount = 0;
            }
            return widget.cartItems.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/svg/emptycart.svg',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Your cart is empty",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Add items to your cart to place an order",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Get.offAll(BottomBar(
                          bottomindex: 2,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primarylogin,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Start Shopping",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 15.0),
                    child: Column(
                      children: [
                        // const LocationLabel(),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            padding:  EdgeInsets.symmetric(vertical: 16,horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.shade200,
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: Offset(3, 3)),
                                ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.local_shipping_outlined,color: primarylogin,
                                  size: 20,),
                                Text("Shipping",style: TextStyle(
                                    color: primarylogin,fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),),
                                Container(
                                  height: 2,
                                  width: size.width*0.1,
                                  decoration: BoxDecoration(
                                    color: primarylogin,
                                  ),
                                ),


                                Icon(Icons.payment_rounded,color: primarylogin,
                                  size: 20,),
                                Text("Payment",style: TextStyle(
                                    color: primarylogin,fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),),
                                Container(
                                  height: 2,
                                  width: size.width*0.1,
                                  decoration: BoxDecoration(
                                    color: primarylogin,
                                  ),
                                ),

                                Icon(Icons.receipt_long_outlined,color: primarylogin,
                                  size: 20,),
                                Text("Review",style: TextStyle(
                                    color: primarylogin,fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 15,),
                        // Product List
                        ListView.builder(
                          itemCount: cartItems.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            var cartproduct = cartItems[index];

                            log('it stores here : $cartproduct');

                            productName = cartItems[index]['name'];

                            description =
                            cartItems[index]
                            ['sort_description'];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.shade200,
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: Offset(3, 3)),
                                  ]
                              ),
                              child: Row(
                                children: [
                                  // Product Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        cartproduct['main_image'],
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
                                        Text(
                                          cartproduct['name'].toString() == "null"
                                              ? ""
                                              : cartproduct['name'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[900],
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        if (cartproduct['sort_description'] != null &&
                                            cartproduct['sort_description'].toString() != "null")
                                          Text(
                                            cartproduct['sort_description'].toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        const SizedBox(height: 8),

                                        // Attributes
                                        if (cartproduct['attributes'].isNotEmpty)
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: List.generate(
                                                cartproduct['attributes'].length,
                                                    (indexAtt) {
                                                  var attributedata = cartproduct['attributes'][indexAtt];
                                                  return Container(
                                                    margin: const EdgeInsets.only(right: 8),
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: primarylogin.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      attributedata.toString(),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: primarylogin,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Price and Quantity
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹${cartproduct['price']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: primarylogin,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Qty: ',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              cartproduct['quantity'].toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),


                        /// precaution
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Obx(() {
                              if (checkOutController.selectedFile.value != null) {
                                String filePath = checkOutController
                                    .selectedFile.value!.path;
                                String fileType = checkOutController
                                    .selectedFileType.value;

                                // Display based on file type
                                if (fileType == 'Image') {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Uploaded Prescription',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: InteractiveViewer(
                                                child: Image.file(
                                                  File(filePath),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.file(
                                            File(filePath),
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (fileType == 'PDF') {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Uploaded Prescription',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: PDFView(
                                          filePath: filePath,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            }),
                          ),
                        ),


                        // Price Details Card
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.shade200,
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: Offset(3, 3)),
                              ]
                          ),
                          child: Column(
                            children: [
                              _buildPriceRow('Subtotal', '₹${widget.subTotal}','assets/images/bag.png'),
                              const SizedBox(height: 8),
                              _buildPriceRow('Tax', '₹${widget.tax}',"assets/images/discount.png"),
                              const SizedBox(height: 8),
                              _buildPriceRow('Shipping', '₹${widget.shipping.toStringAsFixed(2)}',"assets/images/express-delivery.png"),
                              const SizedBox(height: 8),
                              /// Discount (show only if not 0)
                              if (widget.discount != 0) ...[
                                _buildPriceRow('Discount', '-₹${widget.discount}',"assets/images/promo.png"),
                                const SizedBox(height: 8),
                              ],

                              /// Shipping Discount (show only if not 0)
                              if (widget.shippingDiscount != 0) ...[
                                _buildPriceRow('Shipping Discount', '-₹${widget.shippingDiscount.toStringAsFixed(2)}',"assets/images/promo.png"),
                                const SizedBox(height: 8),
                              ],

                              _buildPriceRow('Total', '₹${widget.total}',"assets/images/money-currency.png", isTotal: true),
                              if(widget.walletStatus=="1")
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: _buildPriceRow('Wallet Used', '-₹${widget.user["user_balance"]}',"assets/images/wallet_outline.png"),
                                ),

                              Divider(height: 20, color: Colors.grey.shade300,),
                              _buildPriceRow('Payable Amount', '₹${payableAmount.toStringAsFixed(2)}',"assets/images/money-currency.png", isTotal: true),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Warnings
                        if (!canPlace && widget.warning.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: List.generate(widget.warning.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          widget.warning[index],
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Place Order Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: canPlace ? () {
                              /// 🟢 CASE 1: PAYMENT PENDING → RETRY PAYMENT
                              if (placeOrderController.isPaymentInProgress.value &&
                                  placeOrderController.pendingOrderData.isNotEmpty) {

                                var pendingData = placeOrderController.pendingOrderData.value;
                                var orderId = pendingData['data']['order_id'];
                                var email = placeOrderController.data.getproductdecod['data']['user']['email'] ?? '';
                                var contact = placeOrderController.data.getproductdecod['data']['user']['mobile'] ?? '';
                                var razorpayKey = placeOrderController.settingData.setting_response['settings']['razorpay_key'].toString();

                                double totalAmt = placeOrderController.totalRazorpayAmount.value;
                                if (totalAmt == 0) totalAmt = double.tryParse(widget.total) ?? 0.0;

                                placeOrderController.openCheckout(
                                  totalAmt,
                                  orderId,
                                  productName,
                                  description,
                                  contact,
                                  email,
                                  razorpayKey,
                                );
                                return;
                              }

                              /// 🟢 CASE 2: NEW ONLINE PAYMENT
                              if (widget.paymentmode == "2") {
                                // Store checkout data before payment
                                placeOrderController.storeCheckoutData(
                                  addressId: widget.addressId.toString(),
                                  comment: widget.comment.toString(),
                                  walletStatus: widget.walletStatus.toString(),
                                  selectedFilePath: checkOutController.selectedFile.value?.path,
                                );

                                // Get user details
                                String email = widget.user['email']?.toString() ?? '';
                                String contact = widget.user['mobile']?.toString() ?? '';

                                double total = double.parse(widget.total.toString());

                                var placeUrl = Uri.parse(placeorder_url);
                                var placeBody = {
                                  'address_id': widget.addressId.toString(),
                                  'payment_mode': widget.paymentmode.toString(),
                                  'user_comment': widget.comment.toString(),
                                  'use_wallet': widget.walletStatus.toString(),
                                  'session_id': Environment.deviceid.toString(),
                                };

                                // Initialize payment without clearing cart
                                placeOrderController.initializeOnlinePayment(
                                  amount: total,
                                  productName: productName,
                                  productDescription: description,
                                  userContact: contact,
                                  userEmail: email,
                                  url: placeUrl,
                                  parameter: placeBody,
                                  selectedFilePath: checkOutController.selectedFile.value?.path,
                                );
                              }
                              /// 🟢 CASE 3: COD
                              else {
                                var placeUrl = Uri.parse(placeorder_url);
                                var placeBody = {
                                  'address_id': widget.addressId.toString(),
                                  'payment_mode': widget.paymentmode.toString(),
                                  'user_comment': widget.comment.toString(),
                                  'use_wallet': widget.walletStatus.toString(),
                                  'session_id': Environment.deviceid.toString(),
                                };

                                placeOrderController.placeOrderForCOD(
                                  placeUrl,
                                  placeBody,
                                  checkOutController.selectedFile.value?.path,
                                );
                              }
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canPlace ? primarylogin : Colors.grey[300],
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/protection.png",scale: 2.5,
                                  color: canPlace ? Colors.white : Colors.grey[600],),
                                const SizedBox(width: 12),
                                Text(
                                  'Place Order',
                                  style: TextStyle(
                                    color: canPlace ? Colors.white : Colors.grey[600],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: canPlace ? Colors.white : Colors.grey[600],
                                ),
                                Spacer(),
                                Text(
                                  '(${cartItems.length} items)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: canPlace ? Colors.white : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      /*  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: canPlace ? () {
                              /// 🟢 CASE 1: PAYMENT PENDING → RETRY PAYMENT
                              if (placeOrderController.isPaymentInProgress.value &&
                                  placeOrderController.pendingOrderData.isNotEmpty) {

                                var pendingData = placeOrderController.pendingOrderData.value;
                                var orderId = pendingData['data']['order_id'];
                                var email = placeOrderController.data.getproductdecod['data']['user']['email'] ?? '';
                                var contact = placeOrderController.data.getproductdecod['data']['user']['mobile'] ?? '';
                                var razorpayKey = placeOrderController.settingData.setting_response['settings']['razorpay_key'].toString();

                                double totalAmt = placeOrderController.totalRazorpayAmount.value;
                                if (totalAmt == 0) totalAmt = double.tryParse(widget.total) ?? 0.0;

                                placeOrderController.openCheckout(
                                  totalAmt,
                                  orderId,
                                  productName,
                                  description,
                                  contact,
                                  email,
                                  razorpayKey,
                                );
                                return;
                              }

                              /// 🟢 CASE 2: NEW ONLINE PAYMENT
                              if (widget.paymentmode == "2") {
                                // Store checkout data before payment
                                placeOrderController.storeCheckoutData(
                                  addressId: widget.addressId.toString(),
                                  comment: widget.comment.toString(),
                                  walletStatus: widget.walletStatus.toString(),
                                  selectedFilePath: checkOutController.selectedFile.value?.path,
                                );

                                // Get user details
                                var email = addCartController.getproductdecod['data']['user']['email'] ?? '';
                                var contact = addCartController.getproductdecod['data']['user']['mobile'] ?? '';

                                double total = double.parse(widget.total);

                                var placeUrl = Uri.parse(placeorder_url);
                                var placeBody = {
                                  'address_id': widget.addressId.toString(),
                                  'payment_mode': widget.paymentmode.toString(),
                                  'user_comment': widget.comment.toString(),
                                  'use_wallet': widget.walletStatus.toString(),
                                  'session_id': Environment.deviceid.toString(),
                                };

                                // Initialize payment without clearing cart
                                placeOrderController.initializeOnlinePayment(
                                  amount: total,
                                  productName: productName,
                                  productDescription: description,
                                  userContact: contact,
                                  userEmail: email,
                                  url: placeUrl,
                                  parameter: placeBody,
                                  selectedFilePath: checkOutController.selectedFile.value?.path,
                                );
                              }
                              /// 🟢 CASE 3: COD
                              else {
                                var placeUrl = Uri.parse(placeorder_url);
                                var placeBody = {
                                  'address_id': widget.addressId.toString(),
                                  'payment_mode': widget.paymentmode.toString(),
                                  'user_comment': widget.comment.toString(),
                                  'use_wallet': widget.walletStatus.toString(),
                                  'session_id': Environment.deviceid.toString(),
                                };

                                placeOrderController.placeOrderForCOD(
                                  placeUrl,
                                  placeBody,
                                  checkOutController.selectedFile.value?.path,
                                );
                              }
                            } : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: canPlace ? primarylogin : Colors.grey[300],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Place Order",
                                    style: TextStyle(
                                      color: canPlace ? Colors.white : Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: canPlace ? Colors.white : Colors.grey[600],
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),*/

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
          });
        }),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, String icon, {bool isTotal = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration:BoxDecoration(
            color: primary4.withOpacity(0.11),
            shape: BoxShape.circle,
          ),
          child: Image.asset(icon,scale: isTotal ?3.5 : 4.0,color: primarylogin,),
        ),
        SizedBox(width: 10,),
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.grey[900] : Colors.grey[700],
          ),
        ),
        Spacer(),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? primarylogin : Colors.grey[800],
          ),
        ),
      ],
    );
  }
}