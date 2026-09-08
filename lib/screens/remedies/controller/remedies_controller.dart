import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/ApiBaseHelper.dart';
import '../../../constant/api.dart';
import '../../constant/validations.dart';

class RemediesController extends GetxController {
  static const String preferredLanguageKey = "preferred_language";
  var loading = false.obs;
  List<Map<String, dynamic>> plans = [];
  var categoryLoading = false.obs;
  List categories = [];
  var articleLoading = false.obs;
  var articlePaginationLoading = false.obs;

  List articles = [];

  int articlePage = 1;
  int articleTotalPage = 1;
  int articleLimit = 10;

  bool get hasMoreArticles => articlePage < articleTotalPage;

  var subscriptionData = Rxn<Map<String, dynamic>>();
  var articleSubscription = Rxn<Map<String, dynamic>>();
  // Article Detail
  var articleDetailLoading = false.obs;
  var articleDetail = Rxn<Map<String, dynamic>>();

// Selected Language
  var selectedLanguage = "en".obs;

// Available Languages
  final availableLanguages = <Map<String, dynamic>>[].obs;

  var readHistoryLoading = false.obs;

  final RxList<Map<String, dynamic>> readHistory =
      <Map<String, dynamic>>[].obs;

  var aboutLoading = false.obs;
  var aboutData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadPreferredLanguage();
    getPlans();
    getCategories();
    getMySubscription();
  }

  Future<void> getPlans() async {
    loading.value = true;

    try {
      log("Plan Url => $remediesUrl/plans");

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse("$remediesUrl/plans"),
        true,
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == true) {
          plans.clear();

          // Convert data to List<Map<String, dynamic>>
          if (data["data"] is List) {
            for (var item in data["data"]) {
              plans.add(Map<String, dynamic>.from(item));
            }
          }

          log("Plans => ${plans.length} categories loaded");
          log("Plans data => ${plans}");
        } else {
          toastMsg(data["message"].toString(), false);
        }
      } else {
        toastMsg(data["message"].toString(), false);
      }
    } catch (e) {
      log("Error fetching plans: $e");
      toastMsg("Failed to load categories", false);
    }

    loading.value = false;
    update();
  }

  Future<Map<String,dynamic>?> subscribePlan(
      int planId,
      ) async {

    try{

      loading(true);

      var response = await ApiBaseHelper().postAPICall(

        Uri.parse("$remediesUrl/subscribe"),

        jsonEncode({

          "plan_id":planId,

        }),

        true,

      );

      loading(false);

      var data=jsonDecode(response.body);

      if(response.statusCode==200){

        if(data["status"]){
          toastMsg(
            data["message"].toString(),
            true,
          );
          return data;

        }

        toastMsg(data["message"].toString(),false);

        return null;

      }

      toastMsg(data["message"],false);

      return null;

    }catch(e){

      loading(false);

      toastMsg(e.toString(),false);

      return null;

    }

  }

  Future<bool> completePayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {

    try {

      loading(true);

      var response = await ApiBaseHelper().postAPICall(
        Uri.parse("$remediesUrl/complete-payment"),
        jsonEncode({
          "razorpay_order_id": orderId,
          "razorpay_payment_id": paymentId,
          "razorpay_signature": signature,
        }),
        true,
      );

      var data = jsonDecode(response.body);

      loading(false);

      if (response.statusCode == 200) {

        toastMsg(data["message"], true);

        return true;

      }

      toastMsg(data["message"], false);

      return false;

    } catch(e){

      loading(false);

      toastMsg(e.toString(), false);

      return false;

    }

  }

  Future<void> getMySubscription() async {
    try {
      loading(true);

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse("$remediesUrl/my-subscription"),
        true,
      );

      var data = jsonDecode(response.body);

      loading(false);

      if (response.statusCode == 200 && data["status"] == true) {
        if (data["data"] != null) {
          subscriptionData.value =
          Map<String, dynamic>.from(data["data"]);
        } else {
          subscriptionData.value = null;
        }

        log("My Subscription => ${subscriptionData.value}");
      } else {
        subscriptionData.value = null;
      }

      update();
    } catch (e) {
      loading(false);
      log("My Subscription Error => $e");
    }
  }

  Future<void> getCategories() async {

    categoryLoading(true);

    try {

      print("Categories Url => $remediesUrl/categories}");

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse("$remediesUrl/categories"),
        true,
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        if (data["status"] == true) {

          categories.clear();

          categories.addAll(data["data"]);

          log("Categories => ${data["data"]}");

        } else {

          toastMsg(data["message"].toString(), false);

        }

      } else {

        toastMsg(data["message"].toString(), false);

      }

    } catch (e) {

      print("Get Categories Error => $e");

    }

    categoryLoading(false);

    update();
  }

  Future<void> getArticles({
    required int categoryId,
    bool isRefresh = false,
  }) async {

    if (isRefresh) {
      articlePage = 1;
      articleTotalPage = 1;
      articles.clear();
      articleSubscription.value = null;
    }

    if (articlePage == 1) {
      articleLoading(true);
    } else {
      articlePaginationLoading(true);
    }

    try {

      String url =
          "$remediesUrl/articles?category_id=$categoryId&limit=$articleLimit&page=$articlePage";

      log("Articles Url => $url");

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse(url),
        true,
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {

        if (data["status"] == true) {

          articleTotalPage = data["totalPage"] ?? 1;

          if (articlePage == 1) {
            articles.clear();
          }

          articles.addAll(data["data"]);

          log("Articles Length => ${articles.length}");

          if (data["subscription"] != null) {
            articleSubscription.value =
            Map<String, dynamic>.from(data["subscription"]);
          } else {
            articleSubscription.value = null;
          }
          log("Subscription detail => ${data["subscription"]}");
        } else {

          toastMsg(data["message"].toString(), false);

        }

      } else {

        toastMsg(data["message"].toString(), false);

      }

    } catch (e) {

      log("Get Articles Error => $e");

    }

    articleLoading(false);
    articlePaginationLoading(false);

    update();
  }

  Future<void> loadMoreArticles({
    required int categoryId,
  }) async {

    if (articlePaginationLoading.value) return;

    if (articlePage >= articleTotalPage) return;

    articlePage++;

    await getArticles(
      categoryId: categoryId,
    );
  }

