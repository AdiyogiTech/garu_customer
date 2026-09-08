import 'package:flutter/material.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/screens/category/category_controller.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/product/product.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  final Function(int)? onTabChange;

  const CategoryPage({
    super.key,
    this.onTabChange,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    callCategoryData();
  }

  Future<void> _onRefresh() async {
    callCategoryData(); // cart count refresh
    setState(() {});
  }

  Future<void> callCategoryData() async {
    var caturl = Uri.parse(category_url);
    await categoryController.GetCategories(caturl);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primarylogin.withOpacity(0.11),
      body: Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.1),
        child: GetBuilder<CategoryController>(
          builder: (categoryController) {
            // Show shimmer effect while loading
            if (categoryController.CatLoader.value ||
                categoryController.CatData == null) {
              return Center(child: CircularProgressIndicator());
            }

            print('inside CatData ${categoryController.CatData}');

            final categories = [
              {
                "id": "auction",
                "name": "The Garu Vault",
                "description":
                    "Your chance to own a piece of history. Participate in the treasure hunt and bid on the items you want.",
                "image_url": "assets/images/the_garu_vault_treasurer.jpg",
              },
              {
                "id": "nushke",
                "name": "Dadi Nani Ke Nuskhe",
                "description":
                    "Traditional home remedies and wellness articles.\nSubscribe to a plan to start reading.",
                "image_url": "assets/images/dadi_nani_ke_nuskhe.png",
              },
              ...categoryController.CatData,
            ];

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Location
                        // LocationLabel(),
                        // Space between LocationLabel and GridView
                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // GridView with three items
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          //final category = categoryController.CatData[index];
                          final category = categories[index];
                          final bool imageLeft = index.isOdd;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                if (category["id"] == "auction") {
                                  widget.onTabChange?.call(1);
                                  return;
                                }

                                if (category["id"] == "nushke") {
                                  widget.onTabChange?.call(3);
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Product(
                                      catId: category["id"],
                                      name: category["name"],
                                      CatData: categoryController.CatData,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                // height: 95,
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(.10),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: primary.withOpacity(.1),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.04),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    if (imageLeft) _buildImage(category),

                                    /// Text
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category["name"] ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            if ((category["description"] ?? "")
                                                .toString()
                                                .isNotEmpty)
                                              Text(
                                                category["description"],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  height: 1.3,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    /// Image
                                    if (!imageLeft) _buildImage(category),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        //childCount: categoryController.CatData.length,
                        childCount: categories.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImage(dynamic category) {
    final image = category["image_url"].toString();
    return Expanded(
      flex: 2,
      child: Container(
        height: 80,
        width: 80,
        /*decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage( category["image_url"],),
                fit: BoxFit.contain,scale: 3)
        ),*/
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: image.startsWith("assets/")
                ? AssetImage(image)
                : NetworkImage(image) as ImageProvider,
            fit: BoxFit.contain,
            scale: 3,
          ),
        ),
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRect(
        Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
