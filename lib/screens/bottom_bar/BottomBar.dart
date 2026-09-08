import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/screens/Profile/profile_screen.dart';
import 'package:garu_customer/screens/add_to_cart/add_to_cart_screen.dart';
import 'package:garu_customer/screens/add_to_cart/cart_count_controll.dart';
import 'package:garu_customer/screens/auctions/auctions_screen.dart';
import 'package:garu_customer/screens/category/category_screen.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/drawer/drawer_screen.dart';
import 'package:garu_customer/screens/home/homepage_screen.dart';
import 'package:garu_customer/screens/notification/notification_screen.dart';
import 'package:garu_customer/screens/remedies/nuskhe_screen.dart';
import 'package:get/get.dart';

import '../constant/no_internet_screen.dart';
import '../notification/notification_controller.dart';

class BottomBar extends StatefulWidget {
  var bottomindex;

  BottomBar({super.key, this.bottomindex});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CartCountController cartCountController = Get.put(CartCountController());
  FloatingActionButtonLocation fabLocation =
      FloatingActionButtonLocation.centerDocked;
  int _currentIndexBnb = 2;
  Color fabBorderColor = primarylogin;

  // Animation controllers
  late AnimationController _cartAnimationController;
  late Animation<double> _cartPulseAnimation;

  /*List bodys = [
    CategoryPage(),
    // OrderHistory(),
    AuctionsScreen(),
    HomePage(),
    NuskheScreen(),
    Profile(),
  ];*/

  List<Widget> get bodys => [
        CategoryPage(
          onTabChange: (index) {
            setState(() {
              _currentIndexBnb = index;
            });
          },
        ),
        AuctionsScreen(),
        HomePage(),
        NuskheScreen(),
        Profile(),
      ];

  NotificationController notificationControler =
      Get.put(NotificationController());

