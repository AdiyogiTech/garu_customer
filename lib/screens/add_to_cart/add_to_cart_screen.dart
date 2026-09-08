import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/add_to_cart/addto_cart_controller.dart';
import 'package:garu_customer/screens/add_to_cart/coupon_controller.dart';
import 'package:garu_customer/screens/address/address_controller.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/checkout/checkout_controller.dart';
import 'package:garu_customer/screens/checkout/checkout_screen.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/style.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/login/login_screen.dart';
import '../../Environment/Environment.dart';
import '../../constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

class AddToCartPage extends StatefulWidget {
  //Map<String, dynamic>? selectAddress;

  // AddToCartPage({this.selectAddress});
  const AddToCartPage({super.key});

  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  AddCartController addCartController = Get.put(AddCartController());
  AddressController addressController = Get.put(AddressController());
  // CheckoutController checkoutController = Get.put(CheckoutController());
  late ApplyCouponController applyCouponController;
  final TextEditingController couponController = TextEditingController();
  var itemnumber;
  var tierId;
  var checklogin;

  @override
  void initState() {
    super.initState();
    applyCouponController = Get.put(ApplyCouponController(couponController));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCartListApi();
    });
  }

  Future<void> getCartListApi() async {
    var url = "${getcart_url}?session=${Environment.deviceid.toString()}";

    await addCartController.GetCartApi(
        url, Environment.deviceid.toString(), true);

    // ✅ Ensure quantity >= minimum_qty
    for (var item in addCartController.getcartProductList) {
      int minQty = item['minimum_qty'] ?? 1;
      int qty = item['quantity'] ?? minQty;

      if (qty < minQty) {
        item['quantity'] = minQty;
      }
    }

    addCartController.update(); // refresh UI
  }
  Future<void> removeCouponIfApplied() async {
    if (addCartController.coupon != null) {
      var url = Uri.parse(
        deleteCouponUrl + Environment.deviceid.toString(),
      );
      await applyCouponController.deleteCouponApi(url);
    }
  }

  void EmptyCartItem() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Empty Cart",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Are you sure you want to clear your cart?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Future.delayed(
                                const Duration(milliseconds: 500),
                                    () async {
                                      Navigator.of(context).pop();
                                  var sessionid =
                                  Environment.deviceid.toString();
                                  print(
                                      "sessionid ..... ${sessionid.toString()}");
                                  var deleteUrl =
                                  Uri.parse(emptyCartUrl + sessionid);
                                  await addCartController.EmptyCartApi(
                                      deleteUrl);
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Clear"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void deleteCartItem(cartId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Remove Item",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Are you sure you want to remove this item from your cart?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.back();
                            if (Get.isDialogOpen ?? false) Get.back(); // 🔥 dialog close

                            var removecartUrl = Uri.parse(removecart_url);
                            var removeBody = jsonEncode({
                              'session_id': Environment.deviceid.toString(),
                              'product_id': cartId.toString()
                            });

                            await addCartController.RemoveCartApi(removecartUrl, removeBody, cartId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Remove"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showRemoveDialog(int productId,int minQty) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Remove Item",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          "This product has minimum quantity $minQty. Do you want to remove it from cart?",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Future.delayed(const Duration(milliseconds: 500),
                      () async {
                    var removecartUrl = Uri.parse(removecart_url);
                    var removeBody = jsonEncode({
                      'session_id': Environment.deviceid.toString(),
                      'product_id': productId.toString()
                    });

                    print("removecartUrl----->>>" +
                        removecartUrl.toString());
                    print("removeBody----->>>" + removeBody.toString());
                    addCartController.RemoveCartApi(
                        removecartUrl, removeBody,productId);
                    // ApiBaseHelper().AppLogout();
                  });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    removeCouponIfApplied();
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        await removeCouponIfApplied(); // 🔥 coupon remove here
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,

        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () async{
              await removeCouponIfApplied();
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey[700],
              size: 16,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
          ),
        ),

        titleSpacing: 8,
        leadingWidth: 48,

        title: Text(
          "My Cart",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.grey[900],
            letterSpacing: 0.3,
          ),
        ),

        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
        actions: [
          GetBuilder<AddCartController>(
            builder: (controller) {
              if (controller.getcartProductList.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                margin: const EdgeInsets.only(right: 15),
                child: IconButton(
                  onPressed: () {
                    EmptyCartItem();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                ),);
            },
          ),
        ],

      ),

        body: GetBuilder<AddressController>(builder: (addressController) {
          if (addressController.addListLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return GetBuilder<AddCartController>(builder: (addCartController) {
            if (addCartController.getcartLoader.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (addCartController.isCartLoaded.value &&
                addCartController.getcartProductList.isEmpty) {
              return Center(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/emptycart.svg',
                        height: size.height*0.2,
                        width: size.width*0.2,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Your cart is empty",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Looks like you haven't added\nanything to your cart yet!",
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
              );
            }
            return Padding(
              padding:  EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  // Clear Cart Button
              /*    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Future.delayed(
                                const Duration(milliseconds: 500),
                                    () async {
                                  var sessionid =
                                  Environment.deviceid.toString();
                                  print(
                                      "sessionid ..... ${sessionid.toString()}");
                                  var deleteUrl =
                                  Uri.parse(emptyCartUrl + sessionid);
                                  await addCartController.EmptyCartApi(
                                      deleteUrl);
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Clear Cart',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),*/

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // const LocationLabel(),

                          // Cart Items List
                          ListView.builder(
                            itemCount:
                            addCartController.getcartProductList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              log('herereddewfgefdewhgfe ${addCartController.getcartProductList[index]}');

                              var cartproduct =
                              addCartController.getcartProductList[index];
                              itemnumber = cartproduct['quantity'].toString();
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: Offset(3,3),
                                      blurRadius: 10,
                                      spreadRadius: 3
                                    )
                                  ]
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          cartproduct['main_image']
                                              .toString(),
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error,
                                              stackTrace) {
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
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height:size.height*0.05,
                                                  child: Text(
                                                    cartproduct['name']
                                                        .toString() ==
                                                        "null"
                                                        ? ""
                                                        : cartproduct['name']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.grey[900],
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  var cartId = cartproduct[
                                                  'vendor_product_id'];
                                                  print(
                                                      "cartId for delete item --->>>" +
                                                          cartId.toString());
                                                  deleteCartItem(cartId);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.grey[400],
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),


                                          // Attributes
                                          if (cartproduct['attributes'].isNotEmpty)
                                            const SizedBox(height: 4),
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


                                          /// Price Change Message
                                          if (!(cartproduct['price_change'] == 'same' && cartproduct['price_diff'] == 0))
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                "Price ${cartproduct['price_change']} by ₹${cartproduct['price_diff']}",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),


                                          // Price and Quantity Row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹${cartproduct['price']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: primarylogin,
                                                  fontSize: 16,
                                                ),
                                              ),

                                              // Quantity Selector
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[50],
                                                  borderRadius: BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: Colors.grey[200]!,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ///decrement
                                                    GestureDetector(
                                                      onTap: () async {
                                                        var productId = cartproduct['vendor_product_id'];
                                                        int minQty = cartproduct['minimum_qty'] ?? 1;
                                                        int currentQty = cartproduct['quantity'] ?? 1;

                                                        // // 🔴 CASE 1: Minimum qty = 1 → Direct remove
                                                        // if (minQty == 1 && currentQty == 1) {
                                                        //   deleteCartItem(productId);
                                                        //   return;
                                                        // }

                                                        // 🟡 CASE 2: Minimum qty > 1 → Show popup
                                                        if (currentQty <= minQty) {
                                                          showRemoveDialog(productId,minQty);
                                                          return;
                                                        }

                                                        // 🟢 CASE 3: Normal decrement
                                                        var quantity = currentQty - 1;

                                                        var updateUrl = Uri.parse(addtocart_url);
                                                        var updateBody = jsonEncode({
                                                          'session_id': Environment.deviceid.toString(),
                                                          'product_id': productId.toString(),
                                                          'quantity': quantity.toString(),
                                                        });

                                                       /* var response = await ApiBaseHelper()
                                                            .postAPICall(updateUrl, updateBody, true);

                                                        if (response.statusCode == 200) {
                                                          addCartController.decreaseQuantity(index, productId);
                                                        } else if (response.statusCode == 422) {
                                                          var decoded = jsonDecode(response.body);
                                                          toastMsg(decoded['message'].toString(), false);
                                                        }*/
                                                        addCartController.updateCartQuantity(

                                                          productId: productId,

                                                          quantity: quantity,

                                                        );
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 16,
                                                          color: Colors.grey[700],
                                                        ),
                                                      ),
                                                    ),

                                                    Container(
                                                      width: 30,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        cartproduct['quantity'].toString(),
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),

                                                    ///increment
                                                    GestureDetector(
                                                      onTap: () async {
                                                        var productId = cartproduct['vendor_product_id'];
                                                        int maxQty = cartproduct['maximum_qty'] ?? 999;
                                                        int currentQty = cartproduct['quantity'] ?? 1;
                                                        /// 🔴 CASE: qty == maxQty → show toast
                                                        if (currentQty >= maxQty) {
                                                          toastMsg("Maximum quantity limit reached", false);
                                                          return;
                                                        }
                                                        // Prepare API request
                                                        var updateUrl = Uri.parse(addtocart_url);
                                                        /// 🟢 Normal increment
                                                        int newQty = currentQty + 1;
                                                        var updateBody =
                                                        jsonEncode({
                                                          'session_id':
                                                          Environment.deviceid
                                                              .toString(),
                                                          'product_id': productId
                                                              .toString(),
                                                          'quantity': newQty.toString(),
                                                        });

                                                        print("Sending updateBody --->> $updateBody");

                                                        //   Optimistic UI Update (Optional)
                                                        // int originalQuantity = cartproduct['quantity'] ?? 0;
                                                        // setState(() {
                                                        //   cartproduct['quantity'] = originalQuantity + 1;
                                                        // });

                                                        //  API Request

                                                        addCartController.updateCartQuantity(

                                                          productId: productId,

                                                          quantity: newQty,

                                                        );
                                                        // var response =
                                                        //     await ApiBaseHelper().postAPICall(updateUrl, updateBody, true);
                                                        //
                                                        // if (response.statusCode == 200) {
                                                        //   print("Item updated successfully");
                                                        //   //
                                                        //   // int productIndex = addCartController.getcartProductList.indexWhere(
                                                        //   //   (element) =>
                                                        //   //       element['vendor_product_id'].toString() == productId,
                                                        //   // );
                                                        //
                                                        //   // if (productIndex != -1) {
                                                        //   //   addCartController.getcartProductList[productIndex]['quantity'] = (addCartController.getcartProductList[productIndex]['quantity'] ?? 0) + 1;
                                                        //   //
                                                        //   //   //   Notify UI via GetX if necessary
                                                        //   //   addCartController.update(); //
                                                        //   // // Ensure GetX reflects the update
                                                        //   // }
                                                        //   getCartListApi();
                                                        //   setState(() {});
                                                        // } else {
                                                        //   //   API failed - Rollback UI change
                                                        //   setState(() {
                                                        //     cartproduct['quantity'] = originalQuantity;
                                                        //   });
                                                        //   print("API Error: ${response.body}");
                                                        // }
                                                        //
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        alignment: Alignment.center,
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color: Colors.grey[700],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Coupon Section
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: Offset(3,3),
                                      blurRadius: 10,
                                      spreadRadius: 3
                                  )
                                ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration:BoxDecoration(
                                        color: primary4.withOpacity(0.11),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset("assets/images/tag.png",scale: 2.5,),
                                    ),
                                    SizedBox(width: 12,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Have a coupon?',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                        SizedBox(height: 2,),
                                        Text(
                                          'Enter coupon code',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        showCouponBottomSheet();
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 30),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'View Coupons',
                                            style: TextStyle(
                                              color: primarylogin,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(Icons.arrow_forward_ios,color: primarylogin,size: 15,)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // Coupon Input Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: couponController,
                                          decoration: InputDecoration(
                                            hintText: 'Enter coupon code',
                                            hintStyle: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 13,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        var url = Uri.parse(applycoupon_url);
                                        var body = jsonEncode({
                                          "session_id": Environment.deviceid.toString(),
                                          "coupon": couponController.text.trim(),
                                        });

                                        applyCouponController.applyCouponApi(url, body);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF5FCB3E),
                                              Color(0xFF37841F),
                                              Color(0xFF235E14),
                                            ],
                                          ),

                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 14,
                                          ),
                                          child: const Text(
                                            'Apply',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                // Applied Coupon Display
                                if (addCartController.coupon != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 16),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primarylogin.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: primarylogin.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: primarylogin,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addCartController.coupon['code'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: primarylogin,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Coupon applied successfully',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            var url = Uri.parse(
                                                deleteCouponUrl + Environment.deviceid.toString());
                                            applyCouponController.deleteCouponApi(url);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Price Details
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: Offset(3,3),
                                      blurRadius: 10,
                                      spreadRadius: 3
                                  )
                                ]
                            ),
                            child: Column(
                              children: [
                                _buildPriceRow('Subtotal', '₹${addCartController.subtotal}',"assets/images/bag.png"),
                                const SizedBox(height: 8),
                                _buildPriceRow('Tax', '₹${addCartController.tax}',"assets/images/discount.png"),
                                const SizedBox(height: 8),
                                _buildPriceRow('Discount', '₹${addCartController.discount}',"assets/images/promo.png"),
                                 Divider(height: 20, color: Colors.grey.shade300,),
                                _buildPriceRow('Total', '₹${addCartController.total}',"assets/images/money-currency.png", isTotal: true),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Proceed Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // prefs?.setString(
                                //     "itemLength",
                                //     addCartController.getcartProductList.length
                                //         .toString());
                                Environment.appuserlog == true
                                    ? Get.to(CheckOutPage())
                                    : Get.to(LoginPage());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primarylogin,
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
                                  Image.asset("assets/images/protection.png",scale: 2.5,),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Proceed to Checkout',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                  ),
                                 Spacer(),
                                  Text(
                                    '(${addCartController.getcartProductList.length} items)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
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
                ],
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

  bool isExpired(String endDate) {
    DateTime expiry = DateTime.parse(endDate);
    DateTime now = DateTime.now();

    DateTime todayDate = DateTime(now.year, now.month, now.day);
    DateTime expiryDate =
    DateTime(expiry.year, expiry.month, expiry.day);
    print('return>>>>>${expiryDate.isBefore(todayDate)}');
    return expiryDate.isBefore(todayDate);
  }

  void showCouponBottomSheet() {
    // fetch list before opening
    applyCouponController.getCouponList();

    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Available Coupons",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                  ),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                /// 🔄 Loader
                if (applyCouponController.listLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                /// ❌ Empty
                if (applyCouponController.couponList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No coupons available",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                /// ✅ List
                return ListView.builder(
                  itemCount:
                  applyCouponController.couponList.length,
                  itemBuilder: (context, index) {
                    var coupon =
                    applyCouponController.couponList[index];
                    bool expired =
                    isExpired(coupon['date_end']);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: expired
                            ? Colors.grey[50]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: expired
                              ? Colors.grey[300]!
                              : primarylogin.withOpacity(0.3),
                        ),
                      ),
                      child: Opacity(
                        opacity: expired ? 0.6 : 1,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: expired ? Colors.grey[300] : primarylogin,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    coupon['code'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: expired ? Colors.grey[600] : Colors.white,
                                    ),
                                  ),
                                ),
                                if (!expired)
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.copy,
                                          size: 18,
                                          color: primarylogin,
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                                text: coupon[
                                                'code']),
                                          );
                                          toastMsg(
                                              "Coupon copied",
                                              true);
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                          applyCouponController
                                              .couponController
                                              .text =
                                          coupon['code'];
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(50, 30),
                                        ),
                                        child: Text(
                                          "Apply",
                                          style: TextStyle(
                                            color: primarylogin,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (expired)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      "Expired",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              coupon['name'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coupon['description'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
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
                              child: Text(
                                "Min. Order: ₹${coupon['min_order_value']} | Discount: ₹${coupon['discount']}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}