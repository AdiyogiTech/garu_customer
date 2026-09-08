import 'dart:convert';
import 'package:get/get.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import '../constant/validations.dart';
import '../product/product_controller.dart';

class ProductDetailController extends GetxController {
  var detailsLoader = false.obs;
  var detailsData;
  // var imagelist = <String>[].obs;
  var mediaList = <Map<String, dynamic>>[].obs;
  var productdetail = {}.obs;
  List indexColorList = [];
  var isLoading = false.obs;
  var selectedAttributeId = ''.obs;

  int quantity = 1;
  int minQty = 1;
  int maxQty = 1;


  var isFavorite = false.obs;
  var islikeLoader = false.obs;
  final ProductController productController = Get.put(ProductController());
  // void toggleFavoriteStatus() {
  //   isFavorite.value = !isFavorite.value;
  //   // Logic to update favorite status in the backend
  // }
  void toggleFavoriteStatus() async {
    var productId = detailsData['data']['id'];
    var likeUrl = Uri.parse('${productlike_url}$productId');
    productController.LikeApiData(likeUrl, productId);
    isFavorite.value = !isFavorite.value;
  }

  void setMinMaxQty(Map data) {
    minQty = int.tryParse(data['product']['minimum_qty'].toString()) ?? 1;
    maxQty = int.tryParse(data['product']['maximum_qty'].toString()) ?? 1;
    quantity = minQty; // ✅ default minimum qty
    update();
  }

  ///
  void updateQuantity(bool isIncrease) {
    if (isIncrease) {
      if (quantity >= maxQty) {
        toastMsg(
          "You can add maximum $maxQty items",
        false);
        return;
      }
      quantity++;
    } else {
      if (quantity <= minQty) {
        toastMsg(
          "You must add at least $minQty item",
        false);
        return;
      }
      quantity--;
    }
    update();
  }


  GetProductDetails(url) async {
    print('inside getproductDetails');
    detailsLoader(true);
    try {
      var response = await ApiBaseHelper().getAPICall(url, true);
      detailsData = jsonDecode(response.body);
      print("inside product detail controller $detailsData");
      if (response.statusCode == 200) {
        if (detailsData['status'] == true) {
          indexColorList.clear();
          print(" Food Details .... 4");
          print(" Food Details .... 5");
          productdetail.value = detailsData['data'];
          setMinMaxQty(detailsData['data']); // ✅ actual API data
          print('inside product detail api ${productdetail.value}');
          print('inside product images ${detailsData['data']['product']['product_images']}');
         /* var images = detailsData['data']['product']['product_images'] as List;
          imagelist.assignAll(
              images.map((image) => image['image_url'].toString()).toList());*/
          mediaList.clear();

          /// Images First
          var images = detailsData['data']['product']['product_images'] as List;

          for (var image in images) {
            mediaList.add({
              "type": "image",
              "url": image["image_url"],
            });
          }

          /// Video Last
          String? videoUrl = detailsData['data']['product']['video_url'];

          if (videoUrl != null &&
              videoUrl.isNotEmpty &&
              videoUrl != "null") {
            mediaList.add({
              "type": "video",
              "url": videoUrl,
            });
          }

          isFavorite.value = detailsData['data']['is_liked'] ?? false;
          print('inside image list: $mediaList');
          detailsLoader(false);
          update();
          refresh();
        }
      } else if (response.statusCode == 404) {
        detailsData = jsonDecode(response.body);
        var msg = detailsData['message'];
        toastMsg(msg.toString(), false);
        detailsLoader(false);
        update();
        refresh();
      } else {
        var msg = detailsData['message'];
        toastMsg(msg.toString(), false);
        detailsLoader(false);
        update();
        refresh();
      }
    } catch (e) {
      print(' DashBoard in Catch =:.:= ${e}');
      detailsLoader(false);
      update();
    }
  }

  void LikeApiData(Uri likeUrl, int productIndex) async {
    islikeLoader(true);
    try {
      var response = await ApiBaseHelper().getAPICall(likeUrl, true);
      // if(response.statusCode==200){
      //   print('inside response 200 ');
      // }

      // DashBoardData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // print("categoryIndex...."+categoryIndex.toString());
        print("inside productIndex...." + productIndex.toString());
        // productList[productIndex]['is_liked'] = !productList[productIndex]['is_liked'];

        update();
        //await isLikeProduct(productIndex);
      } else {
        // var msg = DashBoardData['message'];
        // toastMsg(msg.toString(),false);
        // DashBoardLoading(false);
        update();
        refresh();
      }
    } catch (e) {
      print(' DashBoard in Catch =:.:= ${e}');
      islikeLoader(false);
      update();
    }
  }
}