/*  Future<void> refreshArticles({
    required int categoryId,
  }) async {

    articlePage = 1;

    await getArticles(
      categoryId: categoryId,
      isRefresh: true,
    );
  }*/

  Future<void> refreshArticles({
    required int categoryId,
  }) async {

    // New category ke liye old category ka data immediately remove karo
    articlePage = 1;
    articleTotalPage = 1;

    articles.clear();

    // IMPORTANT:
    // Previous category ka subscription immediately remove karo.
    // Naye article API response se hi dobara set hoga.
    articleSubscription.value = null;

    articleLoading(true);

    update();

    await getArticles(
      categoryId: categoryId,
      isRefresh: false,
    );
  }

  // Method to refresh data
  Future<void> refreshPlans() async {
    await getPlans();
  }

  Future<void> getArticleDetail({
    required int articleId,
    String? language,
  }) async {
    articleDetailLoading(true);

    try {
      await loadPreferredLanguage();

      final lang = language ?? selectedLanguage.value;

      String url =
          "$remediesUrl/articles/$articleId?language=$lang";

      log("Article Detail Url => $url");

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse(url),
        true,
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == true) {
          articleDetail.value =
          Map<String, dynamic>.from(data["data"]);

          // Current Language
          selectedLanguage.value =
              data["data"]["language"] ?? lang;

          // Available Languages
          availableLanguages.clear();

          if (data["data"]["available_languages"] != null) {
            availableLanguages.assignAll(
              List<Map<String, dynamic>>.from(
                data["data"]["available_languages"],
              ),
            );
          }

          log("Article Detail => ${articleDetail.value}");
        } else {
          toastMsg(data["message"].toString(), false);
        }
      } else {
        toastMsg(data["message"].toString(), false);
      }
    } catch (e) {
      log("Get Article Detail Error => $e");
    }

    articleDetailLoading(false);
    update();
  }

  Future<void> changeArticleLanguage({
    required int articleId,
    required String language,
  }) async {

    if (selectedLanguage.value == language) return;

    selectedLanguage.value = language;

    /// Save preferred language
    await updatePreferredLanguage(
      language: language,
    );

    /// Load translated article
    await getArticleDetail(
      articleId: articleId,
      language: language,
    );
  }

  Future<void> savePreferredLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      preferredLanguageKey,
      language,
    );

    selectedLanguage.value = language;
  }

  Future<void> loadPreferredLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    selectedLanguage.value =
        prefs.getString(preferredLanguageKey) ?? "en";
  }

  Future<void> updatePreferredLanguage({
    required String language,
  }) async {
    try {
      var response = await ApiBaseHelper().postAPICall(
        Uri.parse("$remediesUrl/preferred-language"),
        jsonEncode({
          "language": language,
        }),
        true,
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == true) {
          await savePreferredLanguage(language);

          log("Preferred Language => ${data["data"]}");
          log("response>>> ${data['message']}");
        } else {
          toastMsg(data["message"].toString(), false);
        }
      } else {
        toastMsg(data["message"].toString(), false);
      }
    } catch (e) {
      log("Preferred Language Error => $e");
    }
  }

  Future<void> getReadHistory() async {

    try {

      readHistoryLoading(true);

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse("$remediesUrl/read-history"),
        true,
      );

      var data = jsonDecode(response.body);

      readHistoryLoading(false);

      if (response.statusCode == 200 &&
          data["status"] == true) {

        readHistory.clear();

        if (data["data"] is List) {
          readHistory.assignAll(
            (data["data"] as List)
                .map((item) => Map<String, dynamic>.from(item))
                .toList(),
          );
        }

        log("Read History => ${readHistory.length}");

      } else {

        readHistory.clear();

      }

      update();

    } catch (e) {

      readHistoryLoading(false);

      readHistory.clear();

      log("Read History Error => $e");

    }

  }

  Future<void> getAbout() async {
    aboutLoading(true);

    try {
      String url = remediesAboutUrl;

      log("About Url => $url");

      var response = await ApiBaseHelper().getAPICall(
        Uri.parse(url),
        true,
      );

      var data = jsonDecode(response.body);

      log("About Response => $data");

      if (response.statusCode == 200) {
        if (data["status"] == true) {
          if (data["data"] != null) {
            aboutData.value = Map<String, dynamic>.from(
              data["data"],
            );
          } else {
            aboutData.value = null;
          }

          log("About Data => ${aboutData.value}");
        } else {
          aboutData.value = null;

          toastMsg(
            data["message"].toString(),
            false,
          );
        }
      } else {
        aboutData.value = null;

        toastMsg(
          data["message"]?.toString() ?? "Something went wrong",
          false,
        );
      }
    } catch (e) {
      aboutData.value = null;

      log("Get About Error => $e");
    }

    aboutLoading(false);
    update();
  }
}