import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:garu_customer/constant/api.dart';
import 'package:garu_customer/helper_widget/sized_box.dart';
import 'package:garu_customer/screens/add_to_cart/addto_cart_controller.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:garu_customer/screens/constant/validations.dart';
import 'package:garu_customer/screens/product_details/productDetail_controller%20.dart';
import 'package:share_plus/share_plus.dart';

import '../../Environment/Environment.dart';
import '../../helper_widget/video_widget.dart';

class ProductDetails extends StatefulWidget {
  var product_id;
  ProductDetails({this.product_id});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductDetailController productDetailController =
  Get.put(ProductDetailController());
  AddCartController addCartController = Get.put(AddCartController());
  int currentMediaIndex = 0;

  final CarouselSliderController carouselController =
  CarouselSliderController();
  int productQuantity = 1;
  bool isFaviourite = false;
  String combinationerror = "";
  String? result;
  var area_id;
  var cat_id;

  // New variables for attribute management
  List<dynamic> vendorProductAttributes = [];
  Map<String, dynamic> selectedAttribute = {};
  double currentPrice = 0.0;
  double currentMrp = 0.0;
  String selectedAttributeId = '';

  // For dropdown options
  List<String> attributeOptions = [];
  Map<String, String> attributeIdMap = {};
  Map<String, double> attributePriceMap = {};
  Map<String, double> attributeMrpMap = {};
  @override
  initState() {
    // TODO: implement initState
    print("inside product_id----->" + widget.product_id.toString());

    super.initState();
    productDetails();
  }

  productDetails() async {
    //var productDetailsurl = Uri.parse(productDetails_url + '${widget.product_id.toString()}');
    var productDetailsurl =
    Uri.parse(productDetails_url + "${widget.product_id.toString()}");
    print('inside productDetails Url $productDetailsurl');
    await productDetailController.GetProductDetails(productDetailsurl);

    // Process attributes after data is loaded
    if (productDetailController.productdetail['vendor_product_attributes'] != null) {
      setState(() {
        vendorProductAttributes = productDetailController.productdetail['vendor_product_attributes'];
        _initializeAttributes();
      });
    }
  }