  bool _isNoInternetShown = false;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void initState() {
    super.initState();

    log('Bottom init called');

    _currentIndexBnb = widget.bottomindex == null ? 2 : widget.bottomindex;

    getnotificationlistData();

    // Initialize cart animation
    _cartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _cartPulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _cartAnimationController,
        curve: Curves.elasticInOut,
      ),
    );

    // 🔥 INTERNET LISTENER
    startInternetListener();
  }

  getnotificationlistData() async {
    notificationControler.notificationListPage = 1;
    notificationControler.notificationListlimit = 100;
    await notificationControler.NotificationListApiCall(
        notificationControler.notificationSearchCtrl.text,
        '',
        notificationControler.notificationListPage,
        notificationControler.notificationListlimit);
    setState(() {});
    log('notifyListData==>' +
        notificationControler.notificationListData.toString());
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndexBnb = index;
    });
  }

  Future<bool> hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // void startInternetListener() {
  //   _connectivitySub =
  //       Connectivity().onConnectivityChanged.listen((result) async {
  //         bool internet = await hasInternet();
  //
  //         if (!internet && !_isNoInternetShown) {
  //           _isNoInternetShown = true;
  //           Get.offAll(() => NoInternetScreen());
  //         }
  //       });
  // }
  void startInternetListener() {
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      bool internet = await hasInternet();

      // Check if there's no internet connection
      bool hasNoInternet = results.contains(ConnectivityResult.none);

      // If no internet and we haven't shown the screen yet
      if ((!internet || hasNoInternet) && !_isNoInternetShown) {
        _isNoInternetShown = true;
        Get.offAll(() => NoInternetScreen());
      }
      // Optional: Handle when internet comes back
      else if ((internet && !hasNoInternet) && _isNoInternetShown) {
        _isNoInternetShown = false;
        // If you want to go back when internet returns
        // if (Get.currentRoute == '/NoInternetScreen') {
        //   Get.back();
        // }
      }
    });
  }

  @override
  void dispose() {
    _cartAnimationController.dispose();
    _connectivitySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }
        if (_currentIndexBnb != 2) {
          setState(() {
            _currentIndexBnb = 2;
          });
          return false;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primarylogin.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Icon(
                          Icons.exit_to_app_rounded,
                          size: 50,
                          color: primarylogin,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Do you want to exit?',
                          style: TextStyle(
                            color: primarylogin,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: primarylogin,
                                  elevation: 0,
                                  side: BorderSide(
                                      width: 1.5, color: primarylogin),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primarylogin,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () => exit(0),
                                child: const Text('Exit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
          return false;
        } // Prevent the default back button behavior
      },
      child: Scaffold(
        extendBody: true,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: size.height * 0.08,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Image.asset(
                  'assets/images/drawerIcon.png',
                  scale: 2,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          title: _buildAppBarTitle(),
          centerTitle: true,
          titleSpacing: 0,
          backgroundColor: primarylogin.withOpacity(0.11),
          elevation: 0,
          shadowColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              // color: primarylogin.withOpacity(0.11),
              /*   gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),*/
              boxShadow: [
                BoxShadow(
                    color: primarylogin.withOpacity(0.11),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                    blurStyle: BlurStyle.outer),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(() => NotificationPage());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        /*  boxShadow: [
                        BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                ]*/
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.grey.shade700,
                        size: 22,
                      ),
                    ),
                    if (notificationControler.count.value > 0)
                      Positioned(
                        top: -7,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primarylogin,
                            shape: BoxShape.circle,
                            // border: Border.all(color: Colors.white, width: 1.5),
                            /*    boxShadow: [
                              BoxShadow(
                                color: primarylogin.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],*/
                          ),
                          child: Center(
                            child: Text(
                              '${notificationControler.count.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            GetBuilder<CartCountController>(builder: (cartCountContro) {
              /*  if (cartCountContro.countLoader.value) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  width: 30,
                  height: 30,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                );
              }*/

              // Trigger animation when cart count changes
              if (cartCountContro.getcount != null &&
                  cartCountContro.getcount > 0) {
                _cartAnimationController.forward().then((_) {
                  _cartAnimationController.reverse();
                });
              }

              return ScaleTransition(
                scale: _cartPulseAnimation,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.to(
                      AddToCartPage(),
                      arguments: {
                        "fromIndex": _currentIndexBnb,
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            /*  boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ]*/
                          ),
                          child: Icon(
                            Icons.shopping_cart_sharp,
                            color: Colors.grey.shade700,
                            size: 20,
                          ),
                        ),
                        if (cartCountContro.getcount != null &&
                            cartCountContro.getcount > 0)
                          Positioned(
                            top: -7,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: primarylogin,
                                shape: BoxShape.circle,
                                /*  border: Border.all(color: Colors.white, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: primarylogin.withOpacity(0.3),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],*/
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  cartCountContro.getcount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(width: 10),
          ],
        ),


        bottomNavigationBar: Container(
          height: size.height * 0.08,
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            /* gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary.withOpacity(.9),
                primary.withOpacity(.95),
                primarylogin.withOpacity(.90),
              ],
            ),*/
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              buildNavBarItem(
                'assets/images/categoryIcon.png',
                "Category",
                0,
              ),
              buildNavBarItem(
                'assets/images/auction.png',
                scale: 2.4,
                //"Vault Treasures",
                "Garu Vault",
                1,
              ),
              const Spacer(),
              buildNavBarItem(
                'assets/images/herb.png',
                "Remedies",
                3,
              ),
              buildNavBarItem(
                'assets/images/profileIcon.png',
                "Profile",
                4,
              ),
            ],
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: bodys[_currentIndexBnb],
        ),
        drawer: DrawerPage(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GestureDetector(
          onTap: () => _onItemTapped(2),
          child: Container(
            margin: EdgeInsets.only(top: 35),
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primarylogin,
              border: Border.all(
                color: Colors.white,
                width: 6,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.home_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    switch (_currentIndexBnb) {
      case 0:
        return _buildAnimatedTitle('Category');
      case 1:
        return _buildAnimatedTitle('The Garu Vault');
      case 3:
        return _buildAnimatedTitle('Remedies');
      case 4:
        return _buildAnimatedTitle('Profile');
      default:
        return SizedBox(
          height: 40,
          child: Image.asset(
            'assets/images/logoname.png',
            color: primarylogin,
            fit: BoxFit.contain,
          ),
        );
    }
  }

  Widget _buildAnimatedTitle(String text) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: primarylogin,
                  letterSpacing: 0.2),
            ),
          ),
        );
      },
    );
  }

  Expanded buildNavBarItem(
    String imagePath,
    String label,
    int index, {
    double? scale = 1.8,
  }) {
    bool isSelected = _currentIndexBnb == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          setState(() {
            _currentIndexBnb = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected
                      ? primary.withOpacity(.18)
                      : Colors.transparent,
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    scale: scale,
                    color: isSelected ? primarylogin : Colors.black45,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? primarylogin : Colors.black45,
                  fontSize: 10,
                  height: 1.1,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
