/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../helper_widget/appbar_helper.dart';
import '../../helper_widget/imageShimmer.dart';
import '../constant/colors.dart';
import '../product_details/product_detail_screen.dart';
import 'favourite_controller.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final FavouriteController favouriteController =
  Get.put(FavouriteController());

  @override
  void initState() {
    super.initState();

    favouriteController.getFavourite(refresh: true);
    favouriteController.initPagination();
  }

  Future<void> _refresh() async {
    await favouriteController.getFavourite(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: HelperAppBar(
        title: "My Wishlist",
        displayCart: true,
        displaySearch: false,
      ),
      body: GetBuilder<FavouriteController>(
        builder: (_) {
          if (favouriteController.favouriteLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (favouriteController.favouriteProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "No favourite products",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              controller: favouriteController.favouriteScrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [

                /// Grid
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(

                          (context, index) {

                        final product =
                        favouriteController.favouriteProducts[index];

                        return _productCard(
                          context,
                          size,
                          product,
                          index,
                        );

                      },

                      childCount:
                      favouriteController.favouriteProducts.length,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: .59,
                    ),
                  ),
                ),

                /// Pagination Loader
                SliverToBoxAdapter(
                  child: favouriteController.loadMore
                      ? const Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : const SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _productCard(
      BuildContext context,
      Size size,
      dynamic product,
      int index,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Get.to(
            ProductDetails(
              product_id: product["id"],
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            Stack(
              children: [

                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    product["main_image"],
                    height: size.height * .16,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return imageShimmer(
                        height: size.height * .16,
                        width: double.infinity,
                      );
                    },
                  ),
                ),

                /// STOCK
                Positioned(
                  top: 6,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product["status"] == 1
                          ? Colors.green
                          : Colors.red,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      product["status"] == 1
                          ? "In Stock"
                          : "Out of Stock",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),

                /// REMOVE FROM WISHLIST
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {

                      favouriteController.toggleFavourite(
                        index,
                        product["id"],
                      );

                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      product["product_name"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "₹${product["price"]}",
                      style: TextStyle(
                        color: primarylogin,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add To Cart API
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 16,
                        ),
                        label: const Text("Add"),
                      ),
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
}*/
