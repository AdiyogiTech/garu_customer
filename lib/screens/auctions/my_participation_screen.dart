import 'package:flutter/material.dart';
import 'package:garu_customer/screens/auctions/auction_detail_screen.dart';
import 'package:garu_customer/screens/auctions/auctions_screen.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constant/colors.dart';
import 'controller/auctions_controller.dart';

class MyParticipationScreen extends StatefulWidget {
  const MyParticipationScreen({super.key});

  @override
  State<MyParticipationScreen> createState() => _MyParticipationScreenState();
}

class _MyParticipationScreenState extends State<MyParticipationScreen> {
  final AuctionController controller = Get.put(AuctionController());

  @override
  void initState() {
    super.initState();
    controller.getMyParticipations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        title: const Text(
          "The Garu Vault Participation",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: primarylogin,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<AuctionController>(
        builder: (controller) {
          if (controller.participationLoading.value) {
            return _buildLoadingState();
          }

          if (controller.myParticipationList.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.myParticipationList.length,
            itemBuilder: (context, index) {
              final item = controller.myParticipationList[index];
              return _participationCard(item);
            },
          );
        },
      ),
    );
  }

  // ==================== LOADING STATE ====================
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xff2E7D32),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading your participations...",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.gavel_outlined,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No Participations Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You haven't participated in any vault yet.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Get.off(BottomBar(bottomindex: 1,));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2E7D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            icon: const Icon(Icons.search, color: Colors.white),
            label: const Text(
              "Browse Vaults",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PARTICIPATION CARD ====================
  Widget _participationCard(Map item) {
    bool isPaid = item["status"].toString().toLowerCase() == "paid";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: () {
            Get.to(() => AuctionDetailScreen(
              auctionId: item["auction_item_id"],
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============ HEADER ROW ============
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xff2E7D32).withOpacity(0.15),
                            const Color(0xff2E7D32).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.gavel,
                        color: Color(0xff2E7D32),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Title & ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"] ?? "Untitled Vault",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 3),
                          // Fee
                          Text(
                            "Fee: ₹${item["fee_amount"]}",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isPaid ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isPaid
                              ? Colors.green.shade200
                              : Colors.orange.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPaid ? Icons.check_circle : Icons.pending,
                            size: 12,
                            color: isPaid ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item["status"].toString().toUpperCase(),
                            style: TextStyle(
                              color: isPaid ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),


                // ============ INFO ROW ============
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // Date
                    Expanded(
                      child: _infoTile(
                        icon: Icons.calendar_today,
                        title: "Date",
                        value: formatDate(item["created_at"]),
                        color: Colors.blue,
                      ),
                    ),


                    // Time
                    Expanded(
                      child: _infoTile(
                        icon: Icons.access_time,
                        title: "Time",
                        value: formatTime(item["created_at"]),
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== INFO TILE ====================
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color ?? const Color(0xff2E7D32),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

        ),
      ],
    );
  }

  // ==================== HELPER METHODS ====================
  String formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat("dd MMM yyyy").format(dateTime);
    } catch (e) {
      return date;
    }
  }

  String formatTime(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat("hh:mm a").format(dateTime);
    } catch (e) {
      return date;
    }
  }
}