import 'package:flutter/material.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/helper_widget/imageShimmer.dart';
import 'package:garu_customer/screens/remedies/my_subscription.dart';
import 'package:garu_customer/screens/remedies/remedies_about_screen.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../Environment/Environment.dart';
import '../constant/colors.dart';
import '../constant/validations.dart';
import '../login/login_screen.dart';
import 'article_detail_screen.dart';
import 'category_description.dart';
import 'controller/remedies_controller.dart';

class ArticleListScreen extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;
  Map<String, dynamic> category;

   ArticleListScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.category
  });

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final RemediesController controller = Get.put(RemediesController());

  final ScrollController _scrollController = ScrollController();
  late Razorpay _razorpay;

  Map<String,dynamic>? currentPayment;

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

    // Load articles when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshArticles(categoryId: widget.categoryId);
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when scrolled near bottom
      if (controller.hasMoreArticles) {
        controller.loadMoreArticles(categoryId: widget.categoryId);
      }
    }
  }

  @override
  void dispose() {
    _razorpay.clear();

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: HelperAppBar(
        title: "Dadi Nani Ke Nuskhe",
        displaySearch: false,
        displayCart: false,
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
            onRefresh: () => controller.refreshArticles(
              categoryId: widget.categoryId,
            ),
            color: const Color(0xFF2E7D32),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// Background Image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/nuskhe_bg_2.png',
                    width: size.width,
                    height: size.height * 0.22,
                    fit: BoxFit.fill,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    25,
                    0,
                   10,
                  ),
                  child: Column(
                    children: [
                      /// Title
                      SizedBox(
                        width: size.width*0.6,
                        child: Text(widget.categoryTitle,
                          style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primarylogin,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// Subtitle
                      widget.category['description'] !=null ?
                      SizedBox(
                        width: size.width*0.55,
                        child: Text(
                          widget.category['description'].toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                          maxLines: 2,
                          overflow:TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ) :
                      SizedBox(height: size.height*0.08,),

                      const SizedBox(height: 8),

                      if( widget.category['description'] !=null )
                      Center(
                        child: SizedBox(
                          width: size.width * 0.28,
                          height: 30,
                          child: OutlinedButton(
                            onPressed: () {
                              Get.to(
                                    () => const CategoryDescription(),
                                arguments: widget.category,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              side: BorderSide(
                                color: primary,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Know More",
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Subscription Banner (shown if any article is locked)
                      GetBuilder<RemediesController>(
                        builder: (context) {
                          if (controller.articleLoading.value) {
                            return const SizedBox.shrink();
                          }

                          if (controller.articles.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return _buildSubscriptionBanner();
                        },
                      ),

                      GetBuilder<RemediesController>(
                        builder: (context) {
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.articles.length + 1,
                            itemBuilder: (context, index) {
                              // Show loading state
                              if (controller.articleLoading.value && controller.articles.isEmpty) {
                                return Padding(
                                  padding:  EdgeInsets.only(top: size.height*0.2),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Color(0xFF2E7D32),
                                          strokeWidth: 3,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Loading articles...',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // Show empty state
                              if (controller.articles.isEmpty) {
                                return Padding(
                                  padding:  EdgeInsets.only(top: size.height*0.2),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.article_outlined,
                                          size: 80,
                                          color: Colors.grey[300],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No articles available',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Check back later for new remedies',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (index == controller.articles.length) {
                                return _buildPaginationLoader();
                              }
                              var article = controller.articles[index];
                              return _buildArticleCard(article,size);
                            },
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      )

    );
  }

// Subscription Banner Widget
  Widget _buildSubscriptionBanner() {

    // Article API ka response abhi nahi aaya
    if (controller.articleLoading.value) {
      return const SizedBox.shrink();
    }

    // Current category mein articles hi nahi hain
    if (controller.articles.isEmpty) {
      return const SizedBox.shrink();
    }

    // Subscription sirf CURRENT article API response se
    if (controller.articleSubscription.value != null) {
      return _buildActiveSubscriptionContainer();
    }

    // Current category ke articles check karo
    final hasLockedArticles = controller.articles.any(
          (article) => article['can_read'] == false,
    );

    if (!hasLockedArticles) {
      return const SizedBox.shrink();
    }

    return _buildLockedArticlesBanner();
  }


/*
  Widget _buildSubscriptionBanner() {

    // FIX: Use .value to check if subscription data exists
    if (controller.subscriptionData.value != null) {
      return _buildActiveSubscriptionContainer();
    }

    // Check if any article is locked
    bool hasLockedArticles = controller.articles.any(
          (article) => article['can_read'] == false,
    );

    if (!hasLockedArticles) return const SizedBox.shrink();

    return _buildLockedArticlesBanner();
  }
*/


  // Enhanced Article Card
  Widget _buildArticleCard(Map<String, dynamic> article, Size size) {
    bool canRead = article['can_read'] ?? false;
    bool hasVideo = article['has_video'] ?? false;
    bool alreadyRead = article['already_read'] ?? false;

    return GestureDetector(
      onTap: ()async {
        if (!canRead) {
          _showSubscriptionDialog();
          return;
        }
        // Navigate to article detail
        final result = await Get.to(
              () => ArticleDetailScreen(
            articleId: article['id'],
          ),
        );

        if (result == true) {
          controller.refreshArticles(
            categoryId: widget.categoryId,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Article Image with Lock Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: SizedBox(
                    width: size.height*0.15,
                    height:  size.height*0.13,
                    child: Image.network(
                      article['featured_image'] ?? '',
                      fit: BoxFit.cover,
                      color: !canRead ? Colors.black.withOpacity(0.4) : null,
                      colorBlendMode: !canRead ? BlendMode.darken : null,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: size.height*0.15,
                          height:  size.height*0.13,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return imageShimmer(
                          width: size.height*0.15,
                          height:  size.height*0.13,
                        );
                      },
                    ),
                  ),
                ),
                // Lock Icon Overlay
                if (!canRead)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            /// Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      article['title'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: !canRead ? Colors.grey[600] : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Tags/Status Row
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        /// Video Indicator
                        if (hasVideo)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.play_circle_filled,
                                  size: 14,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Video',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        /// Read Status
                        if (alreadyRead)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Read',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        /// Premium/Locked Badge
                        if (!canRead)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 12,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Premium',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationLoader() {
    if (controller.articlePaginationLoading.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2E7D32),
            strokeWidth: 2,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showSubscriptionDialog() {
    // Check if user is logged in using Environment.appuserlog
    if (!Environment.appuserlog) {
      // Show login required dialog
      _showLoginRequiredDialog();
      return;
    }

    // User is logged in, show subscription plans dialog directly
    _showPlansDialog();
  }


  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.login_outlined,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Login Required',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please login to view subscription plans',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Get.to(LoginPage());
                          print('Navigate to Login Screen');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                        if (controller.loading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          );
                        }
                  
                        if (controller.plans.isEmpty) {
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
                            controller.plans.length,
                                (index) {
                              final plan = controller.plans[index];

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

  // Plan Card Widget
// Replace the _buildPlanCard method with this:

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    bool isFree = plan['is_free'] ?? false;
    bool isUnlimited = plan['is_unlimited'] ?? false;
    int price = plan['price'] ?? 0;
    int articleLimit = plan['article_limit'] ?? 0;
    int validityDays = plan['validity_days'] ?? 0;

    final subscription = controller.articleSubscription.value;

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

    var response = await controller.subscribePlan(
      plan["id"],
    );

    if (response == null) {
      return;
    }

    Navigator.pop(context);

    controller.refreshPlans();

    await controller.refreshArticles(
      categoryId: widget.categoryId,
    );
  }

  Future<void> _handlePaidPlan(
      Map<String,dynamic> plan,
      ) async {

    var response=await controller.subscribePlan(
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

    bool success=await controller.completePayment(

        orderId:response.orderId??"",

        paymentId:response.paymentId??"",

        signature:response.signature??""

    );

    if(success){

      controller.refreshPlans();

      controller.refreshArticles(

        categoryId:widget.categoryId,

      );

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

// Active Subscription Container - Compact & Attractive
  Widget _buildActiveSubscriptionContainer() {
    var subscription = controller.articleSubscription.value;

    if (subscription == null) {
      return const SizedBox.shrink();
    }

    String planName = subscription['plan_name'] ?? 'Plan';

    int articleLimit = subscription['article_limit'] ?? 0;

    int articlesUsed = subscription['articles_used'] ?? 0;

    int remainingArticles =
        subscription['articles_remaining'] ?? 0;

    bool isUnlimited =
        subscription['is_unlimited'] ?? false;

    String expiryDate = '';

    if (subscription['expires_at'] != null) {
      try {
        DateTime expiry = DateTime.parse(
          subscription['expires_at'].toString(),
        );

        expiryDate = _formatDate(expiry);
      } catch (e) {
        expiryDate = 'Invalid date';
      }
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2E7D32).withOpacity(0.04),
            const Color(0xFF4CAF50).withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2E7D32).withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Plan Name + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Plan Name with Icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.verified_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    planName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),

              // Active Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Stats Row with improved design
          Row(
            children: [
              Expanded(
                child:_buildCompactStatItem(
                  icon: Icons.article_outlined,
                  label: isUnlimited ? 'Articles' : 'Remaining',
                  value: isUnlimited
                      ? 'Unlimited'
                      : '$remainingArticles / $articleLimit',
                  color: const Color(0xFF2E7D32),
                ),
              ),
              Container(
                height: 30,
                width: 1,
                color: Colors.grey[200],
              ),
              Expanded(
                child: _buildCompactStatItem(
                  icon: Icons.calendar_today,
                  label: 'Expires',
                  value: expiryDate.isNotEmpty ? expiryDate : 'Never',
                  color: Colors.orange[700]!,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // My Subscription Button - More attractive
          GestureDetector(
            onTap: () async {
              print('Navigate to My Subscription');

              await Get.to(() => const MySubscription());

              // My Subscription se back aane ke baad
              // Article screen ka pura article data fresh load karo
              if (!mounted) return;

              await controller.refreshArticles(
                categoryId: widget.categoryId,
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2E7D32),
                    const Color(0xFF388E3C),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.subscriptions,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'My Subscription',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// New compact stat item widget
  Widget _buildCompactStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 14,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

// Locked Articles Banner
  Widget _buildLockedArticlesBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.lock_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Premium Articles Locked',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Subscribe to read all articles',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showSubscriptionDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Buy Plan',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


// Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthAbbreviation(date.month)} ${date.year}';
  }

  String _getMonthAbbreviation(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

}