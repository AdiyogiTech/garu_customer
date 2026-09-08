import 'package:flutter/material.dart';
import 'package:garu_customer/screens/remedies/article_list_screen.dart';
import 'package:garu_customer/screens/remedies/remedies_about_screen.dart';
import 'package:get/get.dart';

import '../../helper_widget/imageShimmer.dart';
import '../constant/colors.dart';
import 'category_description.dart';
import 'controller/remedies_controller.dart';

class NuskheScreen extends StatefulWidget {
  const NuskheScreen({super.key});

  @override
  State<NuskheScreen> createState() => _NuskheScreenState();
}

class _NuskheScreenState extends State<NuskheScreen> {
  final RemediesController controller = Get.put(RemediesController());

  @override
  void initState() {
    super.initState();
    controller.getPlans();
    controller.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: primarylogin.withOpacity(0.11),
      body: SingleChildScrollView(
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
                  height: size.height * 0.26,
                  fit: BoxFit.fill,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  15,
                  0,
                  size.height * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/dadi_nani_ke_nuskhe.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 4),

                    /// Title
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: "Dadi Nani Ke ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: "Nuskhe",
                            style: TextStyle(
                              color: primarylogin,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// Subtitle
                    Text(
                      "Traditional home remedies and wellness articles.\nSubscribe to a plan to start reading.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: SizedBox(
                        width: size.width * 0.28,
                        height: 30,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.to(() => RemediesAboutScreen());
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

                    const SizedBox(height: 25),

                    /// Categories Grid
                    GetBuilder<RemediesController>(
                      builder: (context) {
                        if (controller.categoryLoading.value) {
                          return Padding(
                            padding:  EdgeInsets.symmetric(vertical: size.height*0.15),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          );
                        }

                        if (controller.categories.isEmpty) {
                          return Padding(
                            padding:  EdgeInsets.symmetric(vertical: size.height*0.15),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.medical_information_outlined,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No remedies available',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.63,
                            ),
                            itemCount: controller.categories.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var category = controller.categories[index];
                              return _buildCategoryCard(category, size);
                            },
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, Size size) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ArticleListScreen(
              categoryId: category['id'],
              categoryTitle: category['title'],
          category: category,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:  primarylogin.withOpacity(0.11),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
         /* boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],*/
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Category Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                category['image_url'] ?? '',
                height: size.height * 0.15,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: size.height * 0.15,
                    width: double.infinity,
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
                    height: size.height * 0.15,
                    width: double.infinity,
                  );
                },
              ),
            ),

            /// Content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    category['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    category['description'] ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Article Count
                  Row(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${category['article_count'] ?? 0} Articles',
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
  }
}
