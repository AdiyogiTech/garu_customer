import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/add_to_cart/add_to_cart_screen.dart';
import 'package:garu_customer/screens/add_to_cart/cart_count_controll.dart';
import 'package:garu_customer/screens/constant/colors.dart';

class HelperAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  bool displayCart;
  bool displaySearch;

  // ADD THESE MISSING PARAMETERS
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final IconThemeData? iconTheme;

  HelperAppBar({
    super.key,
    this.displayCart = true,
    this.displaySearch = true,
    required this.title,

    // Initialize missing parameters
    this.backgroundColor,
    this.titleColor,
    this.elevation,
    this.onBackPressed,
    this.actions,
    this.centerTitle = true,
    this.iconTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 0,
      shadowColor: Colors.transparent,

      leading: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onBackPressed ?? () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: titleColor ?? Colors.grey[700],
            size: 16,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
        ),
      ),

      titleSpacing: 8,
      leadingWidth: 48,

      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: titleColor ?? Colors.grey[900],
          letterSpacing: 0.3,
        ),
      ),

      centerTitle: centerTitle,
      iconTheme: iconTheme ?? IconThemeData(
        color: titleColor ?? Colors.grey[700],
      ),

      actions: actions ?? _buildDefaultActions(context),
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    return [
      if (displaySearch)
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              // Get.to(SearchPage());
            },
            icon: Icon(
              Icons.search,
              color: titleColor ?? Colors.grey[700],
              size: 18,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
          ),
        ),

      if (displaySearch) const SizedBox(width: 4),

      if (displayCart == true)
        GetBuilder<CartCountController>(builder: (cartcountController) {
          if (cartcountController.countLoader.value) {
            return Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primary,
                ),
              ),
            );
          }

          int cartCount = 0;
          if (cartcountController.getcount.toString() != "null") {
            try {
              cartCount = int.parse(cartcountController.getcount.toString());
            } catch (e) {
              cartCount = 0;
            }
          }

          return Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(AddToCartPage());
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: titleColor ?? Colors.grey[700],
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),

                // Cart Badge
                if (cartCount > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          cartCount > 9 ? '9+' : cartCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),

      if (displayCart == true) const SizedBox(width: 4),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}