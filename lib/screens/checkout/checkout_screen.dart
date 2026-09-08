import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/main.dart';
import 'package:garu_customer/screens/add_to_cart/addto_cart_controller.dart';
import 'package:garu_customer/screens/address/address_controller.dart';
import 'package:garu_customer/screens/address/address_screen.dart';
import 'package:garu_customer/screens/checkout/checkout_controller.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/style.dart';

class CheckOutPage extends StatefulWidget {
  Map<String, dynamic>? selectAddress;
  CheckOutPage({
    super.key,
    this.selectAddress,
  });

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  //Map<String, dynamic>? selectAddress;
  bool isWalletUsed = false;
  String walletStatus = "0";
  // AddToCartPage({this.selectAddress});
  AddressController addressController = Get.put(AddressController());
  CheckoutController checkoutController = Get.put(CheckoutController());
  AddCartController controller = Get.put(AddCartController());

  final TextEditingController _commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int isPayMode = 2;
  bool switchValue = false;

  Future<void> getAddressList() async {
    prefs!.remove("razorpay_order_id");
    var addressUrl = Uri.parse(addresslistUrl);
    log('here is the api here!!');
    await addressController.AddressListApi(addressUrl);
    // await CheckoutApi();
  }

  @override
  void initState() {
    super.initState();
    getAddressList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getAddressId() {
    if (widget.selectAddress == null) {
      return addressController.addListData['data'][0]['id'].toString();
    } else {
      return widget.selectAddress!['id'].toString();
    }
  }
  bool hasValidAddress() {
    // address list empty
    if (addressController.addListData.isEmpty ||
        addressController.addListData['data'] == null ||
        addressController.addListData['data'].isEmpty) {
      return false;
    }

    // address list hai but user ne select nahi kiya
    if (widget.selectAddress == null) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: HelperAppBar(
          title: 'Checkout',
          displayCart: false,displaySearch: false,
        ),
        body: GetBuilder<AddressController>(builder: (addressController) {
          if (addressController.addListLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return GetBuilder<CheckoutController>(builder: (checkoutController) {
            if (checkoutController.checkouttLoader.value) {
              return Center(child: CircularProgressIndicator());
            }

            double totalAmount = double.tryParse(controller.total.toString()) ?? 0.0;
            double walletBalance = double.tryParse(controller.user_balance.toString()) ?? 0.0;

// Wallet use hone par hi minus hoga
            double payableAmount = isWalletUsed
                ? (totalAmount - walletBalance)
                : totalAmount;

// Negative nahi hone dena
            if (payableAmount < 0) {
              payableAmount = 0;
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
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
                                  color: Colors.grey,
                                ),
                              ),

                              Icon(Icons.receipt_long_outlined,color: Colors.grey,
                                size: 20,),
                              Text("Review",style: TextStyle(
                                  color: Colors.grey,fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),),

                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20,),
                      // Address Card
                      if (widget.selectAddress != null ||
                          (addressController.addListData.isNotEmpty &&
                              addressController.addListData['data'] != null &&
                              addressController.addListData['data'].isNotEmpty))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primary4.withOpacity(0.11),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      color: primarylogin,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[900],
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      final result = await Get.to(() =>  AddressPage(
                                        addressId: widget.selectAddress?['id']?.toString(),));

                                      if (result != null) {
                                        setState(() {
                                          widget.selectAddress = result;
                                        });
                                      }
                                      /// select address verify
                                      await checkoutController.verifyCartAddress(
                                          widget.selectAddress!['id'].toString());
                                      setState(() {
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                      decoration: BoxDecoration(
                                        gradient:  LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                           primary2,
                                            Color(0xFF37841F),
                                            Color(0xFF235E14),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.selectAddress == null
                                                ? (addressController.addListData.isNotEmpty &&
                                                addressController.addListData != null &&
                                                addressController.addListData['data'] != null &&
                                                addressController.addListData['data'].isNotEmpty
                                                ? 'Change Address'
                                                : 'Add Address')
                                                : 'Choose Address',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 10,),
                              Container(
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                     CupertinoIcons.check_mark_circled_solid,
                                      color: primarylogin,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Deliver To',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.selectAddress == null
                                                ? "${addressController.addListData['data'][0]['address_1'] ?? ''}, "
                                                "${addressController.addListData['data'][0]['address_2'] ?? ''}, "
                                                "${addressController.addListData['data'][0]['area'] ?? ''}, "
                                                "${addressController.addListData['data'][0]['city'] ?? ''}, "
                                                "${addressController.addListData['data'][0]['state'] ?? ''}, "
                                                "${addressController.addListData['data'][0]['country'] ?? ''}, "
                                                "${addressController.addListData['data'][0]['postcode'] ?? ''}, "
                                                "${addressController.addListData['data'][0]['name'] ?? ''}, "
                                                "${addressController.addListData['data'][0]['mobile'] ?? ''}"
                                                : "${widget.selectAddress!['address_1'] ?? ''}, "
                                                "${widget.selectAddress!['address_2'] ?? ''}, "
                                                "${widget.selectAddress!['area'] ?? ''}, "
                                                "${widget.selectAddress!['city'] ?? ''}, "
                                                "${widget.selectAddress!['state'] ?? ''}, "
                                                "${widget.selectAddress!['country'] ?? ''}, "
                                                "${widget.selectAddress!['postcode'] ?? ''}, "
                                                "${widget.selectAddress!['name'] ?? ''}, "
                                                "${widget.selectAddress!['mobile'] ?? ''}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[800],
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Payment Mode Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primary4.withOpacity(0.11),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.payment_outlined,
                                    color: primarylogin,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Payment Mode',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[900],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // Online Payment Option
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => PaymentType(2),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isPayMode == 2 ? primary4.withOpacity(0.11) : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isPayMode == 2 ? primarylogin : Colors.grey[300]!,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/online-pay.png',
                                            scale: 1.8,
                                            color: isPayMode == 2 ? primarylogin : Colors.grey[600],
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Online",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: isPayMode == 2 ? primarylogin : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // COD Option
                                if (int.parse('1'.toString()) == 1)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => PaymentType(1),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: isPayMode == 1 ? primary4.withOpacity(0.11) : Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isPayMode == 1 ? primarylogin : Colors.grey[300]!,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/images/COD.png',
                                             scale: 1.8,
                                              color: isPayMode == 1 ? primarylogin : Colors.grey[600],
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "COD",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: isPayMode == 1 ? primarylogin : Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      if (controller.user_balance != "0.00")
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primary4.withOpacity(0.11),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_outlined,
                                color: primarylogin,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Use Wallet Balance',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                     if (controller.user_balance != "0.00")
                      // Wallet Option
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Available Balance: ₹${controller.user_balance}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[900],
                                  fontSize: 14,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isWalletUsed = !isWalletUsed;
                                    walletStatus = isWalletUsed ? "1" : "0";
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isWalletUsed ? Colors.green : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isWalletUsed ? Colors.green : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: isWalletUsed
                                      ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 1),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primary4.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.comment_outlined,
                                  color: primarylogin,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _commentController,
                                  maxLines: 3,
                                  decoration:  InputDecoration(
                                    hintText: "Add order comments (optional)",
                                    hintStyle: TextStyle(color: Colors.grey[400],
                                    fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),

                      // Price Details Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primary4.withOpacity(0.11),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.receipt_long_sharp,
                                color: primarylogin,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Bill Detail',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildPriceRow('Subtotal', '₹${controller.subtotal}',"assets/images/bag.png"),
                            const SizedBox(height: 8),
                            _buildPriceRow('Tax', '₹${controller.tax}',"assets/images/discount.png"),
                            const SizedBox(height: 8),
                            _buildPriceRow('Discount', '- ₹${controller.discount}',"assets/images/promo.png"),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: _buildPriceRow('Total', '₹${controller.total}',"assets/images/money-currency.png", isTotal: true),
                            ),
                            if(isWalletUsed==true)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: _buildPriceRow('Wallet Used', '- ₹${controller.user_balance}',"assets/images/wallet_outline.png"),
                            ),

                            Divider(height: 20, color: Colors.grey.shade300,),
                            _buildPriceRow('Payable Amount', '₹${payableAmount.toStringAsFixed(2)}',"assets/images/money-currency.png", isTotal: true),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Error Message
                      Obx(() {
                        if (checkoutController.verifyErrorMsg.value.isEmpty) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    checkoutController.verifyErrorMsg.value,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      // Proceed Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed:  checkoutController.canProceed.value
                              ? () async {
                            /// 👉 Sirf "Add Address" wala case
                            if (widget.selectAddress == null &&
                                (addressController.addListData.isEmpty ||
                                    addressController.addListData['data'] == null ||
                                    addressController.addListData['data'].isEmpty)) {

                              final result = await Get.to(() => const AddressPage());

                              if (result != null) {
                                setState(() {
                                  widget.selectAddress = result;
                                });
                              }
                              return;
                            }

                            var selectedAddressId = widget.selectAddress != null
                                ? widget.selectAddress!['id'].toString()
                                : addressController.addListData['data'][0]['id'].toString();

                            /// 🔹 Address verify first
                            bool isVerified = await checkoutController.verifyCartAddress(selectedAddressId);

                            if (!isVerified) return;

                            /// 🔹 verified hone ke baad checkout call
                            var checkoutUrl = Uri.parse(checkout_url);

                            var checkouttBody = jsonEncode({
                              'session_id': Environment.deviceid.toString(),
                              'address_id': selectedAddressId,
                              'is_cod': walletStatus.toString(),
                            });

                            print('checkout body>>> $checkouttBody');
                            checkoutController.CheckOutApi(
                              checkoutUrl,
                              checkouttBody,
                              walletStatus,
                              selectedAddressId,
                              isPayMode.toString(),
                              _commentController.text.trim(),
                            );
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: checkoutController.canProceed.value ? primarylogin : Colors.grey[300],
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
                                color: checkoutController.canProceed.value ? Colors.white : Colors.grey[600],),
                              const SizedBox(width: 12),
                              Text(
                                'Place Order',
                                style: TextStyle(
                                  color: checkoutController.canProceed.value ? Colors.white : Colors.grey[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                               Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: checkoutController.canProceed.value ? Colors.white : Colors.grey[600],
                              ),
                              Spacer(),
                              Text(
                                '(${controller.getcartProductList.length} items)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: checkoutController.canProceed.value ? Colors.white : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
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

  PaymentType(int id) {
    print('isPayModeId ---- ${isPayMode}');
    isPayMode = id;
    print('isPayModeId ---- ${isPayMode}');
    setState(() {});
  }
}

OutlineInputBorder _OutlineInputBorder(Color borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: borderColor, width: 1),
  );
}