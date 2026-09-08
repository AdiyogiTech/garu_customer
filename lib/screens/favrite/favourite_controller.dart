/*
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

class FavouriteController extends GetxController {

  final favouriteLoading = false.obs;
  final likeLoader = false.obs;

  final favouriteProducts = <dynamic>[].obs;

  ScrollController favouriteScrollController = ScrollController();

  int page = 1;
  int limit = 10;
  int totalPage = 1;

  bool loadMore = false;

  Future<void> getFavourite({
    bool refresh = false,
  }) async {

    if(refresh){
      page = 1;
      favouriteProducts.clear();
    }

    favouriteLoading(page==1);

    var response =
    await ApiBaseHelper().getAPICall(
        Uri.parse("$get_favourite?page=$page&limit=$limit"),
        true);

    var data=jsonDecode(response.body);

    if(response.statusCode==200){

      totalPage=data["data"]["total_page"];

      favouriteProducts.addAll(
          data["data"]["products"]);

      update();
    }

    favouriteLoading(false);
  }

  void initPagination(){

    favouriteScrollController.addListener((){

      if(favouriteScrollController.position.pixels>=
          favouriteScrollController.position.maxScrollExtent-100){

        if(page<totalPage && !loadMore){

          loadMore=true;

          page++;

          getFavourite();

        }

      }

    });

  }

  Future<void> toggleFavourite(
      int index,
      int productId,
      ) async {

    likeLoader(true);

    var response=
    await ApiBaseHelper().getAPICall(
        Uri.parse("$productlike_url$productId"),
        true);

    if(response.statusCode==200){

      favouriteProducts.removeAt(index);

      update();

    }

    likeLoader(false);
  }
}*/
