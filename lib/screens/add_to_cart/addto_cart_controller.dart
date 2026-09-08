import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/screens/add_to_cart/add_to_cart_screen.dart';
import 'package:garu_customer/screens/add_to_cart/cart_count_controll.dart';
import 'package:http/http.dart' as http;
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import '../../main.dart';
import '../constant/validations.dart';

class AddCartController extends GetxController {
  // var getcartProductList = <Map<String, dynamic>>[].obs;
  CartCountController cartCountController = Get.put(CartCountController());
  var addcartLoader = false.obs;
  var addtocartData;
  var getcartLoader = false.obs;
  List getcartProductList = [];
  List totalList = [];
  var removeLoader = false.obs;
  var subtotal;
  var tax;
  var discount;
  var total;
  var coupon;
  var user_balance;
  var deleteLoading = false.obs;
  var deleteData;
  var isCartLoaded = false.obs;
  Timer? _cartDebounce;

  getCartRefresh(bool loader) {
    var tierId = location_data['data']['tier_id'];
    GetCartApi(getcart_url, Environment.deviceid.toString(), false);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void updateCartQuantity({
    required int productId,
    required int quantity,
  }) {

    _cartDebounce?.cancel();

    _cartDebounce = Timer(
      const Duration(milliseconds: 500),
          () async {

        var updateUrl = Uri.parse(addtocart_url);

        var body = jsonEncode({
          "session_id": Environment.deviceid.toString(),
          "product_id": productId.toString(),
          "quantity": quantity.toString(),
        });

        var response =
        await ApiBaseHelper().postAPICall(updateUrl, body, true);

        if (response.statusCode == 200) {

          // NO FULL LOADER
          await GetCartApi(
            getcart_url,
            Environment.deviceid.toString(),
            false,
          );

        } else {

          var decoded=jsonDecode(response.body);

          toastMsg(decoded["message"], false);

        }

      },
    );

  }
  void decreaseQuantity(int index, productId) {
    var index = getcartProductList
        .indexWhere((element) => element['vendor_product_id'] == productId);
    print("index check ---->" + index.toString());
    if (getcartProductList[index]['quantity'] > 1) {
      getcartProductList[index]['quantity']--;
      getCartRefresh(false);
      update();
    }
  }

  AddtoCartApi(url, parameter) async {
    addcartLoader(true);
    update();

    log("url ==> " + url.toString());
    // getcartProductList.clear();

    try {
      // getcartProductList.clear();
      var response = await ApiBaseHelper().postAPICall(url, parameter, true);

      var decoded = jsonDecode(response.body);
      log("AddtoCartApi Resoponse ==> " + decoded.toString());

      if (response.statusCode == 200) {
        // getcartProductList.clear();

        print('inside add to cart api  200');
        addtocartData = jsonDecode(response.body);

        // getcartProductList.clear();

        log('here we go ${addtocartData}');
        var msg = addtocartData['message'];
        toastMsg(msg.toString(), true);

        ///
        cartCountController.CartCountUpdateApi(
            cartcount_url, Environment.deviceid.toString());

        ///
        // getcartProductList.clear();

        GetCartApi(getcart_url, Environment.deviceid.toString(), true);
        addcartLoader(false);
        update();
        refresh();
      } else if (response.statusCode == 422) {
        addtocartData = jsonDecode(response.body);
        var msg = addtocartData['message'];
        toastMsg(msg.toString(), false);
        addcartLoader(false);
        update();
        refresh();
      } else {
        addtocartData = [];
        addcartLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      log(' add to cart Catch 1----->>>$e');
      addcartLoader(false);
      update();
    }
  }

  var getproductdecod;



  var showUploadPrompt = false.obs;

  GetCartApi(url, parameters, loader) async {
    if (loader) {
      getcartLoader(true);
      isCartLoaded(false);
      update();
    }

    // 👈 API start
    update();

    final uri = Uri.parse(url).replace(queryParameters: {
      "session": parameters,
    });
    print('getcarturl-----$uri');// ✅ FIX

    var response = await ApiBaseHelper()
        .getAPICall(uri, true);
    log("List Cart here >${response.statusCode.toString()}");
    log("List Cart here >${response.body.toString()}");

    getproductdecod = jsonDecode(response.body);

    if (response.statusCode == 200) {

      var data = getproductdecod['data'];

      if (data != null && data is Map) {
        getcartProductList = List.from(data['items'] ?? []);

        bool hasPrescription =
        getcartProductList.any((item) => item['is_prescription'] == 1);

        showUploadPrompt(hasPrescription);

        subtotal = data['subtotal'] ?? 0;
        tax = data['tax'] ?? 0;
        discount = data['discount'] ?? 0;
        total = data['total'] ?? 0;
        coupon = data['coupon'];
        user_balance = data['user']['user_balance']?? 0;
        print("user balance>>>> $user_balance");
      } else {
        /// fallback safe
        getcartProductList = [];
        subtotal = 0;
        tax = 0;
        discount = 0;
        total = 0;
        coupon = null;
        user_balance = null;
      }

      isCartLoaded(true);
      getcartLoader(false);
      update();
    }
    else if (response.statusCode == 422) {
      getproductdecod = jsonDecode(response.body);
      isCartLoaded(true);   // ✅ API done, cart empty
      getcartLoader(false);
      update();
    } else {
      getproductdecod = jsonDecode(response.body);
      getcartProductList = [];
      totalList = [];
      isCartLoaded(true);   // ✅ API done, cart empty
      getcartLoader(false);
      update();
    }
  }


  RemoveCartApi(url, parameter, productId) async {
    removeLoader(true);
    update();

    try {
      var response = await ApiBaseHelper().postAPICall(url, parameter, true);
      var decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        toastMsg(decoded['message'].toString(), true);

        /// 🔥 LOCAL REMOVE (IMPORTANT)
        getcartProductList.removeWhere(
              (item) => item['vendor_product_id'].toString() == productId.toString(),
        );

        /// 🔥 IF CART EMPTY → RESET TOTAL
        if (getcartProductList.isEmpty) {
          subtotal = 0;
          tax = 0;
          discount = 0;
          total = 0;
          user_balance=null;
        }

        /// 🔥 REFRESH TOTALS FROM API
        await GetCartApi(getcart_url, Environment.deviceid.toString(), false);

        cartCountController.CartCountUpdateApi(
          cartcount_url,
          Environment.deviceid.toString(),
        );

        removeLoader(false);
        update();
      }
      else if (response.statusCode == 422) {
        toastMsg(decoded['message'].toString(), false);
        removeLoader(false);
        update();
      } else {
        removeLoader(false);
        update();
      }
    } catch (e) {
      print('Remove cart error >>> $e');
      removeLoader(false);
      update();
    }
  }


  EmptyCartApi(url) async {
    print('Welcome DeleteAddressApi Loading');
    deleteLoading(true);
    try {
      print('Welcome DeleteAddressApi In Try');
      var response = await ApiBaseHelper().deleteAPICall(url);
      deleteData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("check 2000");
        if (deleteData['status'] == true) {
          var msg = deleteData['message'];
          toastMsg(msg.toString(), true);

          final addCartController = Get.find<AddCartController>();

          /// 🔥 CLEAR LOCAL CART
          addCartController.getcartProductList.clear();
          addCartController.subtotal = 0;
          addCartController.tax = 0;
          addCartController.discount = 0;
          addCartController.total = 0;
          addCartController.user_balance=null;

          /// 🔥 UPDATE UI
          addCartController.update();

          deleteLoading(false);

          /// ❌ REMOVE THIS
          // Get.offAll(BottomBar(bottomindex: 2,));

          update();
        }else {
          var msg = deleteData['message'];
          toastMsg(msg.toString(), false);
          // countDownController.reset();
          deleteLoading(false);
          update();
          refresh();
        }
      } else {
        deleteData = [];
        deleteLoading(false);
        update();
        refresh();
      }
    } catch (e) {
      print('Welcome DeleteAddressApi In Catch\n ${e}');
      // toastMsg(msg, false)
      deleteLoading(false);
      update();
    }
  }

}
