import 'dart:developer';

import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:garu_customer/helper_widget/location_label.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/orders/order_details_screen.dart';
import 'package:garu_customer/screens/orders/order_controller.dart';

import '../../Environment/Environment.dart';
import '../login/login_screen.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderController orderListController = Get.put(OrderController());
  List<Map<String, dynamic>> headingList = [
    {
      "name": "All",
    },
    {
      "name": "Order Placed",
    },
    {
      "name": "Order Confirmed",
    },
    {
      "name": "Order Dispatched",
    },
    {
      "name": "Delivered",
    },
    {
      "name": "Cancelled",
    },
  ];

  Future<void> callOrderFilterApi(
      DateTime start,
      DateTime end,
      ) async {
    String startDate = DateFormat('yyyy-MM-dd').format(start);
    String endDate = DateFormat('yyyy-MM-dd').format(end);

    orderListController.orderListPage = 1;
    orderListController.orderListData.clear();

    orderListController.selectedStartDate = startDate;
    orderListController.selectedEndDate = endDate;

    await orderListController.OrderListApiCall(
      orderListController.orderSearchCtrl.text,
      currentIndex == 0 ? '' : currentIndex,
      1,
      10,
      startDate: startDate,
      endDate: endDate,
    );
  }

  var currentIndex;
  String? selectedFilter;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {

    if (!Environment.appuserlog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const LoginPage());
      });
      return; // ✅ IMPORTANT (yahi missing tha)
    }
    currentIndex = 0;
    getOrderlistData();
    orderListController.orderListPaginationSearch('');
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

  getOrderlistData() async {
    orderListController.orderListPage = 1;
    orderListController.orderListlimit = 10;
    await orderListController.OrderListApiCall(orderListController.orderSearchCtrl.text, '',
        orderListController.orderListPage, orderListController.orderListlimit);
    log('orderListData==>' + orderListController.orderListData.toString());
    orderListController.selectedStartDate = null;
    orderListController.selectedEndDate = null;

    setState(() {});
  }

  @override
  void dispose() {
    /// search clear
    orderListController.orderSearchCtrl.clear();

    /// filter clear
    selectedFilter = null;
    selectedDateRange = null;
    currentIndex = 0;

    /// controller dates clear
    orderListController.selectedStartDate = null;
    orderListController.selectedEndDate = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return WillPopScope(
      onWillPop: () async {
        Get.off(
              () => BottomBar(
            bottomindex: 2,
          ),
        );

        return false;
      },
      child: Scaffold(
        appBar: HelperAppBar(title: "Order History",
        displaySearch: false,
        displayCart: false,
        onBackPressed: (){
          Get.off(BottomBar(bottomindex: 2,));
        },),
        body: Column(
          children: [
            // LocationLabel(),

            // Filter Chips - Modern Design
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                itemCount: headingList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        currentIndex = index;
                      });

                      orderListController.orderListPaginationSearch(
                          currentIndex == 0 ? '' : currentIndex.toString()
                      );

                      await orderListController.OrderListApiCall(
                          orderListController.orderSearchCtrl.text.isEmpty
                              ? ''
                              : orderListController.orderSearchCtrl.text,
                          currentIndex == 0 ? '' : currentIndex,
                          1,
                          10
                      );
                      log('orderListData==>${orderListController.orderListData}');
                      log('ordername here and search name here ==>${headingList[index]['name']} and ${orderListController.orderSearchCtrl.text}');
                      print("currentIndex --->$currentIndex");
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: currentIndex == index ? primarylogin : Colors.white,
                        border: Border.all(
                          width: 1,
                          color: currentIndex == index ? Colors.transparent : Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        "${headingList[index]['name']}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: currentIndex == index ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Search and Filter Row - Modern Design
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Search Field
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300,width: 1.5)
                      ),
                      child: TextFormField(
                        controller: orderListController.orderSearchCtrl,
                        onChanged: (searchValue) async {
                          await orderListController.OrderListApiCall(
                              searchValue, '',
                              orderListController.orderListPage,
                              orderListController.orderListlimit
                          );
                        },
                        cursorColor: primarylogin,
                        textInputAction: TextInputAction.search,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search order no.',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Filter Dropdown
                  Container(
                    height: 45,
                    width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300,width: 1.5)
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        hint: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tune,
                              size: 16,
                              color: primarylogin,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: primarylogin,
                        ),
                        items: [
                          'Date Range',
                          'Today',
                          'Last 7 Days',
                          'Last 30 Days'
                        ].map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            selectedFilter = value;
                          });

                          /// 👉 Date range picker open
                          if (value == "Date Range") {
                            final picked = await showDialog<DateTimeRange>(
                              context: context,
                              builder: (context) {
                                final primary = primarylogin;

                                DateTimeRange tempRange = DateTimeRange(
                                  start: DateTime.now(),
                                  end: DateTime.now(),
                                );

                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            /// Title
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: primarylogin.withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.date_range,
                                                    color: primarylogin,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  "Select Date Range",
                                                  style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 20),

                                            /// Date container
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                color: primarylogin.withOpacity(0.05),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: primarylogin.withOpacity(0.2),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    DateFormat('dd MMM yyyy').format(tempRange.start),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                      color: primarylogin,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      size: 14,
                                                      color: primarylogin,
                                                    ),
                                                  ),
                                                  Text(
                                                    DateFormat('dd MMM yyyy').format(tempRange.end),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                      color: primarylogin,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            /// Choose button
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: primarylogin,
                                                minimumSize: const Size(double.infinity, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  side: BorderSide(color: primarylogin.withOpacity(0.3)),
                                                ),
                                                elevation: 0,
                                              ),
                                              icon: Icon(
                                                Icons.calendar_today,
                                                color: primarylogin,
                                                size: 18,
                                              ),
                                              label: Text(
                                                "Choose Dates",
                                                style: TextStyle(
                                                  color: primarylogin,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              onPressed: () async {
                                                final range = await showDateRangePicker(
                                                  context: context,
                                                  firstDate: DateTime(2023),
                                                  lastDate: DateTime(2100),
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: Theme.of(context).copyWith(
                                                        colorScheme: ColorScheme.light(
                                                          primary: primarylogin,
                                                          onPrimary: Colors.white,
                                                          onSurface: Colors.grey[900]!,
                                                        ),
                                                        dialogBackgroundColor: Colors.white,
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );

                                                if (range != null) {
                                                  setState(() {
                                                    tempRange = range;
                                                  });
                                                }
                                              },
                                            ),

                                            const SizedBox(height: 20),

                                            /// Actions
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    style: OutlinedButton.styleFrom(
                                                      side: BorderSide(color: Colors.grey.shade300),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      minimumSize: const Size(double.infinity, 45),
                                                    ),
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: primarylogin,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      minimumSize: const Size(double.infinity, 45),
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context, tempRange);
                                                    },
                                                    child: const Text(
                                                      "Apply",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );

                            if (picked != null) {
                              selectedDateRange = picked;
                              await callOrderFilterApi(picked.start, picked.end);
                            }
                          }

                          /// 👉 Today Filter
                          else if (value == "Today") {
                            DateTime now = DateTime.now();
                            await callOrderFilterApi(now, now);
                          }

                          /// 👉 Last 7 Days
                          else if (value == "Last 7 Days") {
                            DateTime end = DateTime.now();
                            DateTime start = end.subtract(const Duration(days: 7));

                            await callOrderFilterApi(start, end);
                          }

                          /// 👉 Last 30 Days
                          else if (value == "Last 30 Days") {
                            DateTime end = DateTime.now();
                            DateTime start = end.subtract(const Duration(days: 30));

                            await callOrderFilterApi(start, end);
                          }
                        },
                        underline: const SizedBox(),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Colors.transparent),

            // Orders List
            GetBuilder<OrderController>(
              builder: (orderListController) {
                if (orderListController.OrderListLoading.value) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.3),
                      child: CircularProgressIndicator(
                        color: primarylogin,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                } else if (orderListController.orderListData.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.2),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      controller: orderListController.OrderListScrollCtrl,
                      physics: const BouncingScrollPhysics(),
                      itemCount: orderListController.orderListData.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        var orderdata = orderListController.orderListData[index];
                        return GestureDetector(
                          onTap: () async {
                            orderListController.OrderId.value = orderdata['id'].toString();

                            final result = await Get.to(() => OrderDetailsPage());

                            // 👇 agar order cancel hua
                            if (result == true) {
                              orderListController.orderListPage = 1;
                              orderListController.orderListData.clear();

                              await orderListController.OrderListApiCall(
                                orderListController.orderSearchCtrl.text,
                                currentIndex == 0 ? '' : currentIndex,
                                1,
                                10,
                              );
                            }
                          },

                          // onTap: () {
                          //   orderListController.OrderId.value= orderdata['id'].toString();
                          //   Get.to(() => OrderDetailsPage());
                          // },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: getStatusColorId(orderdata['order_status_id'].toString()).withOpacity(0.1),
                                width: 1.5
                              )
                            ),
                            child: Row(
                              children: [
                                // Order Icon
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: getStatusColorId(orderdata['order_status_id'].toString()).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.receipt_outlined,
                                    color: getStatusColorId(orderdata['order_status_id'].toString()),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Order Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Order #${orderdata['order_no'].toUpperCase()}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Colors.grey[900],
                                              ),
                                              overflow: TextOverflow.visible,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: getStatusColorId(orderdata['order_status_id'].toString()).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              getPaymentStatusId(orderdata['order_status_id'].toString()),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: getStatusColorId(orderdata['order_status_id'].toString()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            size: 10,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat("dd MMM yyyy").format(DateTime.parse(orderdata['date']).toLocal()),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '₹${orderdata['total']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: primarylogin,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_outline,
                                            size: 12,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              orderdata['customer_name'].toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.phone_outlined,
                                            size: 12,
                                            color: Colors.grey[500],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            orderdata['customer_mobile'],
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
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
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
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
    '1': Colors.orange,
    '2': Colors.green,
    '3': Colors.blue,
    '4': Colors.green,
    '5': Colors.red,
  };

  return dayMapping[fullDay] ?? Colors.grey;
}

OutlineInputBorder _OutlineInputBorder(Color borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: borderColor, width: 1),
  );
}