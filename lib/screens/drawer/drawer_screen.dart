import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:garu_customer/Environment/Environment.dart';
import 'package:garu_customer/constant/ApiBaseHelper.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/main.dart';
import 'package:garu_customer/screens/auctions/my_participation_screen.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/change_password/change_password_screen.dart';
import 'package:garu_customer/screens/cms_screens/cms_screen.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/contact_us/contactus_screen.dart';
import 'package:garu_customer/screens/faqs/faqs_screen.dart';
import 'package:garu_customer/screens/login/login_screen.dart';
import 'package:garu_customer/screens/notification/notification_screen.dart';
import 'package:garu_customer/screens/orders/order_history_screen.dart';
import 'package:garu_customer/screens/product/product.dart';
import 'package:garu_customer/screens/referral_code_screen/referral_screen.dart';
import 'package:garu_customer/screens/remedies/my_subscription.dart';
import 'package:garu_customer/screens/return_request_product/return_response.dart';
import 'package:garu_customer/screens/splash/setting_controller.dart';
import 'package:garu_customer/screens/wallet/wallet_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../address/address_screen.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  SettingController settingController = Get.put(SettingController());
  bool? checklogin;

  void initState() {
    super.initState();
    checklogin = Environment.appuserlog;
    var image = prefs!.getString('profileImage_url').toString();
    print("iside image image---->>" + image.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      width: size.width * 0.7,
      backgroundColor: Colors.white,
      clipBehavior: Clip.none,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Elegant Header with Gradient
            Container(
              // padding: EdgeInsets.fromLTRB(5, size.height*0.05, 5, 5),
              // height: size.height*0.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primarylogin,
                    primarylogin.withOpacity(0.8),
                    primary.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primarylogin.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: prefs!.getString('profileImage_url').toString() == "null"
                  ? Center(
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(20, size.height * 0.07, 18, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/appBarTitleold.png",
                              color: Colors.white,
                              scale: 1.2,
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                'Welcome Guest !',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding:
                          EdgeInsets.fromLTRB(20, size.height * 0.07, 18, 20),
                      child: Row(
                        children: [
                          // Profile Image with Glow
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.5),
                                  ],
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 38,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: Image.network(
                                    prefs!
                                        .getString('profileImage_url')
                                        .toString(),
                                    width: 76,
                                    height: 76,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/userIcon.png',
                                        width: 76,
                                        height: 76,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // User Info
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prefs!.getString('user_name').toString() ??
                                      'Unknown',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Welcome Back!',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 18),

            // Drawer Items with Modern Design
            _buildDrawerItem(
              icon: Icons.dashboard_outlined,
              title: 'Home',
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomBar(bottomindex: 2)));
              },
            ),

            // Profile - Show only if logged in
            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.person_outline,
                title: 'My Profile',
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomBar(bottomindex: 4)));
                },
              ),

            _buildDrawerItem(
                icon: Icons.category_outlined,
                title: 'Categories',
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomBar(bottomindex: 0)));
                },
                showDivider:checklogin == true? true :  false),

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                onTap: () {
                  Get.to(OrderHistory());
                },
              ),

            /*_buildDrawerItem(
                icon: Icons.electric_bolt_sharp,
                title: 'The Garu Vault',
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomBar(bottomindex: 1)));
                },
                showDivider: checklogin == false ? false : true),*/

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.workspace_premium,
                title: 'Dadi Nani ke Nuskhe Plans',
                onTap: () {
                  Get.to(MySubscription());
                },
              ),

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.gavel,
                title: 'Participate The Garu Vault',
                onTap: () {
                  Get.to(MyParticipationScreen());
                },
              ),

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.assignment_return_outlined,
                title: 'Returns & Refunds',
                onTap: () {
                  Get.to(ReturnResponsePage());
                },
              ),

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.favorite_outline,
                title: 'My Wishlist',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Product(catId: 0, name: '', CatData: [])));
                },
              ),

            // My Wallet - Show only if logged in
            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'My Wallet',
                onTap: () {
                  Get.to(MyWallet());
                },
              ),

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.redeem_outlined,
                title: 'Refer & Earn',
                onTap: () {
                  Get.to(ReferralScreen());
                },
              ),

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.location_on_outlined,
                title: 'My Address',
                onTap: () {
                  Get.to(AddressPage());
                },

              ),

            // ChangePassword - Show only if logged in
            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                },
                showDivider: true,
              ),

            // My Notification - Show only if logged in
            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.notifications_outlined,
                title: 'My Notification',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()));
                },
                showDivider: checklogin == true? false: true,
              ),



            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
            ),

            // About Us
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                Get.to(() => CMSScreen(
                      title: 'About us',
                      slug: 'about_us',
                    ));
              },
            ),

            _buildDrawerItem(
                icon: Icons.storefront_outlined,
                title: 'Become a Vendor',
                onTap: () async {
                  final Uri url = Uri.parse(prefs!.getString('vendor_link').toString());

                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    toastMsg('Could not open vendor page', false);
                  }
                },
            ),

            _buildDrawerItem(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () {
                Get.to(() => CMSScreen(
                      title: 'Terms & Conditions',
                      slug: 'term_conditions',
                    ));
              },
            ),

            _buildDrawerItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                Get.to(() => CMSScreen(
                      title: 'Privacy Policy',
                      slug: 'privacy',
                    ));
              },
            ),

            _buildDrawerItem(
              icon: Icons.contact_mail_outlined,
              title: 'Contact Us',
              onTap: () {
                Get.to(() => const ContactUs());
              },
            ),

            _buildDrawerItem(
              icon: Icons.help_outline,
              title: 'FAQs',
              onTap: () {
                Get.to(() => FaqScreen());
              },
            ),

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.star_outline,
                title: 'Rate Us',
                onTap: () {
                  checklogin = Environment.appuserlog;
                  if (checklogin == true) {
                    openFeedbackDialog();
                  }
                },
              ),

            if (checklogin == true)
              _buildDrawerItem(
                icon: Icons.delete_outline,
                title: 'Delete Account',
                onTap: () {
                  checklogin = Environment.appuserlog;
                  if (checklogin == true) {
                    deleteAccount();
                  }
                },
                showDivider: false,
              ),

            const SizedBox(height: 24),

            // Logout/Login Button - Premium
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  checklogin = Environment.appuserlog;
                  if (checklogin == true) {
                    logout();
                  } else {
                    Get.to(() => const LoginPage());
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: checklogin == true
                          ? [Colors.red.shade400, Colors.red.shade600]
                          : [primarylogin, primary],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: (checklogin == true ? Colors.red : primarylogin)
                            .withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        checklogin == true ? Icons.logout : Icons.login,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        checklogin == true ? 'Logout' : "Login",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (checklogin == true)
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14,
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
            ),
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
                    icon,
                    color: primarylogin,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 12,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 72, right: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
            ),
          ),
      ],
    );
  }

  void openFeedbackDialog() {
    TextEditingController messageController = TextEditingController();
    double ratingValue = 0;

    Get.dialog(
      AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.shade400,
                              Colors.amber.shade600,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rate,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Rate Your Experience',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your feedback helps us improve',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 40,
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          ratingValue = rating;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: messageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Share your feedback...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ApiBaseHelper().submitFeedbackApi(
                                  ratingValue.toString(),
                                  messageController.text,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primarylogin,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 4,
                                shadowColor: primarylogin.withOpacity(0.3),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void deleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade400,
                          Colors.red.shade600,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Delete Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
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
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Future.delayed(const Duration(milliseconds: 500),
                                () async {
                              settingController.SettingData(
                                  Uri.parse(settings_url));
                              await ApiBaseHelper().deleteAccountApi();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 4,
                            shadowColor: Colors.red.withOpacity(0.3),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primarylogin,
                          primary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
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
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Future.delayed(const Duration(milliseconds: 500),
                                () async {
                              settingController.SettingData(
                                  Uri.parse(settings_url));
                              await ApiBaseHelper().AppLogout();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarylogin,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 4,
                            shadowColor: primarylogin.withOpacity(0.3),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final double scale;
  bool isDivider;
  final String? imagename;
  final void Function()? onTap;

  DrawerItem({
    Key? key,
    required this.title,
    this.imagename,
    this.onTap,
    this.isDivider = true,
    this.scale = 1.8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? image;
    if (imagename != null) {
      image = Image.asset(
        imagename!,
        scale: scale,
        height: 25,
        width: 30,
        color: drawerText,
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(left: 15),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                sizebox_width_10,
                image ?? const SizedBox.shrink(),
                sizebox_width_20,
                Text(
                  title,
                  style: TextStyle(
                    color: drawerText,
                    fontSize: 16,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isDivider == true) Divider(),
        if (isDivider == false) sizebox_height_10,
      ],
    );
  }
}
