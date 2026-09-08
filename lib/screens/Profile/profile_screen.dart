import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/Profile/profile_controller.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/login/login_screen.dart';
import 'package:garu_customer/screens/orders/order_details_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Environment/Environment.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../orders/order_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController profileController = Get.put(ProfileController());
  OrderController orderListController = Get.put(OrderController());

  bool notificationsEnabled = true;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    loadNotificationSetting();
    checkLoginAndNavigate();
    call_profile();
  }

  // Add this method to check login status
  void checkLoginAndNavigate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Environment.appuserlog) {
        Get.offAll(() =>
            const LoginPage()); // Navigate to login and remove all previous routes
        // OR use Get.to(() => LoginScreen()) if you want to keep navigation stack
      }
    });
  }

  Future<void> call_profile() async {
    var dashboardUrl = Uri.parse(dashboard_url);
    await profileController.GetDashBoard(dashboardUrl);
  }

  Future<void> loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the screen from going back
        return false;
      },
      child: Scaffold(
        backgroundColor: primarylogin.withOpacity(0.11),
        body: GetBuilder<ProfileController>(
          builder: (profileController) {
            if (profileController.DashBoardLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }
            // return Center(child: CircularProgressIndicator());
            var lastOrder =
                profileController.DashBoardData['data']['last_order'];
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: size.height * 0.12,
              ),
              child: Column(
                children: [
                  // Profile Header with Gradient Background
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: size.height * 0.23,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primarylogin.withOpacity(0.5),
                                primarylogin.withOpacity(0.7),
                                primarylogin,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(0)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                        /*  padding: EdgeInsets.only(
                            left: size.width * 0.075,
                            right: size.width * 0.075,
                            top: size.height * 0.018,
                            bottom: size.height * 0.025,
                          ),*/
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Profile Image with Modern Border
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      profileController.DashBoardData['data']
                                          ['image'],
                                      width: size.height*0.11,
                                      height: size.height*0.11,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/errorImage.png',
                                          width: size.height*0.11,
                                          height: size.height*0.11,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.035),
                                  // User Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.45,
                                          child: Text(
                                            '${profileController.DashBoardData['data']['name'].toString()}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // sizebox_height_8,
                                        /*Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.phone_android_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            sizebox_width_5,
                                            Flexible(
                                              child: Text(
                                                '${profileController.DashBoardData['data']['mobile'].toString().capitalizeFirst}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      sizebox_height_8,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.email_outlined,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            sizebox_width_5,
                                            Flexible(
                                              child: Text(
                                                '${profileController.DashBoardData['data']['email'].toString().capitalizeFirst}',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),*/
                                        sizebox_height_10,
                                        Row(
                                          children: [
                                            if(   profileController
                                                .DashBoardData['data']
                                            ['user_type']==2)
                                            Container(
                                              margin: EdgeInsets.only(right: 8),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.11),
                                                border: Border.all(
                                                  color: const Color(0xFFFFFFFF)
                                                      .withOpacity(0.50),
                                                  width: 1,
                                                ),

                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.shield,
                                                    color: Color(0xFFFFD54F),
                                                    size: 14,
                                                  ),
                                                  sizebox_width_5,
                                                  Flexible(
                                                    child: Text(
                                                      "PARTNER",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Color(0xFFFFD54F),
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),


                                            GestureDetector(
                                              onTap: () async {
                                                final referralCode =
                                                    profileController
                                                        .DashBoardData['data']
                                                            ['reffer_code']
                                                        .toString();

                                                await Clipboard.setData(
                                                  ClipboardData(text: referralCode),
                                                );

                                                toastMsg(
                                                    "Referral code copied to clipboard",
                                                    true);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.11),
                                                  border: Border.all(
                                                    color: const Color(0xFFFFFFFF)
                                                        .withOpacity(0.50),
                                                    width: 1,
                                                  ),

                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.redeem,
                                                      color: Color(0xFFFFD54F),
                                                      size: 14,
                                                    ),
                                                    sizebox_width_5,
                                                    Flexible(
                                                      child: Text(
                                                        '${profileController.DashBoardData['data']['reffer_code'].toString().capitalizeFirst}',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Color(0xFFFFD54F),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    sizebox_width_10,
                                                    GestureDetector(
                                                      onTap: () async {
                                                        final referralCode =
                                                            profileController
                                                                .DashBoardData[
                                                                    'data']
                                                                    ['reffer_code']
                                                                .toString();

                                                        await Clipboard.setData(
                                                          ClipboardData(
                                                              text: referralCode),
                                                        );

                                                        toastMsg(
                                                            "Referral code copied to clipboard",
                                                            true);
                                                      },
                                                      child: const Icon(
                                                        Icons.copy,
                                                        color: Color(0xFFFFD54F),
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Stats Cards
                      Positioned(
                        left: size.width * 0.075,
                        right: size.width * 0.075,
                        bottom: -size.height * 0.03,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 14,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Wallet Card
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\u{20B9} ${profileController.DashBoardData['data']['user_balance'].toString()}',
                                          style: TextStyle(
                                            color: primarylogin,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Wallet Balance',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                height: 45,
                                width: 1,
                                color: Colors.grey.withOpacity(0.20),
                              ),
                              // Orders Card
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        /*Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: primary.withOpacity(.11),
                                          borderRadius:
                                          BorderRadius.circular(6)),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: primarylogin,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),*/

                                        Text(
                                          profileController
                                              .DashBoardData['data']
                                                  ['total_orders']
                                              .toString(),
                                          style: TextStyle(
                                            color: primarylogin,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Total order',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    /*SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Your shopping\njourney',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),*/
                                  ],
                                ),
                              ),
                              Container(
                                height: 45,
                                width: 1,
                                color: Colors.grey.withOpacity(0.20),
                              ),
                              // Created Card
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        /*Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: primary.withOpacity(.11),
                                          borderRadius:
                                          BorderRadius.circular(6)),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: primarylogin,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),*/
                                        Text(
                                          profileController.DashBoardData[
                                                              'data']
                                                          ['created_at'] ==
                                                      null ||
                                                  profileController
                                                      .DashBoardData['data']
                                                          ['created_at']
                                                      .toString()
                                                      .isEmpty
                                              ? ''
                                              : DateFormat('MMM yy')
                                                  .format(
                                                  DateTime.parse(
                                                    profileController
                                                        .DashBoardData['data']
                                                            ['created_at']
                                                        .toString(),
                                                  ).toLocal(),
                                                ),
                                          style: TextStyle(
                                            color: primarylogin,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Member Since',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    /*SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Your shopping\njourney',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.058,
                  ),
                  // Personal Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Personal Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Get.to(() => EditProfile());
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primarylogin.withOpacity(0.1),
                                              primary.withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.person_2_outlined,
                                          color: primarylogin,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'FULL NAME',
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            '${profileController.DashBoardData['data']['name'].toString()}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Divider(
                                  height: 1,
                                  thickness: 0.7,
                                  color: Colors.grey.withOpacity(0.20),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primarylogin.withOpacity(0.1),
                                              primary.withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.local_phone_outlined,
                                          color: primarylogin,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'MOBILE NUMBER',
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            '${profileController.DashBoardData['data']['mobile'].toString().capitalizeFirst}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Divider(
                                  height: 1,
                                  thickness: 0.7,
                                  color: Colors.grey.withOpacity(0.20),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primarylogin.withOpacity(0.1),
                                              primary.withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.email_outlined,
                                          color: primarylogin,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'EMAIL ADDRESS',
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            '${profileController.DashBoardData['data']['email'].toString().capitalizeFirst}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Divider(
                                  height: 1,
                                  thickness: 0.7,
                                  color: Colors.grey.withOpacity(0.20),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primarylogin.withOpacity(0.1),
                                              primary.withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: primarylogin,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'DATE OF BIRTH',
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            profileController.DashBoardData['data']
                                                            ['dob'] ==
                                                        null ||
                                                    profileController
                                                        .DashBoardData['data']
                                                            ['dob']
                                                        .toString()
                                                        .isEmpty
                                                ? 'N/A'
                                                : DateFormat('dd MMM yyyy').format(
                                                    DateTime.parse(
                                                      profileController
                                                          .DashBoardData['data']
                                                              ['dob']
                                                          .toString(),
                                                    ).toLocal(),
                                                  ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Divider(
                                  height: 1,
                                  thickness: 0.7,
                                  color: Colors.grey.withOpacity(0.20),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primarylogin.withOpacity(0.1),
                                              primary.withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.favorite_border_outlined,
                                          color: primarylogin,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ANNIVERSARY',
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            profileController.DashBoardData['data']
                                                            ['anniversary_date'] ==
                                                        null ||
                                                    profileController
                                                        .DashBoardData['data']
                                                            ['anniversary_date']
                                                        .toString()
                                                        .isEmpty
                                                ? 'N/A'
                                                : DateFormat('dd MMM yyyy').format(
                                                    DateTime.parse(
                                                      profileController
                                                          .DashBoardData['data']
                                                              ['anniversary_date']
                                                          .toString(),
                                                    ).toLocal(),
                                                  ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Last Order Section Header
                  if (lastOrder != null) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                      child: Row(
                        children: [
                         /* Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: primarylogin,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          sizebox_width_10,*/
                          const Text(
                            'Latest Order',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                letterSpacing: 0.5
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Last Order Card
                    lastOrder == null
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 60,
                                  color: primarylogin,
                                ),
                                sizebox_height_10,
                                Text(
                                  'No orders yet',
                                  style: TextStyle(
                                    color: primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              orderListController.OrderId.value =
                                  lastOrder['id'].toString();
                              Get.to(() => OrderDetailsPage());
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Order Icon
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: primarylogin.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(
                                        Icons.receipt_long_outlined,
                                        color: primarylogin,
                                        size: 23,
                                      ),
                                    ),
                                    sizebox_width_15,
                                    // Order Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Order #${lastOrder['order_no'].toString()}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              sizebox_width_10,
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: getStatusColorId(lastOrder[
                                                              'order_status_id']
                                                          .toString())
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  getPaymentStatusId(lastOrder[
                                                          'order_status_id']
                                                      .toString()),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: getStatusColorId(
                                                        lastOrder[
                                                                'order_status_id']
                                                            .toString()),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          sizebox_height_5,
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today_outlined,
                                                size: 12,
                                                color: Colors.grey.shade500,
                                              ),
                                              sizebox_width_5,
                                              Expanded(
                                                child: Text(
                                                  lastOrder['date'].toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          sizebox_height_2,
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                size: 16,
                                                color:
                                                    Colors.grey.shade500,
                                              ),
                                              sizebox_width_5,
                                              Expanded(
                                                child: Text(
                                                  lastOrder[
                                                      'customer_name'],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors
                                                        .grey.shade600,
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                             Spacer(),
                                              Text(
                                                '\u{20B9} ${lastOrder['total'].toString()}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: primarylogin,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferences',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              letterSpacing: 0.5
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.18),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Notification Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primarylogin.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  color: primarylogin,
                                  size: 23,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // Text
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NOTIFICATIONS',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Order & offer updates',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Switch
                              Switch(
                                value: notificationsEnabled,
                                activeColor: Colors.white,
                                activeTrackColor: Colors.green,
                                onChanged: (value) async {
                                  final prefs = await SharedPreferences.getInstance();

                                  await prefs.setBool(
                                    'notifications_enabled',
                                    value,
                                  );

                                  setState(() {
                                    notificationsEnabled = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),



                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thank you for being a',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'valued customer!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primarylogin,
                              ),
                            ),
                            Text(
                              'We are here to serve you better',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          "assets/images/profilebg.png",
                          scale: 4.0,
                        )
                      ],
                    ),
                  ),
                  // Add some bottom padding
                  sizebox_height_20,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ///for payments status....
  String getPaymentStatusId(String fullDay) {
    Map<String, String> dayMapping = {
      '1': 'Order Placed',
      '2': 'Order Confirmed',
      '3': 'Order Dispatched',
      '4': 'Delivered',
      '5': 'Cancelled',
    };
    return dayMapping[fullDay] ?? fullDay;
  }

  Color getStatusColorId(String fullDay) {
    Map<String, Color> dayMapping = {
      '1': primary4,
      '2': greenlabel,
      '3': Colors.orange,
      '4': greenlabel,
      '5': red,
    };
    return dayMapping[fullDay] ?? Colors.grey;
  }
}
