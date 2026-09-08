import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../Environment/Environment.dart';
import '../../helper_widget/video_widget.dart';
import '../constant/colors.dart';
import '../login/login_screen.dart';
import 'controller/remedies_controller.dart';

class ArticleDetailScreen extends StatefulWidget {
  final int articleId;

  const ArticleDetailScreen({
    super.key,
    required this.articleId,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final RemediesController controller = Get.find<RemediesController>();

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getArticleDetail(articleId: widget.articleId);
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: Obx(() {
          if (controller.articleDetailLoading.value) {
            return _buildLoadingState();
          }

          if (controller.articleDetail.value == null) {
            return _buildErrorState();
          }

          var article = controller.articleDetail.value!;
          return _buildArticleContent(article, size);
        }),
      ),
    );
  }

  // AppBar - Fixed
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,size: 16,),
          onPressed: () {
            Get.back(result: true);
            },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
        ),
      ),
      leadingWidth: 48,
      title: Obx(
            () => Text(
          controller.articleDetail.value?['title'] ?? 'Article',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      centerTitle: true,
      actions: [
        // Language Selector - Fixed Overflow
        Obx(() {
          if (controller.availableLanguages.isEmpty) {
            return const SizedBox.shrink();
          }
          return PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.language,
                    color: Color(0xFF2E7D32),
                    size: 16,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    controller.selectedLanguage.value.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            onSelected: (String language) {
              controller.changeArticleLanguage(
                articleId: widget.articleId,
                language: language,
              );
            },
            itemBuilder: (context) {
              return controller.availableLanguages.map((lang) {
                return PopupMenuItem<String>(
                  value: lang['code'],
                  child: SizedBox(
                    width: 120,
                    child: Row(
                      children: [
                        if (controller.selectedLanguage.value == lang['code'])
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2E7D32),
                            size: 16,
                          )
                        else
                          const SizedBox(width: 16),
                        const SizedBox(width: 8),
                        Text(
                          lang['name'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: controller.selectedLanguage.value ==
                                lang['code']
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: controller.selectedLanguage.value ==
                                lang['code']
                                ? const Color(0xFF2E7D32)
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList();
            },
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey[200],
        ),
      ),
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF2E7D32),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading article...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Error State
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load article',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.getArticleDetail(articleId: widget.articleId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Main Article Content
  Widget _buildArticleContent(Map<String, dynamic> article, Size size) {
    bool hasVideo =
        article['video_url'] != null && article['video_url']!.isNotEmpty;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Image
          _buildFeaturedImage(article, size),

          // Content
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  article['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Language Badge
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(article['language'] ?? 'en').toUpperCase()} Article',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                Divider(
                  color: Colors.grey[200],
                  height: 1,
                ),

                const SizedBox(height: 16),

                // Video Player (if available)
                if (hasVideo) _buildVideoPlayer(article, size),
                const SizedBox(height: 16),
                // Article Content
                _buildArticleContentText(article),

              ],
            ),
          ),
        ],
      ),
    );
  }

  // Featured Image
  Widget _buildFeaturedImage(Map<String, dynamic> article, Size size) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: size.height * 0.3,
          child: Image.network(
            article['featured_image'] ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: size.height * 0.3,
                color: Colors.grey[200],
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey[400],
                  size: 50,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: size.height * 0.3,
                color: Colors.grey[100],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF2E7D32),
                  ),
                ),
              );
            },
          ),
        ),
        // Gradient overlay for better text visibility
        Container(
          width: double.infinity,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Video Player
  Widget _buildVideoPlayer(Map<String, dynamic> article, Size size) {
    String videoUrl = article['video_url'] ?? '';

    return Container(
      width: double.infinity,
      padding:  EdgeInsets.zero,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withOpacity(.25),
        ),

      ),

      child: ProductVideoWidget(
        videoUrl: videoUrl,
      ),
    );
  }

  // Article Content Text
  Widget _buildArticleContentText(Map<String, dynamic> article) {
    String content = article['content'] ?? '';

    // Check if content is HTML
   return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: HtmlWidget(
        content,

        onTapUrl: (_) => false,

        customStylesBuilder: (element) {
          if (element.localName == "a") {
            return {
              "color": "#333333",
              "text-decoration": "none",
            };
          }
          return null;
        },

        textStyle: const TextStyle(
          fontSize: 12,
          height: 1.3,
          color: Colors.black87,
        ),
      ),
    );

  }

}
