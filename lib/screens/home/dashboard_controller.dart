import 'package:garu_customer/constant/api.dart';
import 'package:get/get.dart';

import 'dart:convert';

import 'package:garu_customer/constant/ApiBaseHelper.dart';

import '../constant/validations.dart';

class HomeController extends GetxController{
  var historicalLoading = false.obs;
  Map<String, dynamic> historicalData = {};

  var DashBoardLoading = false.obs;
  var DashBoardData;
  var islikeLoader = false.obs;
  Map <String,dynamic> home_list = Map();

  var historicalCitiesLoading = false.obs;
  List<Map<String, dynamic>> historicalCities = [];

  GetHomeData(url) async{
    DashBoardLoading(true);
    try{
print("Home Url: $url");
      var response = await ApiBaseHelper().getAPICall(url, true);
      DashBoardData = jsonDecode(response.body);
      print('inside dashboardData $DashBoardData');
      if(response.statusCode == 200){
        home_list.clear();
        if(DashBoardData['status'] == true){

          home_list.addAll(DashBoardData);

          print("home_list....."+home_list.toString());

          DashBoardLoading(false);
          update();
          refresh();
        }
      }else{
        var msg = DashBoardData['message'];
        toastMsg(msg.toString(),false);
        DashBoardLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      print(' DashBoard in Catch =:.:= ${e}');
      DashBoardLoading(false);
      update();
    }
  }


  LikeApiData(url,categoryIndex,productIndex) async{
    islikeLoader(true);
    try{

      // var response = await ApiBaseHelper().postAPICall(url, true);
      var response = await ApiBaseHelper().getAPICall(url,true);
      // DashBoardData = jsonDecode(response.body);
      if(response.statusCode == 200){
        print("categoryIndex...."+categoryIndex.toString());
        print("productIndex...."+productIndex.toString());
        print('inside like api data');
        var responseData = jsonDecode(response.body);

       // home_list['count']['categories'][categoryIndex]['products'][productIndex]['is_liked'] = responseData['is_liked'];

        bool isLiked = home_list['count']['categories'][categoryIndex]['products'][productIndex]['is_liked'];
        home_list['count']['categories'][categoryIndex]['products'][productIndex]['is_liked'] = !isLiked;
        update();
      //  await isLikeProduct(categoryIndex,productIndex);

      }else{
        // var msg = DashBoardData['message'];
        // toastMsg(msg.toString(),false);
        // DashBoardLoading(false);
        update();
        refresh();
      }
    }
    catch (e){
      print(' DashBoard in Catch =:.:= ${e}');
      islikeLoader(false);

      update();
    }
  }


  isLikeProduct(categoryIndex,productIndex){
    // log("isLikeProduct");
    // log("isLikeProduct==before ${home_list['data']['fearure_products'][categoryIndex]['products'][productIndex]['product_is_liked']}");
    if(home_list['count']['categories'][categoryIndex]['products'][productIndex]['product_is_liked']==1){
      home_list['count']['categories'][categoryIndex]['products'][productIndex]['product_is_liked']=0;
    }else{
      home_list['count']['categories'][categoryIndex]['products'][productIndex]['product_is_liked']=1;
    }
    update();
    // log("isLikeProduct==after ${home_list['data']['fearure_products'][categoryIndex]['products'][productIndex]['product_is_liked']}");
  }

  Future<void> getHistoricalData({
    String? cityName,
    int? cityId,
  }) async {
    historicalLoading(true);
    historicalData.clear();
    update();

    try {
      Uri url;

      if (cityId != null) {
        // Search by City ID
        url = Uri.parse("$historicalUrl?city_id=$cityId");
      } else {
        // Search by City Name
        url = Uri.parse(
          "$historicalUrl?city_name=${Uri.encodeComponent(cityName ?? "")}",
        );
      }

      print("Historical Url => $url");

      var response = await ApiBaseHelper().getAPICall(url, true);

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        historicalData.clear();
        historicalData.addAll(data["data"]);

        print("Historical Data => $historicalData");
      } else {
        // toastMsg(data["message"].toString(), false);
        print("Historical Data Error => ${data["message"].toString()}");
      }
    } catch (e) {
      print("Historical Error => $e");
    }

    historicalLoading(false);
    update();
  }

  Future<void> getHistoricalCities() async {
    historicalCitiesLoading(true);
    historicalCities.clear();
    update();

    try {
      var response = await ApiBaseHelper().getAPICall(
        Uri.parse(historicalCitiesUrl), // API URL
        true,
      );

      print("url>> $historicalCitiesUrl");
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        historicalCities = List<Map<String, dynamic>>.from(data["data"]);

        print("Historical Cities => $historicalCities");
      }
      else {
        // toastMsg(data["message"].toString(), false);
        print("historical data error>>>> ${data["message"].toString()}");
      }
    } catch (e) {
      print("Historical Cities Error => $e");
    }

    historicalCitiesLoading(false);
    update();
  }
}