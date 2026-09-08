import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/notification/notification_controller.dart';

import '../../Environment/Environment.dart';
import '../../helper_widget/appbar_helper.dart';
import '../login/login_screen.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationController notificationControler =
  Get.put(NotificationController());

  @override
  void initState() {
    checkLoginAndNavigate();
    notificationControler.notificationListPaginationSearch();
    getnotificationlistData();
    super.initState();
  }

  void checkLoginAndNavigate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Environment.appuserlog) {
        Get.offAll(() => const LoginPage()); // Navigate to login and remove all previous routes
        // OR use Get.to(() => LoginScreen()) if you want to keep navigation stack
      }
    });
  }

  getnotificationlistData() async {
    notificationControler.notificationListPage = 1;
    notificationControler.notificationListlimit = 8;
    await notificationControler.NotificationListApiCall(
        notificationControler.notificationSearchCtrl.text,
        '',
        notificationControler.notificationListPage,
        notificationControler.notificationListlimit);
    log('orderListData==>' +
        notificationControler.notificationListData.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'Notification',
        displayCart: false,
        displaySearch: false,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: primarylogin,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Notifications',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: GetBuilder<NotificationController>(
                builder: (notificationControler) {
                  if (notificationControler.notificationListLoading.value) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.3),
                        child: CircularProgressIndicator(
                          color: primarylogin,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  else if (notificationControler.notificationListData.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.3),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_none_outlined,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'We\'ll notify you when something arrives',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  else {
                    return ListView.builder(
                      controller: notificationControler.notificationListScrollCtrl,
                      itemCount: notificationControler.notificationListData.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {

                        if(index==notificationControler.notificationListData.length){
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        var message = notificationControler.notificationListData[index];
                        notificationControler.count.value = 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Notification Icon
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primarylogin.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: primarylogin,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Notification Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message["title"].toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      message["message"].toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Time indicator (optional)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: primarylogin.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _OutlineInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor, width: 1),
    );
  }
}