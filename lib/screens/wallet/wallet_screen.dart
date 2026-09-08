import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/Profile/profile_controller.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/wallet/wallet_controller.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  WalletController walletController = Get.put(WalletController());
  @override
  void initState() {
    super.initState();

    walletController.walletListPage = 1;
    walletController.walletListLimit = 10;

    getWalletData();
  }
  getWalletData() async {
    walletController.walletListPage = 1;
    walletController.walletListLimit = 10;
    await walletController.WalletListApiCall(
        walletController.walletSearchCtrl.text,
        '',
        walletController.walletListPage,
        walletController.walletListLimit);
    log('walletListData==>' + walletController.walletListData.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: 'My Wallet',
        displaySearch: false,
        displayCart: false,
      ),
      body: GetBuilder<WalletController>(builder: (walletController) {
        if (walletController.walletListLoading.value) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: Get.height * 0.3),
              child: CircularProgressIndicator(
                color: primarylogin,
                strokeWidth: 2,
              ),
            ),
          );
        } else if (walletController.walletListData.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: Get.height * 0.3),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No wallet data found',
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
          return SingleChildScrollView(
            controller: walletController.walletListScrollCtrl,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Profile Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primarylogin.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            walletController.walletListData[0]['user']['image'].toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey[400],
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              walletController.walletListData[0]['user']['name'].toString(),
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.phone_outlined,
                              walletController.walletListData[0]['user']['mobile'].toString(),
                            ),
                            const SizedBox(height: 4),
                            _buildInfoRow(
                              Icons.email_outlined,
                              walletController.walletListData[0]['user']['email'].toString(),
                            ),
                            const SizedBox(height: 4),
                            _buildInfoRow(
                              Icons.card_giftcard_outlined,
                              walletController.walletListData[0]['user']['reffer_code']==null?'N/A (referral code)':
                              '${walletController.walletListData[0]['user']['reffer_code']} (referral code)',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Balance Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primarylogin,
                        primarylogin.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primarylogin.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/images/wallet.png",
                          scale: 3,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Balance",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${walletController.walletListData[0]['user']['user_balance']}',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Search Field (Commented)
                // Container(
                //   margin: EdgeInsets.only(left: 10, right: 10),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: TextFormField(
                //       controller: walletController.walletSearchCtrl,
                //       cursorColor: primary,
                //       textInputAction: TextInputAction.go,
                //       maxLines: 1,
                //       style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 14,
                //           letterSpacing: 0.2),
                //       decoration: InputDecoration(
                //         border: _OutlineInputBorder(
                //             Colors.grey.shade400),
                //         focusedBorder:
                //         _OutlineInputBorder(primary),
                //         enabledBorder:
                //         _OutlineInputBorder(Colors.grey),
                //         hintText: 'Search',
                //         hintStyle: TextStyle(
                //             color: Colors.grey,
                //             fontSize: 14,
                //             letterSpacing: 0.2),
                //         constraints: BoxConstraints(
                //             maxHeight: 40,
                //             minHeight: 40,
                //             maxWidth: size.width * 0.8,
                //             minWidth: size.width * 0.8),
                //         contentPadding: EdgeInsets.only(left: 10),
                //         suffixIcon: GestureDetector(
                //           onTap: () {
                //             print("Search icon tapped");
                //           },
                //           child: Column(
                //             mainAxisAlignment:
                //             MainAxisAlignment.center,
                //             children: [
                //               GestureDetector(
                //                 onTap: () async {
                //                    await walletController.WalletListApiCall(walletController.walletSearchCtrl.text,'',1,  walletController.walletListlimit );
                //                 },
                //                 child: Icon(
                //                   Icons.search,
                //                   color: Colors.grey.shade400,
                //                   size: 18,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 20),

                // Recent Transactions Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: primarylogin,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Transactions List
                if (walletController.walletListData[0]['wallet'].isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.1),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions found',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: walletController.walletListData[0]['wallet'].length,
                    itemBuilder: (context, index) {

                      final transaction = walletController.walletListData[0]['wallet'][index];
                      bool isCredit = transaction['payment_type'] == 1;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            // Transaction Icon
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isCredit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isCredit ? Colors.green : Colors.red,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Transaction Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Voucher No: ${transaction['voucher_no']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat("d MMM, yyyy | h:mm a").format(DateTime.parse(transaction['date']).toLocal()),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    transaction['discription'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Amount
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      isCredit ? '+' : '-',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: isCredit ? Colors.green : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      '₹${transaction['amount']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: isCredit ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCredit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isCredit ? 'Credit' : 'Debit',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: isCredit ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                if (walletController.loadMoreDataLoader.value)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _OutlineInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor, width: 1),
    );
  }
}