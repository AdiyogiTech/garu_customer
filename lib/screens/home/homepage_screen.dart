import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/helper_widget/location_label.dart';
import 'package:garu_customer/screens/add_to_cart/addto_cart_controller.dart';
import 'package:garu_customer/screens/add_to_cart/cart_count_controll.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/home/dashboard_controller.dart';
import 'package:garu_customer/screens/product/product.dart';
import 'package:garu_customer/screens/product_details/product_detail_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constant/api.dart';
import '../../helper_widget/imageShimmer.dart';
import '../../helper_widget/video_widget.dart';
import '../auctions/auction_detail_screen.dart';
import '../location/location_screen.dart';
import '../location/trackinlocationController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static bool _hasShownLocationSheet = false;
  final CarouselSliderController videoCarouselController =
      CarouselSliderController();

  int currentVideo = 0;
  int currentIndex = 0;
  var homeController = Get.find<HomeController>();
  CartCountController cartCountController = Get.put(CartCountController());
  AddCartController addCartController = Get.put(AddCartController());
  Map<int, String> selectedAttributes = {};
  Map<int, String> selectedAttributeIds = {};
  String attributeIds = '';
  Map<int, int> productQuantities = {};
  var area_id;

  // Animation controllers for shimmer
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    // Initialize shimmer animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // area_id = location_data['data']['area_id'];
    // print("area_id...." + area_id.toString());
    call_dashboard();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCartCount();
      homeController.getHistoricalCities();
    });

