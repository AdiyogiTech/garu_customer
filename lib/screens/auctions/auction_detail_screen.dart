import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:garu_customer/screens/login/login_screen.dart';
import 'package:garu_customer/screens/orders/order_controller.dart';
import 'package:garu_customer/screens/orders/order_details_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:garu_customer/screens/auctions/controller/auctions_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Environment/Environment.dart';
import '../../helper_widget/appbar_helper.dart';
import '../../helper_widget/razorpay_web_view.dart';
import '../../helper_widget/video_widget.dart';
import '../constant/colors.dart';
import '../constant/validations.dart';
import 'delivery_detail_form.dart';

class AuctionDetailScreen extends StatefulWidget {
  final int? auctionId;
  final Map<String, dynamic>? auctionData;

  const AuctionDetailScreen({
    super.key,
    this.auctionId,
    this.auctionData,
  });

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  int currentImageIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  // final AuctionController _auctionController = Get.find<AuctionController>();
    AuctionController _auctionController = Get.put(AuctionController());
    OrderController orderListController = Get.put(OrderController());
  late Razorpay _razorpay;
  bool _isLoading = true;
  Map<String, dynamic>? _auctionData;
  Map<String, dynamic>? _winnerData;
  bool _isLoadingWinner = false;
  final TextEditingController bidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadAuctionData();
  }

  void openRazorpay(Map<String, dynamic> paymentData) {
    var options = {
      "key": paymentData["key"],
      "amount": paymentData["amount"],
      "currency": paymentData["currency"],
      "order_id": paymentData["order_id"],
      "name": "Garu",
      "description": "Vault Participation",
      "prefill": {
        "contact": "",
        "email": "",
      }
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    bool isVerified = await _auctionController.completeParticipationPayment(
      razorpayOrderId: response.orderId ?? "",
      razorpayPaymentId: response.paymentId ?? "",
      razorpaySignature: response.signature ?? "",
    );
    if (!isVerified) return;
    toastMsg("Vault Joined Successfully", true);
    final detail = await _auctionController.getAuctionDetail(widget.auctionId!);
    if (detail != null) {
      setState(() {
        _auctionData = detail;
        if (bidController.text.isEmpty) {
          bidController.text =
              (double.tryParse(detail["minimum_next_bid"].toString()) ?? 0)
                  .toInt()
                  .toString();
        }
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toastMsg(response.message ?? "Payment Failed", false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  @override
  void dispose() {
    _razorpay.clear();
    bidController.dispose();
    super.dispose();
  }

  Future<void> _loadAuctionData() async {
    if (widget.auctionData != null) {
      setState(() {
        _auctionData = widget.auctionData;
        _isLoading = false;
        if (bidController.text.isEmpty) {
          bidController.text =
              (double.tryParse(widget.auctionData!["minimum_next_bid"].toString()) ?? 0)
                  .toInt()
                  .toString();
        }
      });
      _checkAndLoadWinnerData(widget.auctionData!["id"]);
      return;
    }

    if (widget.auctionId != null) {
      final data = await _auctionController.getAuctionDetail(widget.auctionId!);
      setState(() {
        _auctionData = data;
        _isLoading = false;
        if (bidController.text.isEmpty) {
          bidController.text =
              (double.tryParse(data?["minimum_next_bid"].toString() ?? "0") ?? 0)
                  .toInt()
                  .toString();
        }
      });
      if (data != null) {
        _checkAndLoadWinnerData(data["id"]);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  // Only load winner data if auction is ended
  Future<void> _checkAndLoadWinnerData(int auctionId) async {
    if (_auctionData == null) return;

    String phase = _auctionData!["phase"]?.toString().toLowerCase() ?? "";

    // Only load winner data if auction has ended
    if (phase == "ended") {
      setState(() {
        _isLoadingWinner = true;
      });

      final winner = await _auctionController.getAuctionWinner(auctionId);

      setState(() {
        _winnerData = winner;
        _isLoadingWinner = false;
      });
    } else {
      // Clear winner data if auction is not ended
      setState(() {
        _winnerData = null;
        _isLoadingWinner = false;
      });
    }
  }

  String formatDate(String value) {
    try {
      return DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(value));
    } catch (e) {
      return value;
    }
  }

  String formatAmount(dynamic value) {
    if (value == null) return "0.00";
    return (double.tryParse(value.toString()) ?? 0.0).toStringAsFixed(2);
  }

  String formatTimeRemaining(int seconds) {
    if (seconds <= 0) return "Vault Ended";
    int days = seconds ~/ (24 * 3600);
    int hours = (seconds % (24 * 3600)) ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    if (days > 0) return "${days}d ${hours}h ${minutes}m ${secs}s";
    if (hours > 0) return "${hours}h ${minutes}m ${secs}s";
    if (minutes > 0) return "${minutes}m ${secs}s";
    return "${secs}s";
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      toastMsg("Could not open link", false);
    }
  }

  Future<void> _refreshAuctionDetail() async {
    if (widget.auctionId == null) return;

    setState(() {
      _isLoading = true;
    });

    final detail = await _auctionController.getAuctionDetail(
      widget.auctionId!,
    );

    if (detail != null && mounted) {
      setState(() {
        _auctionData = detail;
        _winnerData = null;
        _isLoading = false;

        if (bidController.text.isEmpty) {
          bidController.text =
              (double.tryParse(
                detail["minimum_next_bid"]?.toString() ?? "0",
              ) ??
                  0)
                  .toInt()
                  .toString();
        }
      });

      // Winner data bhi fresh load karo
      await _checkAndLoadWinnerData(
        detail["id"],
      );
    } else if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_auctionData == null) {
      return _buildErrorScreen();
    }

    final data = _auctionData!;
    final bool isEnded = data["phase"]?.toString().toLowerCase() == "ended";
    final bool isLive = data["phase"]?.toString().toLowerCase() == "live";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(title: 'Vault Product Bid Details',
        centerTitle: true,
        displayCart: false,
        displaySearch: false,),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(size, data),
            const SizedBox(height: 5),
            _buildTitle(data),
            const SizedBox(height: 16),
            if (!Environment.appuserlog)
              _buildLoginContainer(),
            if (Environment.appuserlog &&
                isLive &&
                (data['my_participation_status'] == null ||
                    data['has_paid_participation'] == false))
              _buildPendingStatus(data),
            if (data["can_bid"] == true && !isEnded)
              _buildBidContainer(context, data),
            if(isEnded && _winnerData==null)
              _buildEndAuctionContainer(),
            if (_winnerData != null && isEnded)
              _buildWinnerContainer(_winnerData!, data),
            const SizedBox(height: 16),
            _buildBidDetailsCard(data),
            const SizedBox(height: 16),
            _buildAuctionTimeInfo(data),
            const SizedBox(height: 16),
            _buildDescription(data),
            const SizedBox(height: 16),
            if(data['rules']!=null)
            _buildRules(data),
            const SizedBox(height: 16),
            if (data['recentBids'] != null && data['recentBids'].isNotEmpty)
              _buildRecentBids(data),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }


  // ==================== LOADING SCREEN ====================
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: const Center(
        child: CircularProgressIndicator(color: Color(0xff2E7D32)),
      ),
    );
  }

  // ==================== ERROR SCREEN ====================
  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Vault not found",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== IMAGE CAROUSEL ====================
  Widget _buildImageCarousel(Size size, Map<String, dynamic> data) {
    List<String> images = data["images"] != null && data["images"].isNotEmpty
        ? List<String>.from(data["images"])
        : [data["main_image"] ?? ""];

    final List<Map<String, dynamic>> media = [];

    if (data["images"] != null) {
      for (String image in List<String>.from(data["images"])) {
        media.add({
          "type": "image",
          "url": image,
        });
      }
    }

    if (data["video"] != null &&
        data["video"].toString().isNotEmpty) {
      media.add({
        "type": "video",
        "url": data["video"],
      });
    }

    String phase = data["phase"]?.toString().toLowerCase() ?? "";

    final Map<String, dynamic> statusMap = {
      "live": {"color": Colors.green, "label": "● LIVE"},
      "upcoming": {"color": Colors.orange, "label": "● UPCOMING"},
    };

    final status = statusMap[phase] ?? {"color": Colors.red, "label": "● ENDED"};

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: media.length,
                itemBuilder: (context, index, realIndex) {
                  final item = media[index];

                  if(item["type"]=="image"){
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item["url"],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: size.height * 0.32,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return ProductVideoWidget(
                    videoUrl: item["url"],
                  );
                },
                options: CarouselOptions(
                  height: size.height * 0.32,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() => currentImageIndex = index);
                  },
                ),
              ),

              SizedBox(height: 20,),

              SizedBox(
                height: size.height*0.08,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: media.length,
                  itemBuilder: (context,index){

                    final item=media[index];

                    return GestureDetector(

                      onTap: (){
                        _carouselController.animateToPage(index);
                      },

                      child: Container(
                        margin: const EdgeInsets.only(right:10),
                        width:  size.height*0.08,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: currentImageIndex==index
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: item["type"]=="image"

                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item["url"],
                            fit: BoxFit.cover,
                          ),
                        )

                            : Stack(
                          alignment: Alignment.center,
                          children: [

                            Container(
                              decoration: BoxDecoration(
                                color: primary3.withOpacity(.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                             Icon(
                              Icons.play_circle_fill,
                              color: primarylogin,
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),

        Positioned(
          top: 25,
          right: 25,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: status["color"],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: status["color"].withOpacity(0.3)),
            ),
            child: Text(
              status["label"],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== TITLE ====================
  Widget _buildTitle(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        data["title"] ?? "No Title",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        maxLines: 2,
      ),
    );
  }

  // ==================== BID DETAILS CARD ====================
  Widget _buildBidDetailsCard(Map<String, dynamic> data,) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          Row(
            children: [

              Expanded(
                child: _buildInfoCard(
                  title: "Start Price",
                  value: "₹${formatAmount(data["starting_price"])}",
                  icon: Icons.currency_rupee,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildInfoCard(
                  title: data['winner']!=null? "Winning Bid" : "Highest Bid",
                  value: data['winner']!=null? "₹${formatAmount(data['winner']["winning_bid"])}" :"₹${formatAmount(data["current_highest_bid"])}",
                  icon:data['winner']!=null? Icons.emoji_events : Icons.trending_up,
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildInfoCard(
                  title: "Total Bids",
                  value: "${data["total_bids"] ?? 0}",
                  icon: Icons.gavel,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: _buildInfoCard(
                  title: "Min Increment",
                  value: "₹${formatAmount(data["min_bid_increment"])}",
                  icon: Icons.add_circle_outline,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildInfoCard(
                  title: "Participation",
                  value: "₹${formatAmount(data["participation_fee"])}",
                  icon: Icons.account_balance_wallet,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildInfoCard(
                  title: "Next Bid",
                  value: "₹${formatAmount(data["minimum_next_bid"])}",
                  icon: Icons.arrow_circle_up,
                  color: Colors.blue,
                ),
              ),

            ],
          ),


          if( data["highest_bid_amount"] != 0 && data["highest_bid_amount"] != null ) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primary3.withOpacity(0.11),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primarylogin),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gavel, color: primarylogin, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Highest Bid Amount",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: primarylogin,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "₹${formatAmount(data["highest_bid_amount"])}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primarylogin,
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

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    Color color = const Color(0xff2E7D32),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: color,
            size: 22,
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }


  // ==================== PENDING STATUS ====================
  Widget _buildPendingStatus(Map<String, dynamic> data) {

    final bool isNewParticipation =
        data["my_participation_status"] == null;

    final bool paymentPending =
        data["has_paid_participation"] == false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNewParticipation? Colors.blue.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color:isNewParticipation? Colors.blue.shade200 : Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: isNewParticipation? Colors.blue.shade700: Colors.orange.shade700,
            size: 20,
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              isNewParticipation
                  ? data['refund_note'] != null?
              data['refund_note']:
              "Participation fee required to place bids. Pay now to participate."
                  : paymentPending
                  ? "Your participation payment is pending. Please complete payment to start bidding."
                  : "",
              style: TextStyle(
                color: isNewParticipation? Colors.blue.shade700: Colors.orange.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 10),

          ElevatedButton(
            onPressed: () {
              _showParticipationDialog(data);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isNewParticipation? Colors.blue : Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isNewParticipation
                  ? "Pay & Join"
                  : "Pay Now",
            ),
          ),
        ],
      ),
    );
  }

  // ==================== LOGIN CONTAINER ====================
  Widget _buildLoginContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Please login to participate in this Vault.",
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Get.to(LoginPage());
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BID CONTAINER ====================
  Widget _buildBidContainer(BuildContext context, Map<String, dynamic> data) {
    double minimumBid = double.tryParse(data["minimum_next_bid"].toString()) ?? 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Place Your Bid",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: bidController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: "₹ ",
                    prefixStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xff2E7D32),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (bidController.text.trim().isEmpty) {
                        toastMsg("Please enter bid amount", false);
                        return;
                      }

                      final enteredBid = int.tryParse(bidController.text.trim()) ?? 0;

                      if (enteredBid < minimumBid) {
                        toastMsg(
                          "Minimum bid should be ₹${minimumBid.toInt()}",
                          false,
                        );
                        return;
                      }

                      bool success = await _auctionController.placeBid(
                        auctionId: data["id"],
                        amount: enteredBid,
                      );

                      if (!success) return;

                      final detail = await _auctionController.getAuctionDetail(
                        widget.auctionId!,
                      );

                      if (detail != null) {
                        setState(() {
                          _auctionData = detail;
                          bidController.text =
                              (double.tryParse(detail["minimum_next_bid"].toString()) ?? 0)
                                  .toInt()
                                  .toString();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Bid Now",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8,),

          Text(
            "Highest Bid: ₹${formatAmount(data['current_highest_bid'])}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),

          if(data['my_highest_bid'] != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Your Highest Bid: ₹${formatAmount(data['my_highest_bid'])}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          if(data['highest_bid_amount']!=0.00)
          Text(
            "Vault ends automatically if a bid reaches ₹${formatAmount(data['highest_bid_amount'])}.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== End Auction ====================
  Widget _buildEndAuctionContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "This Vault has ended.",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== AUCTION TIME INFO ====================
  Widget _buildAuctionTimeInfo(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    const Text(
                      "Start Time",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(data["start_at"] ?? ""),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    const Text(
                      "End Time",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(data["end_at"] ?? ""),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DESCRIPTION ====================
  Widget  _buildDescription(Map<String, dynamic> data) {
    String description = data["description"] ?? "";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.description_outlined, size: 20, color: Colors.black87),
              SizedBox(width: 8),
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              Spacer(),

              if (data["youtube_link"] != null ||
                  data["facebook_link"] != null ||
                  data["instagram_link"] != null ||
                  data["linkedin_link"] != null)
                _buildSocialLinks(data),

               SizedBox(height: 16),

            ],
          ),
          const SizedBox(height: 12),
          if (description.contains("<") || description.contains(">"))
            HtmlWidget(
              description,
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.6,
              ),
            )
          else
            Text(
              description.isNotEmpty ? description : "No description available",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(Map<String, dynamic> data) {
    final List<Map<String, dynamic>> socialLinks = [];

    if (data["youtube_link"] != null &&
        data["youtube_link"].toString().isNotEmpty) {
      socialLinks.add({
        "title": "YouTube",
        "icon": "assets/images/youtube.png",
        "color": Colors.red,
        "url": data["youtube_link"],
      });
    }

    if (data["facebook_link"] != null &&
        data["facebook_link"].toString().isNotEmpty) {
      socialLinks.add({
        "title": "Facebook",
        "icon": "assets/images/communication.png",
        "color": Colors.blue,
        "url": data["facebook_link"],
      });
    }

    if (data["instagram_link"] != null &&
        data["instagram_link"].toString().isNotEmpty) {
      socialLinks.add({
        "title": "Instagram",
        "icon": "assets/images/instagram.png",
        "color": Colors.purple,
        "url": data["instagram_link"],
      });
    }

    if (data["linkedin_link"] != null &&
        data["linkedin_link"].toString().isNotEmpty) {
      socialLinks.add({
        "title": "LinkedIn",
        "icon": "assets/images/linkedin.png",
        "color": Colors.indigo,
        "url": data["linkedin_link"],
      });
    }

    if (socialLinks.isEmpty) return const SizedBox.shrink();

    return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: socialLinks.map((item) {
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _openUrl(item["url"]),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                 shape: BoxShape.circle,
                  border: Border.all(color: (item["color"] as Color),width: 0.5)
                ),
                child:Image.asset(item["icon"] ,scale: 3.0,)
              ),
            );
          }).toList(),
        );

  }

  // ==================== RULES ====================
  Widget  _buildRules(Map<String, dynamic> data) {
    final List<dynamic> rules = data["rules"] ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, size: 20, color: Colors.black87),
              SizedBox(width: 8),
              Text(
                "Rules and Conditions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (rules.isEmpty)
            const Text(
              "No rules available",
              style: TextStyle(color: Colors.grey),
            )
          else
            ...List.generate(
              rules.length,
                  (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "• ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rules[index].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== RECENT BIDS ====================
  Widget _buildRecentBids(Map<String, dynamic> data) {
    final List recentBids = data["recentBids"] ?? [];

    if (recentBids.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Icon(
                  Icons.history,
                  color: Color(0xff2E7D32),
                ),
                SizedBox(width: 8),
                Text(
                  "Recent Bids",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xff2E7D32),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Bidder",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Amount",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Date",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentBids.length,
            itemBuilder: (context, index) {
              final bid = recentBids[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.grey.shade50 : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        maskName(bid["name"].toString()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "₹${formatAmount(bid["amount"])}",
                          style: const TextStyle(
                            color: Color(0xff2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatDate(bid["created_at"]),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String maskName(String name) {
    if (name.isEmpty) return "";
    if (name.length <= 8) return name;
    return "${name.substring(0, 4)}${"*" * (name.length - 8)}${name.substring(name.length - 4)}";
  }

  // ==================== WINNER CONTAINER ====================
  Widget _buildWinnerContainer(Map<String, dynamic> winner, Map<String, dynamic> data) {
    bool isWinner = winner["is_me"] == true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
      decoration: BoxDecoration(
        color: isWinner ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWinner ? Colors.green.shade300 : Colors.red.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 28,
                color: isWinner ? Colors.amber : Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isWinner ? "Congratulations!" : data['is_forfeited_winner']==true?
                      "Winning opportunity expired": "Better Luck Next Time",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isWinner ? Colors.green.shade800 : Colors.red.shade700,
                      ),
                    ),
                    Text(
                      isWinner ? "You won this Vault."
                      : data['is_forfeited_winner']==true?
                    data['forfeited_message']:
                      "You didn't win this Vault.",
                      style: TextStyle(
                        fontSize: 14,
                        color: isWinner ? Colors.green.shade600 : Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),


          if (isWinner && winner["payment_status"] != "paid")
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "To secure your position, please complete the remaining payment within the next ${data['auction_winner_payment_days']} days. Please note that if we do not receive payment by then, the opportunity will be offered to the next highest bidder, and your participation fee cannot be refunded.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.green.shade600,
              ),
            ),
          ),

          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // _winnerTile("Winning Bid",   "₹${formatAmount(winner["winning_bid"])}",),
                // _winnerTile("Participation Fee", "₹${formatAmount(winner["participation_fee"])}",),
                _winnerTile("Payable Amount",  "₹${formatAmount(winner["payable_amount"])}",),
                _winnerTile(
                  "Payment Status",
                  winner["payment_status"].toString().toUpperCase(),
                  color: winner["payment_status"] == "paid"
                      ? Colors.green
                      : Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Show payment button only for winner with pending payment
          if (isWinner && winner["payment_status"] != "paid") ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      String? url = winner["payment_link_url"];

                      if (url == null || url.isEmpty) {
                        toastMsg("Payment link not available.", false);
                        return;
                      }

                      await Get.to(
                            () => RazorpayWebViewScreen(url: url),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// Sync Payment Button
                ElevatedButton.icon(
                  onPressed: () async {

                    bool verified =
                    await _auctionController.verifyWinnerPayment(
                      auctionId: _auctionData!["id"],
                    );

                    if (!verified) return;

                    /// Refresh Auction Detail
                    final detail = await _auctionController.getAuctionDetail(
                      _auctionData!["id"],
                    );

                    if (detail != null) {
                      setState(() {
                        _auctionData = detail;
                      });

                      await _checkAndLoadWinnerData(detail["id"]);
                    }
                  },
                  icon: const Icon(
                    Icons.sync,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    "Sync",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (isWinner && winner["payment_status"] == "paid") ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "✅ Payment Completed",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),


            if (winner["order_id"] == null||winner["order_no"] == null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text("Please share your delivery details so we can create the order and ship this item.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),),
            ),

            SizedBox(height: 10,),

            GestureDetector(
              onTap: () async{
                final result = await Get.to(
                      () => DeliveryDetailForm(
                    auctionData: _auctionData!,
                    winnerData: _winnerData!,
                  ),
                );

                if (result == true) {
                  await _refreshAuctionDetail();
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Fill Delivery Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
],

            if (winner["order_id"] != null||winner["order_no"] != null||winner["vendor_order_id"] != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Text("Order ${winner["order_no"].toString()} has been placed.",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),),
              ),

              SizedBox(height: 10,),

              GestureDetector(
                onTap: ()  async {
                  orderListController.OrderId.value = winner["vendor_order_id"].toString();

                  final result = await Get.to(() => OrderDetailsPage());
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "View Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],

          ],

        ],
      ),
    );
  }

  Widget _winnerTile(String title, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PARTICIPATION DIALOG ====================
  void _showParticipationDialog(Map<String, dynamic> data) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                const Text(
                  "Vault PARTICIPATION FEE",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  data["title"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(data['refund_note'],
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),),
                ),

                const SizedBox(height: 20),

                Table(

                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                  ),

                  children: [

                    TableRow(
                      children: [

                        const Padding(
                          padding: EdgeInsets.all(14),
                          child: Center(
                            child: Text(
                              "Amount",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Center(
                            child: Text(
                              "₹ ${formatAmount(data["participation_fee"])}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                    TableRow(
                      children: [

                        const Padding(
                          padding: EdgeInsets.all(14),
                          child: Center(
                            child: Text(
                              "Platform Fee",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Center(
                            child: Text(
                              "₹ ${formatAmount(data["platform_fee"])}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                    TableRow(
                      children: [

                        const Padding(
                          padding: EdgeInsets.all(14),
                          child: Center(
                            child: Text(
                              "Refundable if not winner",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Center(
                            child: Text(
                              "₹ ${formatAmount(data["refund_amount"])}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                  ],
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SizedBox(
                    height: 45,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      onPressed: () async {

                        final paymentData =
                        await _auctionController.payParticipationFee(data["id"]);

                        if (paymentData == null) {
                          return;
                        }

                        Navigator.pop(context);

                        openRazorpay(paymentData);
                      },

                      child: const Text(
                        "Pay with Razorpay",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}