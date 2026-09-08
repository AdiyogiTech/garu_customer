import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

class ProductController extends GetxController {
  var wishlistPage = 1;
  var wishlistLimit = 10;
  var wishlistTotalPage = 0.obs;
  var productData;
  String? method;
  var islikeLoader = false.obs;

  ///product list...
  var ProductListLoading = false.obs;
  var LoadMoreDataloader = false.obs;
  var NoMoreDataloader = false.obs;
  ScrollController? ProductListScrollCtrl;
  var productListlimit = 10;
  var productListPage = 1;
  var productListtotalPage =0.obs ;
  TextEditingController productSearchCtrl=TextEditingController();
  var allProductListData = <dynamic>[].obs;   // API data (original)
  var productListData = <dynamic>[].obs;

  var categoryId=''.obs;
  var area_id=''.obs;
  String currentSearch = "";
  String currentOrderBy = "desc";
  String currentPriceOrder = "";


  void productListPaginationSearch({required int catId}) {
    ProductListScrollCtrl = ScrollController();
    log("productListPaginationSearch initialized");

    ProductListScrollCtrl!.addListener(() {

      if (ProductListScrollCtrl!.position.pixels >=
          ProductListScrollCtrl!.position.maxScrollExtent - 100 &&
          !LoadMoreDataloader.value) {

        if (catId == 0) {

          // Wishlist Pagination
          if (wishlistPage < wishlistTotalPage.value) {

            wishlistPage++;

            GetProductWishList(
              page: wishlistPage,
              limit: wishlistLimit,
              areaId: area_id.value,
            );
          }

        } else {

          // Product Pagination
          if (productListPage < productListtotalPage.value) {

            productListPage++;

            ProductListApiCall(
              currentSearch,
              currentOrderBy,
              productListPage,
              productListlimit,
              categoryId.value,
              area_id.value,
              priceOrder: currentPriceOrder,
            );
          }

        }
      }
    });
  }

  ProductListApiCall(
      search,
      orderBy,
      page,
      limit,
      catId,
      areaId,{
        String? priceOrder,
      }) async {
    currentSearch = search;
    currentOrderBy = orderBy;
    currentPriceOrder = priceOrder ?? "";
    method = 'ProductListApiCall';
    if (page == 1) {
      productListData.clear();  // Clear data only when fetching the first page
      ProductListLoading(true);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    } else {
      ProductListLoading(false);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }

    var url = "$product_url/$catId?page=$page&limit=$limit&search=$search&orderColumn=name&orderBy=$orderBy&area_id=$areaId";
    // 🔥 PRICE SORT
    if (priceOrder != null && priceOrder.isNotEmpty) {
      url += "&priceOrder=$priceOrder";
    }
    log('Url==>$url');

    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);

    productListtotalPage.value =
        responsedata['data']['total_page'] ?? 0;

    print("Total Page => ${productListtotalPage.value}");

    if (response.statusCode == 200) {
      if (responsedata['status'] == true) {
        log("responsedata==>$responsedata");

        if (responsedata['data']['products'].isEmpty) {
          NoMoreDataloader(true);
        } else {
          if (page == 1) {
            productListData.clear();
            allProductListData.clear(); // Reset data for the first page
          }
          allProductListData.addAll(responsedata['data']['products']);
          productListData.value = List.from(allProductListData);

          log('Updated productListData==>$productListData');
          NoMoreDataloader(false);
        }
        ProductListLoading(false);
        LoadMoreDataloader(false);
        update();
      }
    }
    else if (response.statusCode == 404) {
      NoMoreDataloader(responsedata['data'].isEmpty);
      ProductListLoading(false);
      LoadMoreDataloader(false);
      update();
    }
  }

  Future<void> GetProductWishList({
    required int page,
    required int limit,
    required String areaId,
  }) async {

    method = 'GetProductWishList';

    if (page == 1) {
      productListData.clear();
      ProductListLoading(true);
      LoadMoreDataloader(true);
    } else {
      LoadMoreDataloader(true);
    }

    try {

      final uri = Uri.parse(get_favourite).replace(
        queryParameters: {
          "page": page.toString(),
          "limit": limit.toString(),
          "area_id": areaId,
        },
      );

      var response = await ApiBaseHelper().getAPICall(uri, true);

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          responseBody["status"] == true) {

        wishlistTotalPage.value =
            responseBody["data"]["total_page"] ?? 1;

        List products =
            responseBody["data"]["products"] ?? [];
        print("Wishlist Page => $page");
        print("Wishlist Total Page => ${responseBody["data"]["total_page"]}");
        print("Wishlist Products => ${(responseBody["data"]["products"] as List).length}");
        if (page == 1) {
          productListData.assignAll(products);
        } else {
          productListData.addAll(products);
        }
      }

    } finally {
      ProductListLoading(false);
      LoadMoreDataloader(false);
      update();
    }
  }

  void LikeApiData(Uri likeUrl, int productIndex) async {
    islikeLoader(true);
    try {
      var response = await ApiBaseHelper().getAPICall(likeUrl, true);

      if (response.statusCode == 200) {
        // Toggle the like status locally
        bool isLiked = productListData[productIndex]['is_liked'];
        productListData[productIndex]['is_liked'] = !isLiked;

        update();

        if (method == 'GetProductWishList') {
          log('Method is from wishlist, updating UI only');
          productListData.removeAt(productIndex); // Remove from wishlist UI
        } else {
          log('Method is not from wishlist, no need to call API again');
        }

      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in LikeApiData: $e');
    } finally {
      islikeLoader(false);
      update();
    }
  }

}