/*    call_dashboard();
    getCartCount();
    homeController.getHistoricalCities();*/
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (!_hasShownLocationSheet) {
          _hasShownLocationSheet = true;
          checkLocationOnStartup();
        }
      },
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // area_id = location_data['data']['area_id'];
    await call_dashboard(); // dashboard data reload
    getCartCount(); // cart count refresh
    setState(() {});
  }

  Future<void> checkLocationOnStartup() async {
    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      showLocationDialog();
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      showLocationDialog();
      return;
    }

    // Check GPS after permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    await Get.find<GetCurrentLocationController>().getPositionData();

    final controller = Get.find<GetCurrentLocationController>();

    var body = jsonEncode({
      "pincode": controller.address_pincode.value,
    });

    await Get.find<LooocationController>()
        .SetLocation(Uri.parse(location_url), body, false);
  }

  void showLocationDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 60),
            const SizedBox(height: 15),
            const Text(
              "Enable your location",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Allow location access to automatically detect your delivery area.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Not Now"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back(); // BottomSheet close

                      LocationPermission permission =
                          await Geolocator.requestPermission();

                      if (permission == LocationPermission.always ||
                          permission == LocationPermission.whileInUse) {
                        await checkLocationOnStartup();
                      } else if (permission ==
                          LocationPermission.deniedForever) {
                        Get.snackbar(
                          "Permission Required",
                          "Please enable location permission from Settings.",
                        );

                        await Geolocator.openAppSettings();
                      }
                    },
                    child: const Text("Allow"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      isDismissible: true,
    );
  }

  call_dashboard() async {
    var homeUrl = Uri.parse(home_url);
    print("homeUrl...." + homeUrl.toString());
    await homeController.GetHomeData(homeUrl);
    var profileUrl = Uri.parse(profile_url);
    // await profileController.GetProfile(profileUrl);
  }

  getCartCount() {
    var CartCountUrl = Uri.parse(cartcount_url);
    var cartCountBody =
        jsonEncode({'session': Environment.deviceid.toString()});
    print("CartCountUrl---->>>" + CartCountUrl.toString());
    print("cartCountBody---->>>" + cartCountBody.toString());
    cartCountController.CartCountUpdateApi(
        cartcount_url, Environment.deviceid.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primarylogin.withOpacity(0.11),
      body: GetBuilder<HomeController>(builder: (homeController) {
        if (homeController.DashBoardLoading.value) {
          return _buildLoadingShimmer(size);
        }

        var bannerList = (homeController.home_list['count']?['banner'] ?? [])
            .where((e) => e != null && e.toString().isNotEmpty)
            .toList();

        var footerBannerList =
            (homeController.home_list['count']?['footerBanners'] ?? [])
                .where((e) => e != null && e.toString().isNotEmpty)
                .toList();

        return RefreshIndicator(
          color: primary,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Location
                      const LocationLabel(),

                      SizedBox(
                        height: 15,
                      ),

                      ///banner
                      if (bannerList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: SizedBox(
                            height: size.height * 0.15,
                            child: CarouselSlider.builder(
                              itemCount: bannerList.length,
                              itemBuilder: (context, index, i) {
                                String imageName = bannerList[index].toString();
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(imageName),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: size.height * 0.15,
                                autoPlay: true,
                                viewportFraction: 0.92,
                                enlargeCenterPage: true,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                              ),
                            ),
                          ),
                        ),

                      /// Category Section
                      _buildCategorySection(size, homeController),

                      /// Offers Section
                      if (homeController.home_list['count'] != null &&
                          homeController.home_list['count']['offer'] != null &&
                          homeController.home_list['count']['offer'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: _buildOffersSection(size, homeController),
                        ),

                      if (homeController.home_list['count']['activeAuctions'] !=
                          null)
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: _buildAuctionSection(size, homeController),
                        ),

                      /// Products Section
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: _buildProductsSection(size, homeController),
                      ),

                      ///banner
                      if (footerBannerList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: SizedBox(
                            height: size.height * 0.18,
                            child: CarouselSlider.builder(
                              itemCount: footerBannerList.length,
                              itemBuilder: (context, index, i) {
                                String imageName =
                                    footerBannerList[index].toString();
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(imageName),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: size.height * 0.18,
                                autoPlay: true,
                                viewportFraction: 0.92,
                                enlargeCenterPage: true,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                              ),
                            ),
                          ),
                        ),

                      if (homeController.home_list['count']['video_ads'] !=
                              null &&
                          homeController
                              .home_list['count']['video_ads'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: _buildVideoAdvertisementSection(
                            size,
                            homeController,
                          ),
                        ),

                      if (homeController.historicalData.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: _buildHistoricalSection(size, homeController),
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLoadingShimmer(Size size) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Location
          Padding(
            padding: const EdgeInsets.all(16),
            child: shimmerBox(
              height: 45,
              width: double.infinity,
              radius: 15,
            ),
          ),

          /// Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: shimmerBox(
              height: size.height * .16,
              width: double.infinity,
              radius: 20,
            ),
          ),

          const SizedBox(height: 25),

          /// Categories
          shimmerHeader(),

          const SizedBox(height: 15),

          SizedBox(
            height: 55,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => shimmerBox(
                width: 120,
                height: 50,
                radius: 30,
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: 5,
            ),
          ),

          const SizedBox(height: 30),

          /// Offers
          shimmerHeader(),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: shimmerBox(
              height: size.height * .15,
              width: double.infinity,
              radius: 18,
            ),
          ),

          const SizedBox(height: 30),

          /// Auctions
          shimmerHeader(),

          const SizedBox(height: 15),

          SizedBox(
            height: size.height * .35,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => shimmerAuctionCard(size),
            ),
          ),

          const SizedBox(height: 30),

          /// Products
          shimmerHeader(),

          const SizedBox(height: 15),

          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: .58,
            ),
            itemBuilder: (_, __) => shimmerProductCard(size),
          ),

          const SizedBox(height: 30),

          /// Video Section
          shimmerHeader(),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: shimmerBox(
              height: size.height * .22,
              width: double.infinity,
              radius: 18,
            ),
          ),

          const SizedBox(height: 30),

          /// Historical
          shimmerHeader(),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                shimmerBox(
                  height: size.height * .18,
                  width: double.infinity,
                  radius: 16,
                ),
                const SizedBox(height: 12),
                shimmerBox(height: 14, width: double.infinity),
                const SizedBox(height: 8),
                shimmerBox(height: 14, width: double.infinity),
                const SizedBox(height: 8),
                shimmerBox(height: 14, width: size.width * .7),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget shimmerBox({
    required double height,
    required double width,
    double radius = 10,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget shimmerHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          shimmerBox(height: 20, width: 120),
          shimmerBox(height: 18, width: 60),
        ],
      ),
    );
  }

  Widget shimmerProductCard(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            shimmerBox(
              height: size.height * .14,
              width: double.infinity,
              radius: 20,
            ),
            const SizedBox(height: 10),
            shimmerBox(height: 14, width: 120),
            const SizedBox(height: 8),
            shimmerBox(height: 10, width: 70),
            const SizedBox(height: 8),
            shimmerBox(height: 14, width: 80),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: shimmerBox(
                height: 36,
                width: double.infinity,
                radius: 25,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget shimmerAuctionCard(Size size) {
    return Container(
      width: size.width * .52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            shimmerBox(
              height: size.height * .14,
              width: double.infinity,
              radius: 18,
            ),
            const SizedBox(height: 10),
            shimmerBox(height: 16, width: 120),
            const SizedBox(height: 8),
            shimmerBox(height: 12, width: double.infinity),
            const SizedBox(height: 6),
            shimmerBox(height: 12, width: 100),
            const Spacer(),
            shimmerBox(height: 35, width: 90, radius: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      {required String title,
      required bool showViewButton,
      VoidCallback? onTap,
      required String image,
      required double scale}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*   Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),*/

              Image.asset(
                image,
                scale: scale,
                color: primarylogin,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          if (showViewButton)
            GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: primarylogin,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: primarylogin,
                    size: 10,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(Size size, HomeController homeController) {
    return Column(
      children: [
        _buildSectionHeader(
          title: 'Category',
          showViewButton: true,
          image: 'assets/images/leaves.png',
          scale: 3,
          onTap: () {
            Get.offAll(BottomBar(
              bottomindex: 0,
            ));
            setState(() {});
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: size.height * 0.07,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            itemCount: homeController.home_list['count']['categories'].length,
            itemBuilder: (context, index) {
              var categoryData =
                  homeController.home_list['count']['categories'][index] ?? [];
              return GestureDetector(
                onTap: () {
                  var catid = categoryData['id'];
                  var catName = categoryData['name'];
                  print("our cat id--->>>" + catid.toString());
                  print("our cat name--->>>" + catName.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Product(
                        catId: catid,
                        name: catName,
                        CatData: homeController.home_list['count']
                            ['categories'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: size.width * 0.35,
                  padding: EdgeInsets.only(left: 5, right: 10),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(colors: [
                      primarylogin.withOpacity(0.5),
                      primarylogin.withOpacity(0.7),
                      primarylogin.withOpacity(0.9)
                    ]),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            categoryData['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            // ✅ full fill

                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;

                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },

                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.category_outlined,
                                  color: primary.withOpacity(0.5),
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // SizedBox(width: 8,),
                      Expanded(
                        child: Text(
                          categoryData['name'].toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOffersSection(Size size, HomeController homeController) {
    return Column(
      children: [
        _buildSectionHeader(
            title: 'Offers',
            showViewButton: false,
            image: 'assets/images/gift.png',
            scale: 3.0),
        const SizedBox(height: 16),
        SizedBox(
          height: size.height * 0.15,
          child: CarouselSlider.builder(
            itemCount: homeController.home_list['count']['offer'].length,
            itemBuilder: (context, index, realIndex) {
              final offer = homeController.home_list['count']['offer'][index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(offer['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: size.height * 0.15,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.92,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuctionSection(
    Size size,
    HomeController controller,
  ) {
    final List auctions =
        homeController.home_list['count']['activeAuctions'] ?? [];

    if (auctions.isEmpty) {
      return const SizedBox.shrink();
    }

    String formatDateTime(String date) {
      try {
        final DateTime dateTime = DateTime.parse(date);
        return DateFormat("dd MMM yyyy hh:mm a").format(dateTime);
      } catch (e) {
        return date;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            title: "The Garu Vault",
            showViewButton: true,
            image: 'assets/images/lighting.png',
            scale: 3.0,
            onTap: () {
              Get.offAll(BottomBar(
                bottomindex: 1,
              ));
            }),
        const SizedBox(height: 15),
        SizedBox(
          height: size.height < 700 ? size.height * 0.38 : size.height * 0.35,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: auctions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = auctions[index];

              Color statusColor;

              switch (item["phase"].toString()) {
                case "live":
                  statusColor = Colors.green;
                  break;
                case "upcoming":
                  statusColor = Colors.orange;
                  break;
                default:
                  statusColor = Colors.red;
              }

              return Container(
                width: size.width * 0.52,
                height:
                    size.height < 700 ? size.height * 0.38 : size.height * 0.35,
                margin: const EdgeInsets.only(right: 12),
                // padding: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                            child: Image.network(
                              item["main_image"],
                              width: double.infinity,
                              height: size.height * 0.14,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return imageShimmer(
                                  height: size.height * 0.14,
                                  width: double.infinity,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 14,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                              ),
                              child: Text(
                                item["phase"].toString().toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TITLE
                                Text(
                                  item["title"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                /// START DATE
                                Row(
                                  children: [
                                    Text(
                                      'Start:',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        formatDateTime(item["start_at"]),
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                /// END DATE
                                Row(
                                  children: [
                                    Text(
                                      'End:',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        formatDateTime(item["end_at"]),
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                Row(
                                  children: [
                                    Text(
                                      'Current bid:',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        "₹${item["current_highest_bid"]} (${item['total_bids']} bids)",
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                Divider(
                                  color: Colors.grey.shade300,
                                ),

                                /// PRICE ROW
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Entry Fee",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "₹${item["participation_fee"]}",
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(AuctionDetailScreen(
                                          auctionId: item['id'],
                                        ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff2E7D32),
                                              Color(0xff43A047),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: const Text(
                                            "View",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection(Size size, HomeController homeController) {
    return Column(
      children: [
        _buildSectionHeader(
            title: 'Product',
            showViewButton: false,
            image: 'assets/images/box.png',
            scale: 2.5),
        // const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: homeController.home_list['count']['categories'].length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, categoryIndex) {
              final category = homeController.home_list['count']['categories']
                  [categoryIndex];
              print('category>>>$category');

              if (category['products'].isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4, bottom: 15, top: 15, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: primary2,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            category['name'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(Product(
                                catId: category['id'],
                                name: category['name'].toString(),
                                CatData: homeController.home_list['count']
                                    ['categories']));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  color: primarylogin,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: primarylogin,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.57,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: category['products'].length,
                    itemBuilder: (context, productIndex) {
                      final product = category['products'][productIndex];

                      // Product attributes logic
                      List<dynamic> attributesList =
                          product['vendor_product_attributes'] ?? [];
                      List<String> weightOptions = [];
                      Map<String, String> weightOptionsIdMap = {};

                      if (attributesList.isNotEmpty) {
                        for (var attribute in attributesList) {
                          var details =
                              attribute['attributes_details'] as List<dynamic>;
                          var attributeId = attribute['attribute_id'] as String;
                          if (details.isNotEmpty) {
                            String formattedAttribute = details.join(', ');
                            weightOptions.add(formattedAttribute);
                            weightOptionsIdMap[formattedAttribute] =
                                attributeId;
                          }
                        }
                      }
                      weightOptions = weightOptions.toSet().toList();

                      if (!selectedAttributes.containsKey(product['id']) &&
                          weightOptions.isNotEmpty) {
                        selectedAttributes[product['id']] = weightOptions.first;
                        String firstAttribute = weightOptions.first;
                        attributeIds = weightOptionsIdMap[firstAttribute]!;
                        print('inside attrubutes Id $attributeIds');
                      }

                      int minQty = product['product_minimum_qty'] ?? 1;
                      int maxQty = product['product_maximum_qty'] ?? 999;

                      if (!productQuantities.containsKey(product['id'])) {
                        productQuantities[product['id']] = minQty;
                      }

                      return _buildProductCard(
                          size,
                          product,
                          categoryIndex,
                          productIndex,
                          weightOptions,
                          weightOptionsIdMap,
                          minQty,
                          maxQty,
                          homeController);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    Size size,
    dynamic product,
    int categoryIndex,
    int productIndex,
    List<String> weightOptions,
    Map<String, String> weightOptionsIdMap,
    int minQty,
    int maxQty,
    HomeController homeController,
  ) {
    List<dynamic> attributesList = product['vendor_product_attributes'] ?? [];

    // ✅ DEFAULT PRICE + MRP
    double displayPrice = 0.0;
    double mrp = 0.0;

    if (attributesList.isNotEmpty) {
      // default first attribute
      var selectedAttr = attributesList.first;

      displayPrice = double.tryParse(selectedAttr['price'].toString()) ?? 0.0;

      mrp = double.tryParse(selectedAttr['mrp'].toString()) ?? 0.0;
    } else {
      // no attribute case
      displayPrice = double.tryParse(product['price'].toString()) ?? 0.0;

      mrp = double.tryParse(product['product_mrp']?.toString() ?? '') ?? 0.0;
    }
    double rating =
        double.tryParse(product['avg_rating']?.toString() ?? '') ?? 0.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              GestureDetector(
                onTap: () async {
                  Get.to(
                    ProductDetails(
                      product_id: product['id'],
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    height: size.height * 0.14,
                    width: double.infinity,
                    color: Colors.grey[50],
                    child: Image.network(
                      product['main_image'],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return imageShimmer(
                          height: size.height * 0.14,
                          width: double.infinity,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Product Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    SizedBox(
                      height: size.height * 0.05,
                      child: Text(
                        product['product_name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Rating
                    Row(
                      children: [
                        /*  ...List.generate(5, (index) {
                          double rating = double.parse(
                            product['avg_rating'].toString() == "null"
                                ? "0.0"
                                : product['avg_rating'].toString(),
                          );
                          return Icon(
                            Icons.star,
                            color: index < rating
                                ? Colors.amber
                                : Colors.grey[300],
                            size: 11,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          "(${product['avg_rating'].toString() == "null" ? "0.0" : double.parse(product['avg_rating'].toString()).toStringAsFixed(1)})",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 9,
                          ),
                        ),*/

                        Container(
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    Icons.star,
                                    color: index < rating.floor()
                                        ? Colors.amber
                                        : Colors.grey[300],
                                    size: 10,
                                  );
                                }),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "${rating.toStringAsFixed(1)}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (weightOptions.isNotEmpty)
                          Container(
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedAttributes[product['id']],
                                selectedItemBuilder: (context) {
                                  return weightOptions.map((e) {
                                    return Text(
                                      e,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 9),
                                    );
                                  }).toList();
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedAttributes[product['id']] =
                                        newValue!;
                                    attributeIds =
                                        weightOptionsIdMap[newValue]!;

                                    // ✅ FIND SELECTED ATTRIBUTE DATA
                                    var selectedAttr =
                                        attributesList.firstWhere(
                                      (e) => e['attribute_id'] == attributeIds,
                                      orElse: () => attributesList.first,
                                    );

                                    displayPrice = double.tryParse(
                                            selectedAttr['price'].toString()) ??
                                        0.0;

                                    mrp = double.tryParse(
                                            selectedAttr['mrp'].toString()) ??
                                        0.0;
                                  });
                                },
                                items: weightOptions.map((option) {
                                  return DropdownMenuItem(
                                    value: option,
                                    child: Text(
                                      option,
                                      style: const TextStyle(fontSize: 9),
                                    ),
                                  );
                                }).toList(),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Price and Attribute
                    Row(
                      children: [
                        if (product['price'] != null)
                          Text(
                            '₹${product['price']}',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (mrp > 0 && mrp != displayPrice)
                          Text(
                            '₹${mrp.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),

                    const Divider(height: 16),

                    // Quantity and Add to Cart
                    Row(
                      children: [
                        /// Quantity Selector
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              /// Minus Button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (productQuantities[product['id']]! >
                                        minQty) {
                                      productQuantities[product['id']] =
                                          productQuantities[product['id']]! - 1;
                                    } else {
                                      toastMsg(
                                          "Minimum quantity is $minQty", false);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),

                              /// Quantity Text
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  "${productQuantities[product['id']]}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),

                              /// Plus Button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (productQuantities[product['id']]! <
                                        maxQty) {
                                      productQuantities[product['id']] =
                                          productQuantities[product['id']]! + 1;
                                    } else {
                                      toastMsg(
                                          "Maximum quantity allowed is $maxQty",
                                          false);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 24,
                                  width: 24,
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

                        const SizedBox(width: 4),

                        /// Add to Cart Button
                        GestureDetector(
                          onTap: product['status'] == 0
                              ? null
                              : () {
                                  var addtocartUrl = Uri.parse(addtocart_url);
                                  var addtocartBody = jsonEncode({
                                    'product_id': product['id'].toString(),
                                    'quantity': productQuantities[product['id']]
                                        .toString(),
                                    'attribute_id': attributeIds,
                                    'session_id':
                                        Environment.deviceid.toString(),
                                  });

                                  print("addtocartBody ---> $addtocartBody");

                                  addCartController.AddtoCartApi(
                                      addtocartUrl, addtocartBody);
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: product['status'] == 0
                                  ? Colors.grey
                                  : primary2,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),

          // Favorite Button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () async {
                var likeUrl =
                    Uri.parse(productlike_url + "${product['id'].toString()}");
                homeController.LikeApiData(
                    likeUrl, categoryIndex, productIndex);
                bool checklogin = Environment.appuserlog;
                print("checklogin..." + checklogin.toString());
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite,
                  color: homeController.home_list['count']['categories']
                                  [categoryIndex]['products'][productIndex]
                              ['is_liked'] ==
                          false
                      ? Colors.grey[400]
                      : Colors.red,
                  size: 12,
                ),
              ),
            ),
          ),

          Positioned(
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: product['status'] == 0 ? Colors.red : Colors.green,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(4)),
              ),
              child: Text(
                product['status'] == 0 ? 'Out Of Stock' : 'In Stock',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // New Ribbon
          if (product['product_is_new'] == 1)
            Positioned(
              top: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(4)),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoAdvertisementSection(
    Size size,
    HomeController homeController,
  ) {
    final videos = homeController.home_list['count']['video_ads'];
    print("========== VIDEO ADS ==========");

    if (videos is List) {
      for (int i = 0; i < videos.length; i++) {
        print("Video ${i + 1}:");
        print("video_url      => ${videos[i]['video_url']}");
        print("learn_more_url => ${videos[i]['redirect_url']}");
        print("-------------------------------");
      }
    }

    print("===============================");
    final videoWidth = size.width - 30;
    final videoHeight = videoWidth * 9 / 16;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Text(
                "Garu Spotlight",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primarylogin,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Watch our latest promotions and offers",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSmoothIndicator(
                activeIndex: currentVideo,
                count: videos.length,
                effect: WormEffect(
                  activeDotColor: primary,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider.builder(
                    carouselController: videoCarouselController,
                    itemCount: videos.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: primary.withOpacity(.11),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: primary.withOpacity(.25),
                          ),
                        ),
                        child: ProductVideoWidget(
                          videoUrl: videos[index]["video_url"],
                          learnMoreUrl:
                              videos[index]["redirect_url"]?.toString(),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: videoHeight,

                      autoPlay: false,

                      // Important
                      enlargeCenterPage: false,
                      viewportFraction: 1.0,

                      padEnds: false,

                      onPageChanged: (index, reason) {
                        setState(() {
                          currentVideo = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    left: 5,
                    child: GestureDetector(
                      onTap: () {
                        videoCarouselController.previousPage();
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        videoCarouselController.nextPage();
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoricalSection(
    Size size,
    HomeController homeController,
  ) {
    // int currentIndex = 0;
    List images = homeController.historicalData["images"] ?? [];
    String? videoUrl = homeController.historicalData["video_url"];
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        /// Background Image
        Positioned(
          top: -35,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/historical_bg.png',
            width: size.width * 0.1,
            height: size.height * 0.22,
            fit: BoxFit.contain,
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),

            /// Title
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "Know About ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: "Your City",
                    style: TextStyle(color: primary, fontSize: 22),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// City Name
            GestureDetector(
              onTap: () {
                _showCityDialog(homeController);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primarylogin.withOpacity(.08),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: primarylogin,
                      size: 18,
                    ),
                    Text(
                      homeController.historicalData["city_name"] ?? "",
                      style: TextStyle(
                        color: primarylogin,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: primarylogin,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image
                    CarouselSlider.builder(
                      itemCount: images.length + (videoUrl != null ? 1 : 0),
                      itemBuilder: (context, index, realIndex) {
                        /// Images
                        if (index < images.length) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              images[index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          );
                        }

                        /// Last item Video
                        return ProductVideoWidget(
                          videoUrl: videoUrl!,
                        );
                      },
                      options: CarouselOptions(
                        height: size.height * .25,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        autoPlay: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: currentIndex,
                        count: images.length + (videoUrl != null ? 1 : 0),
                        effect: WormEffect(
                          activeDotColor: primary,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    HtmlWidget(
                      homeController.historicalData["content"] ?? "",
                      onTapUrl: (_) => false,
                      customStylesBuilder: (element) {
                        if (element.localName == "a") {
                          return {
                            "color": "#333333",
                            "text-decoration": "none",
                          };
                        }
                        return null;
                      },
                      textStyle: const TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCityDialog(HomeController controller) {
    Map<String, dynamic>? selectedCity;
    bool isExpanded = false;
    TextEditingController searchController = TextEditingController();
    List<Map<String, dynamic>> filteredCities = [];
    FocusNode focusNode = FocusNode();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          elevation: 8,
          backgroundColor: Colors.white,
          child: StatefulBuilder(
            builder: (context, setState) {
              // Initialize filtered cities when dialog opens
              if (searchController.text.isEmpty &&
                  controller.historicalCities.isNotEmpty) {
                filteredCities = List.from(controller.historicalCities);
              }

              void filterCities(String query) {
                final search = query.trim().toLowerCase();

                setState(() {
                  /* if (search.isEmpty) {
                    filteredCities = List.from(controller.historicalCities);
                    return;
                  }*/

                  filteredCities = controller.historicalCities.where((city) {
                    final cityName =
                        (city["name"] ?? "").toString().trim().toLowerCase();

                    // Exact prefix match (letter by letter)
                    if (search.length > cityName.length) return false;

                    return cityName.substring(0, search.length) == search;
                  }).toList();
                });
                log("filterCities>>>>> ${filteredCities.toString()}");
              }

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  constraints: BoxConstraints(
                    maxHeight: isExpanded
                        ? MediaQuery.of(context).size.height * .85
                        : MediaQuery.of(context).size.height * .55,
                    maxWidth: 500,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header with Gradient Icon
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primarylogin.withOpacity(0.2),
                                  primarylogin.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.location_city,
                              color: primarylogin,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              "Select Historical City",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(8),
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                                color: Color(0xFF4A4A4A),
                              ),
                              onPressed: () {
                                focusNode.unfocus();
                                Navigator.pop(context);
                              },
                              splashRadius: 20,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Subtitle
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "Search and select a city to view historical weather data",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ),

                      /// Search Field with Expandable List
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Search Input Field
                          TextField(
                            controller: searchController,
                            focusNode: focusNode,
                            onTap: () {
                              setState(() {
                                isExpanded = true;
                              });
                            },
                            onChanged: (value) {
                              filterCities(value);
                              if (!isExpanded) {
                                setState(() {
                                  isExpanded = true;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Search for a city...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.grey.shade500,
                                size: 22,
                              ),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey.shade400,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        searchController.clear();
                                        filterCities('');
                                        setState(() {
                                          isExpanded = false;
                                        });
                                        focusNode.unfocus();
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: primarylogin,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          /// Expandable City List - Fixed layout
                          if (isExpanded) ...[
                            const SizedBox(height: 12),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * .45,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: filteredCities.isEmpty &&
                                        searchController.text.isNotEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.search_off_rounded,
                                                size: 48,
                                                color: Colors.grey.shade400,
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                "No cities found",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                searchController.text.isNotEmpty
                                                    ? 'No city starts with "${searchController.text}"'
                                                    : "Start typing to search for cities",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Try searching with a different name",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Scrollbar(
                                        // thumbVisibility: true,
                                        thickness: 4,
                                        radius: const Radius.circular(10),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          itemCount: filteredCities.length,
                                          separatorBuilder: (context, index) =>
                                              Divider(
                                            height: 1,
                                            color: Colors.grey.shade100,
                                            indent: 16,
                                            endIndent: 16,
                                          ),
                                          itemBuilder: (context, index) {
                                            final city = filteredCities[index];
                                            final isSelected =
                                                selectedCity?["city_id"] ==
                                                    city["city_id"];

                                            return ListTile(
                                              leading: CircleAvatar(
                                                radius: 18,
                                                backgroundColor: isSelected
                                                    ? primarylogin
                                                        .withOpacity(0.1)
                                                    : Colors.grey.shade100,
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: isSelected
                                                      ? primarylogin
                                                      : Colors.grey.shade400,
                                                  size: 18,
                                                ),
                                              ),
                                              title: Text(
                                                city["name"] ?? "",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                  color: isSelected
                                                      ? primarylogin
                                                      : const Color(0xFF1A1A2E),
                                                ),
                                              ),
                                              trailing: isSelected
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration: BoxDecoration(
                                                        color: primarylogin,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    )
                                                  : null,
                                              onTap: () {
                                                setState(() {
                                                  selectedCity = city;
                                                  searchController.text =
                                                      city["name"] ?? "";
                                                  isExpanded = false;
                                                  filteredCities = List.from(
                                                      controller
                                                          .historicalCities);
                                                });
                                                focusNode.unfocus();
                                              },
                                              hoverColor: primarylogin
                                                  .withOpacity(0.05),
                                              splashColor:
                                                  primarylogin.withOpacity(0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      /// Spacer - reduces when expanded
                      if (!isExpanded) const Spacer(),

                      /// Selected City Preview (if selected)
                      if (selectedCity != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: primarylogin.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: primarylogin.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: primarylogin,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Selected City",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      selectedCity!["name"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1A2E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      /// Search Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarylogin,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 0,
                            ),
                            disabledBackgroundColor: Colors.grey.shade300,
                          ),
                          icon: Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: selectedCity != null
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                          ),
                          label: Text(
                            selectedCity != null
                                ? "Search Historical Data"
                                : "Select a City First",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              color: selectedCity != null
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.7),
                            ),
                          ),
                          onPressed: selectedCity == null
                              ? null
                              : () async {
                                  if (selectedCity == null) {
                                    toastMsg("Please select city", false);
                                    return;
                                  }
                                  focusNode.unfocus();
                                  Navigator.pop(context);
                                  await controller.getHistoricalData(
                                    cityId: selectedCity!["city_id"],
                                  );
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
