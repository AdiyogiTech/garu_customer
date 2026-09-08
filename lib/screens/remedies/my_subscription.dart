import 'package:flutter/material.dart';
import 'package:garu_customer/screens/bottom_bar/BottomBar.dart';
import 'package:garu_customer/screens/remedies/article_detail_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:garu_customer/screens/remedies/controller/remedies_controller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../constant/colors.dart';
import '../constant/validations.dart';

class MySubscription extends StatefulWidget {
  const MySubscription({super.key});

  @override
  State<MySubscription> createState() => _MySubscriptionState();
}

class _MySubscriptionState extends State<MySubscription> {
  RemediesController _controller = Get.put(RemediesController());

  late Razorpay _razorpay;

  Map<String,dynamic>? currentPayment;

  Future<void> _refreshSubscriptionScreen() async {
    await _controller.getMySubscription();
    await _controller.getReadHistory();
    await _controller.refreshPlans();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        _handlePaymentSuccess);

    _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR,
        _handlePaymentError);

    _razorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET,
        _handleExternalWallet);

    // Refresh subscription data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getMySubscription();
      _controller.getReadHistory();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
              size: 18,
            ),
          ),
        ),
        title: const Text(
          "My Remedy Plans",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [IconButton( onPressed: () {
          _controller.getMySubscription();
          // toastMsg("Refreshed successfully", true);
        }, icon: Icon(Icons.refresh)),
        SizedBox(width: 10,)],
      ),
      body: Obx(() {
        if (_controller.loading.value) {
          return _buildLoadingState();
        }

        if (_controller.subscriptionData.value == null) {
          return _buildNoSubscriptionState();
        }

        final data = _controller.subscriptionData.value!;
        return _buildSubscriptionContent(data);
      }),
    );
  }

  // ==================== LOADING STATE ====================
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xff2E7D32),
          ),
          SizedBox(height: 16),
          Text(
            "Loading subscription...",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== NO SUBSCRIPTION STATE ====================
  Widget _buildNoSubscriptionState() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "No Active Plan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              _showPlansDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              elevation: 2,
            ),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.keyboard_arrow_right, size: 20),
            label: const Text(
              "Browse Plans",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SUBSCRIPTION CONTENT ====================
  Widget _buildSubscriptionContent(Map<String, dynamic> data) {
    final Map<String, dynamic>? current =
    data["current"] != null
        ? Map<String, dynamic>.from(data["current"])
        : null;

    final List history =
    data["history"] is List ? data["history"] : [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= CURRENT PLAN =================
          if (current != null) ...[
            _buildCurrentPlanCard(current),

            const SizedBox(height: 20),

            // ================= USAGE =================
            _buildUsageCard(current),

            const SizedBox(height: 24),
          ] else
            Padding(
              padding: const EdgeInsets.only(bottom:15.0),
              child: _buildNoSubscriptionState(),
            ),

          // ================= SUBSCRIPTION HISTORY =================
          _buildSubscriptionHistory(history),
          const SizedBox(height: 20),

// ================= READ HISTORY =================
          _buildReadHistory(),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanCard(Map<String, dynamic> current) {
    final String planName = current["plan_name"] ?? "No Plan";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff2E7D32),
            Color(0xff1B5E20),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff2E7D32).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      "Current Subscription",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "ACTIVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _subscriptionInfoTile(
                  icon: Icons.play_circle_outline,
                  label: "Started",
                  value: formatDate(current["starts_at"]),
                  color: Colors.white,
                ),
              ),

              Container(
                width: 1,
                height: 45,
                color: Colors.white.withOpacity(0.2),
              ),

              Expanded(
                child: _subscriptionInfoTile(
                  icon: Icons.event_available,
                  label: "Expires",
                  value: formatDate(current["expires_at"]),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCard(Map<String, dynamic> current) {
    final bool isUnlimited = current["is_unlimited"] ?? false;

    final int used = current["articles_used"] ?? 0;
    final int limit = current["article_limit"] ?? 0;
    final int remaining = current["articles_remaining"] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: Color(0xff2E7D32),
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                "Usage Statistics",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: (){
                  _showPlansDialog();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: primarylogin,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Browse Plans",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (isUnlimited)
            _buildUnlimitedUsage()
          else
            _buildLimitedUsage(
              used,
              limit,
              remaining,
            ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionHistory(List history) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.history,
                color: Color(0xff2E7D32),
                size: 22,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  "Purchase History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${history.length} Plans",
                  style: const TextStyle(
                    color: Color(0xff2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: Text(
                  "No subscription history found",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = Map<String, dynamic>.from(history[index]);

                return _buildHistoryItem(item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final String planName = item["plan_name"] ?? "Unknown Plan";
    final String status = (item["status"] ?? "unknown").toString();

    final double amountPaid =
        double.tryParse(
          item["amount_paid"]?.toString() ?? "0",
        ) ??
            0;

    final double amount =
        double.tryParse(
          item["amount"]?.toString() ?? "0",
        ) ??
            0;

    final double taxAmount =
        double.tryParse(
          item["tax_amount"]?.toString() ?? "0",
        ) ??
            0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // ================= TOP =================
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _statusIcon(status),
                  color: _statusColor(status),
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  planName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              _statusBadge(status),
            ],
          ),

          const SizedBox(height: 14),

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          const SizedBox(height: 14),

          // ================= DATES =================
          Row(
            children: [
              Expanded(
                child: _historyInfo(
                  Icons.calendar_today_outlined,
                  "Started",
                  formatDate(item["starts_at"]),
                ),
              ),

              Expanded(
                child: _historyInfo(
                  Icons.event_outlined,
                  "Expires",
                  formatDate(item["expires_at"]),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ================= PAYMENT =================
          Row(
            children: [
              Expanded(
                child: _historyInfo(
                  Icons.currency_rupee,
                  "Amount",
                  "₹${amount.toStringAsFixed(2)}",
                ),
              ),

              Expanded(
                child: _historyInfo(
                  Icons.receipt_long_outlined,
                  "Paid",
                  "₹${amountPaid.toStringAsFixed(2)}",
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ================= TAX =================
          Row(
            children: [
              Expanded(
                child: _historyInfo(
                  Icons.percent,
                  "Tax",
                  "₹${taxAmount.toStringAsFixed(2)}",
                ),
              ),

              Expanded(
                child: _historyInfo(
                  Icons.payment_outlined,
                  "Payment",
                  item["payment_id"] != null
                      ? "Paid"
                      : "Not Paid",
                ),
              ),
            ],
          ),

          // ================= RAZORPAY ORDER =================
          if (item["payment_id"] != null) ...[
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "Payment ID: ${item["payment_id"]}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _historyInfo(
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.grey.shade600,
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: Color(0xff2E7D32),
                size: 22,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  "Read History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_controller.readHistory.length} Articles",
                  style: const TextStyle(
                    color: Color(0xff2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (_controller.readHistory.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: Text(
                  "No read history found",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controller.readHistory.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _controller.readHistory[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.to(
                      ArticleDetailScreen(
                        articleId: item["article_id"],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item["featured_image"] ?? "",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"] ?? "Untitled Article",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 13,
                                    color: Colors.grey.shade500,
                                  ),

                                  const SizedBox(width: 4),

                                  Expanded(
                                    child: Text(
                                      formatDate(item["read_at"]),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 5),

                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return Colors.green;

      case "pending":
        return Colors.orange;

      case "expired":
        return Colors.red;

      case "cancelled":
      case "canceled":
        return Colors.grey;

      default:
        return Colors.blueGrey;
    }
  }
  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return Icons.check_circle_outline;

      case "pending":
        return Icons.hourglass_empty;

      case "expired":
        return Icons.timer_off_outlined;

      case "cancelled":
      case "canceled":
        return Icons.cancel_outlined;

      default:
        return Icons.info_outline;
    }
  }

/*  Widget _buildSubscriptionContent(Map<String, dynamic> data) {
    bool isUnlimited = data["is_unlimited"] ?? false;
    int remaining = data["articles_remaining"] ?? 0;
    int used = data["articles_used"] ?? 0;
    int limit = data["article_limit"] ?? 0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ============ PLAN CARD ============
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xff2E7D32),
                  const Color(0xff1B5E20),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff2E7D32).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Name
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["plan_name"] ?? "No Plan",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Active Plan",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "ACTIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.white.withOpacity(0.2),
                  height: 1,
                ),
                const SizedBox(height: 20),
                // Subscription Details
                Row(
                  children: [
                    Expanded(
                      child: _subscriptionInfoTile(
                        icon: Icons.calendar_today,
                        label: "Started",
                        value: formatDate(data["starts_at"]),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    Expanded(
                      child: _subscriptionInfoTile(
                        icon: Icons.calendar_today,
                        label: "Expires",
                        value: formatDate(data["expires_at"]),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ============ USAGE CARD ============
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      color: Color(0xff2E7D32),
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Usage Statistics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isUnlimited) ...[
                  _buildUnlimitedUsage(),
                ] else ...[
                  _buildLimitedUsage(used, limit, remaining),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: Color(0xff2E7D32),
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Read History",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (_controller.readHistory.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "No read history found",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _controller.readHistory.length,
                    separatorBuilder: (_, __) => const Divider(height: 20),
                    itemBuilder: (context, index) {

                      final item = _controller.readHistory[index];

                      return GestureDetector(
                        onTap: (){
                          Get.to(ArticleDetailScreen(articleId: item['article_id'],));
                        },
                        child: Row(
                          children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item["featured_image"],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    item["title"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    formatDate(item["read_at"]),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),

                                ],
                              ),
                            ),


                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

        ],
      ),
    );
  }*/

  // ==================== SUBSCRIPTION INFO TILE ====================
  Widget _subscriptionInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==================== LIMITED USAGE ====================
  Widget _buildLimitedUsage(int used, int limit, int remaining) {
    double progress = limit > 0 ? used / limit : 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Used Articles",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              "$used / $limit",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 0.8 ? Colors.red : const Color(0xff2E7D32),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${(progress * 100).toStringAsFixed(0)}% used",
              style: TextStyle(
                fontSize: 12,
                color: progress >= 0.8 ? Colors.red : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "$remaining remaining",
              style: TextStyle(
                fontSize: 12,
                color: remaining > 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== UNLIMITED USAGE ====================
  Widget _buildUnlimitedUsage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.loop,
            size: 48,
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 8),
          Text(
            "Unlimited Access",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Enjoy unlimited articles",
            style: TextStyle(
              fontSize: 14,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DETAIL TILE ====================
  Widget _detailTile(String title, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xff2E7D32).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color ?? const Color(0xff2E7D32),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELPER METHODS ====================
  String formatDate(String? date) {
    if (date == null) return "N/A";
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat("dd MMM yyyy").format(dateTime);
    } catch (e) {
      return date;
    }
  }

  void _showPlansDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Choose Your Plan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Subscribe to unlock all articles and premium content',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Plans List
                      Obx(() {
                        if (_controller.loading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          );
                        }

                        if (_controller.plans.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'No plans available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: List.generate(
                            _controller.plans.length,
                                (index) {
                              final plan = _controller.plans[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildPlanCard(plan),
                              );
                            },
                          ),
                        );
                      }),

                      /*      return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.plans.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            var plan = controller.plans[index];
                            return _buildPlanCard(plan);
                          },
                        );
                      }),*/

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              Positioned(
                right: 15,
                top: 15,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Icon(Icons.close,color: Colors.white,size: 18,),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    bool isFree = plan['is_free'] ?? false;
    bool isUnlimited = plan['is_unlimited'] ?? false;
    int price = plan['price'] ?? 0;
    int articleLimit = plan['article_limit'] ?? 0;
    int validityDays = plan['validity_days'] ?? 0;

    final subscription = _controller.articleSubscription.value;

    final bool canPurchasePlan =
        subscription == null ||
            (subscription['articles_remaining'] ?? 0) == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2E7D32).withOpacity(0.05),
            const Color(0xFF2E7D32).withOpacity(0.02),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF2E7D32).withOpacity(0.2),
          width:  1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Plan Name and Badge
          Row(
            children: [
              // Plan Icon
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: plan['image'] != null || plan['image'] != ""?
                  Image.network(plan['image'],fit: BoxFit.cover,width: 50,height: 50,):
                  Icon(Icons.workspace_premium,
                    size: 25,color: Colors.yellow,)
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan['name'] ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge
                        if (isFree)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'FREE',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        else if (isUnlimited)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'UNLIMITED',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.amber[700],
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (plan['description'] != null
                    //&& plan['description'] != plan['name']
                    )
                      Text(
                        plan['description'] ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Plan Details Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.04),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Price
                _buildDetailItem(
                  icon: Icons.currency_rupee,
                  label: 'Price',
                  value: price == 0 ? 'Free' : '$price',
                  isFree: isFree,
                ),

                // Vertical Divider
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey[300],
                ),

                // Article Limit
                _buildDetailItem(
                  icon: Icons.article_outlined,
                  label: 'Articles',
                  value: isUnlimited ? 'Unlimited' : '$articleLimit',
                  isFree: isFree,
                ),

                // Vertical Divider
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey[300],
                ),

                // Validity
                _buildDetailItem(
                  icon: Icons.calendar_today,
                  label: 'Validity',
                  value: plan['has_expiry'] == false
                      ? 'Lifetime'
                      : '$validityDays Days',
                  isFree: isFree,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Subscribe/Select Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canPurchasePlan
                  ? () {
                if (isFree) {
                  _handleFreePlan(plan);
                } else {
                  _handlePaidPlan(plan);
                }
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canPurchasePlan
                    ? const Color(0xFF2E7D32)
                    : Colors.grey,
                disabledBackgroundColor: Colors.grey,

                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                isFree ? 'Subscribe Free' : 'Buy Now',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build detail items
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isFree,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color:  const Color(0xFF2E7D32),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color:  Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }


// Add these handler methods
  Future<void> _handleFreePlan(Map<String, dynamic> plan) async {
    var response = await _controller.subscribePlan(
      plan["id"],
    );

    if (response == null) {
      return;
    }

    Navigator.pop(context);

    await _refreshSubscriptionScreen();
  }

  Future<void> _handlePaidPlan(
      Map<String,dynamic> plan,
      ) async {

    var response=await _controller.subscribePlan(
        plan["id"]
    );

    if(response==null){
      return;
    }

    Navigator.pop(context);

    if(response["data"]["payment_required"]){

      currentPayment=response["data"];

      openRazorpay(
        response["data"],
      );

    }

  }

  void openRazorpay(
      Map<String,dynamic> payment,
      ){

    var options={

      "key":payment["key"],

      "amount":payment["amount"],

      "currency":payment["currency"],

      "order_id":payment["order_id"],

      "name":"Garu",

      "description":"Remedies Subscription",


    };

    try{

      _razorpay.open(options);

    }catch(e){

      toastMsg(
          e.toString(),
          false
      );

    }

  }

  Future<void> _handlePaymentSuccess(
      PaymentSuccessResponse response,
      ) async {

    bool success = await _controller.completePayment(
      orderId: response.orderId ?? "",
      paymentId: response.paymentId ?? "",
      signature: response.signature ?? "",
    );

    if (success) {
      await _refreshSubscriptionScreen();
    }
  }

  void _handlePaymentError(
      PaymentFailureResponse response,
      ){

    toastMsg(

        response.message??"Payment Failed",

        false

    );

  }

  void _handleExternalWallet(
      ExternalWalletResponse response,
      ){

    toastMsg(

        "External Wallet : ${response.walletName}",

        true

    );

  }
}