  void _initializeAttributes() {
    attributeOptions.clear();
    attributeIdMap.clear();
    attributePriceMap.clear();
    attributeMrpMap.clear(); // 👈 add this

    if (vendorProductAttributes.isNotEmpty) {
      for (var attribute in vendorProductAttributes) {
        List<dynamic> details = attribute['attributes_details'] ?? [];
        String attributeString = details.join(' - ');
        String attrId = attribute['attribute_id'].toString();
        double price = double.parse(attribute['price'].toString());
        double mrp = double.parse(attribute['mrp'].toString()); // 👈 important

        attributeOptions.add(attributeString);
        attributeIdMap[attributeString] = attrId;
        attributePriceMap[attributeString] = price;
        attributeMrpMap[attributeString] = mrp; // 👈 store mrp
      }

      // Select first attribute by default
      if (attributeOptions.isNotEmpty) {
        selectedAttributeId = attributeIdMap[attributeOptions.first]!;
        currentPrice = attributePriceMap[attributeOptions.first]!;
        currentMrp = attributeMrpMap[attributeOptions.first]!; // 👈 set mrp
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // appBar: HelperAppBar(title: 'Product Details'),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
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
        title: Text(
          "Product Details",
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
      body: GetBuilder<ProductDetailController>(
        builder: (ProductDetailController) {
          if (productDetailController.detailsLoader.value) {
            return Center(
              child: CircularProgressIndicator(
                color: primarylogin,
                strokeWidth: 2,
              ),
            );
          }

          // Update attributes if not initialized
          if (vendorProductAttributes.isEmpty &&
              productDetailController.productdetail['vendor_product_attributes'] != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                vendorProductAttributes = productDetailController.productdetail['vendor_product_attributes'];
                _initializeAttributes();
              });
            });
          }

          int stock=productDetailController.productdetail['status'];
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Image Carousel
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: productDetailController.mediaList.isEmpty
                              ? Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "No images available",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : CarouselSlider.builder(
                            carouselController: carouselController,
                            itemCount:
                            productDetailController.mediaList.length,
                            itemBuilder: (context, index, i) {
                          /*    String imageName = productDetailController
                                  .imagelist[index];*/
                              final media = productDetailController.mediaList[index];

                              if (media["type"] == "image") {
                                return Image.network(
                                  media["url"],
                                  fit: BoxFit.contain,
                                );
                              }


                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                              child:  ProductVideoWidget(
                                videoUrl: media["url"],
                              ),

                              );
                            },
                            options: CarouselOptions(
                              height: 250,
                              enlargeCenterPage: true,
                              autoPlay: false,
                              viewportFraction: 0.9,
                              autoPlayCurve: Curves.easeInOut,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentMediaIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),


                      SizedBox(
                        height: 75,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productDetailController.mediaList.length,
                          itemBuilder: (context, index) {

                            final media =
                            productDetailController.mediaList[index];

                            bool isSelected = currentMediaIndex == index;

                            return GestureDetector(
                              onTap: () {

                                carouselController.animateToPage(index);

                                setState(() {
                                  currentMediaIndex = index;
                                });

                              },

                              child: Container(
                                width: 70,
                                margin: const EdgeInsets.only(right: 10),

                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(12),

                                  border: Border.all(
                                    color: isSelected
                                        ? primarylogin
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),

                                  child: media["type"] == "image"

                                      ? Image.network(
                                    media["url"],
                                    fit: BoxFit.cover,
                                  )

                                      : Container(
                                    color: Colors.black,

                                    child: const Center(
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 15),
                      // Product Name and Actions
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    productDetailController.productdetail['product'] == null
                                        ? ''
                                        : productDetailController.productdetail['product']['name'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Row(
                                  children: [
                                    // Favorite Button
                                    GestureDetector(
                                      onTap: () async {
                                        productDetailController
                                            .toggleFavoriteStatus();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Obx(() {
                                          // log('----------------------${productDetailController.productdetail['product']['description']}');
                                          return Icon(
                                            productDetailController.isFavorite.value
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: productDetailController
                                                .isFavorite.value
                                                ? Colors.red
                                                : Colors.grey[600],
                                            size: 20,
                                          );
                                        }),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Share Button
                                    GestureDetector(
                                      onTap: () {
                                        String slug =
                                        productDetailController.productdetail['product']['slug'].toString();

                                        String appLink = "https://garu.co.in/product-detail/$slug--${widget.product_id}";
                                        // String appLink = "https://garu.technolite.in/product-detail/$slug--${widget.product_id}";
                                        print("AppLink>>>>>>$appLink");

                                        Share.share(
                                          "🔥 Check this product\n\n"
                                              "${productDetailController.productdetail['product']['name']}\n\n"
                                              "Buy now 👉 $appLink",
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.share_outlined,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 stock==0?"Out Of Stock":'In Stock',
                                 style: TextStyle(
                                    color:  stock==0? Colors.red: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                               // Rating Badge
                               Container(
                                 padding: const EdgeInsets.symmetric(
                                   horizontal: 8,
                                   vertical: 4,
                                 ),
                                 decoration: BoxDecoration(
                                   color: Colors.amber,
                                   borderRadius: BorderRadius.circular(20),
                                 ),
                                 child: Row(
                                   children: [
                                     const Icon(
                                       Icons.star,
                                       color: Colors.white,
                                       size: 14,
                                     ),
                                     const SizedBox(width: 4),
                                     Text(
                                       '${double.tryParse(
                                           productDetailController.productdetail['avg_rating']?.toString() ?? '0'
                                       )?.toStringAsFixed(1) ?? '0.0'}',
                                       style: const TextStyle(
                                         color: Colors.white,
                                         fontWeight: FontWeight.w600,
                                         fontSize: 12,
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ],
                           ),
                            const SizedBox(height: 10),
                            // Price and Mrp
                            Row(
                              children: [
                                /// PRICE
                                Text(
                                  '₹${vendorProductAttributes.isNotEmpty
                                      ? currentPrice.toStringAsFixed(2)
                                      : (productDetailController.productdetail['price'] ?? '0')}',
                                  style: TextStyle(
                                    color: primarylogin,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                /// MRP
                                if ((vendorProductAttributes.isNotEmpty && currentMrp > 0) ||
                                    (vendorProductAttributes.isEmpty &&
                                        productDetailController.productdetail['product']['mrp'] != 0))
                                  Text(
                                    '₹${vendorProductAttributes.isNotEmpty
                                        ? currentMrp.toStringAsFixed(2)
                                        : productDetailController.productdetail['product']['mrp']}',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Attribute Selection Section
                      if (vendorProductAttributes.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Options',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Dropdown for attributes
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedAttributeId.isNotEmpty
                                      ? attributeOptions.firstWhere(
                                        (option) => attributeIdMap[option] == selectedAttributeId,
                                    orElse: () => attributeOptions.first,
                                  )
                                      : null,
                                  hint: const Text('Select option'),
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  items: attributeOptions.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(
                                        option,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedAttributeId = attributeIdMap[newValue]!;
                                        currentPrice = attributePriceMap[newValue]!;
                                        currentMrp = attributeMrpMap[newValue]!; // 👈 update mrp
                                      });
                                    }
                                  },
                                ),
                              ),

                              // Show price for selected attribute
                              const SizedBox(height: 12),
                              if (currentPrice > 0)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: primarylogin.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                       Icon(
                                        Icons.info_outline,
                                        color: primarylogin,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Selected option price: ₹${currentPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: primarylogin,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Description Section
                      Container(
                        width:double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              productDetailController.productdetail['product']
                              ['sort_description']
                                  .toString() ==
                                  "null"
                                  ? ""
                                  : productDetailController.productdetail['product']
                              ['sort_description']
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Product Information Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Product Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            HtmlWidget(
                              productDetailController.productdetail['product']
                              ['description']
                                  .toString(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Quantity and Add to Cart
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Quantity Selector
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        productDetailController
                                            .updateQuantity(false);
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        size: 18,
                                        color: productDetailController.quantity > 1
                                            ? primarylogin
                                            : Colors.grey[400],
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${productDetailController.quantity}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        productDetailController
                                            .updateQuantity(true);
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: primarylogin,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Add to Cart Button
                            Expanded(
                              child: GestureDetector(
                                onTap:stock==0?null: () {
                                  // Validate if attributes exist but not selected
                                  if (vendorProductAttributes.isNotEmpty && selectedAttributeId.isEmpty) {
                                    toastMsg('Please select product options', true);
                                    return;
                                  }

                                  var addtocartUrl = Uri.parse(addtocart_url);

                                  Map<String, dynamic> cartBody = {
                                    'product_id': productDetailController
                                        .productdetail['id']
                                        .toString(),
                                    'quantity': productDetailController
                                        .quantity
                                        .toString(),
                                    'session_id':
                                    Environment.deviceid.toString(),
                                  };

                                  // Add attribute_id only if selected
                                  if (selectedAttributeId.isNotEmpty) {
                                    cartBody['attribute_id'] = selectedAttributeId;
                                  }

                                  var addtocarttBody = jsonEncode(cartBody);

                                  addCartController.AddtoCartApi(
                                      addtocartUrl, addtocarttBody);

                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: stock == 0
                                        ? LinearGradient(colors: [Colors.grey, Colors.grey])
                                        : LinearGradient(
                                      colors: [primary2, primary2.withOpacity(0.8)],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color:stock==0?Colors.grey.withOpacity(0.3): primarylogin.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HexColorss extends Color {
  HexColorss(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}