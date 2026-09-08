import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/api.dart';
import '../../main.dart';
import '../constant/validations.dart';
import 'controller/auctions_controller.dart';

class AuctionAboutScreen extends StatefulWidget {
  AuctionAboutScreen({super.key});

  @override
  State<AuctionAboutScreen> createState() => _AuctionAboutScreenState();
}

class _AuctionAboutScreenState extends State<AuctionAboutScreen> {
  // final AuctionController controller = Get.find<AuctionController>();
  final AuctionController controller = Get.put(AuctionController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getAbout();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: HelperAppBar(
        title: "The Garu Vault Treasures",
        displayCart: false,
        displaySearch: false,
      ),
      body: GetBuilder<AuctionController>(
        builder: (controller) {
          if (controller.aboutLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final about = controller.aboutData.value;

          if (about == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 55,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No information available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      controller.getAbout();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final String title = about["title"]?.toString() ?? "";

          final String description = about["description"]?.toString() ?? "";

          final String image = about["image"]?.toString() ?? "";

          // Agar image API se relative path me aa rahi hai
          final String auctionImageUrl =
              image.isNotEmpty ? "$imageUrl/$image" : "";

          return RefreshIndicator(
            onRefresh: () => controller.getAbout(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE
                  if (image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        auctionImageUrl,
                        width: double.infinity,
                        height: size.height*0.3,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Container(
                            height: size.height*0.3,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: Colors.grey.shade200,
                            child: const CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: size.height*0.3,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 55,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 22),

                  // TITLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),


                      GestureDetector(
                        onTap: () {
                          // String appLink = "https://garu.technolite.in/the-garu-vault-items";
                          String appLink = "https://garu.co.in/the-garu-vault-items";

                          print("AppLink>>>>>>$appLink");

                          Share.share(
                            "🔥 Explore The Garu Vault Treasures\n\n"
                                "Explore now 👉 $appLink",
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: grey,width: 1)
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

                  const SizedBox(height: 12),

                  // DESCRIPTION CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                color: primarylogin.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.menu_book_rounded,
                                color: primarylogin,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "About",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            _buildSocialLinks(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        HtmlWidget(
                          description,
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
                          textStyle: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
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

  Widget _buildSocialLinks() {
    final List<Map<String, dynamic>> socialLinks = [];

    if (prefs!.getString('youtube_url') != null &&
        prefs!.getString('youtube_url') != "") {
      socialLinks.add({
        "title": "YouTube",
        "icon": "assets/images/youtube.png",
        "color": Colors.red,
        "url": prefs!.getString('youtube_url').toString(),
      });
    }

    if (prefs!.getString('facebook_url') != null &&
        prefs!.getString('facebook_url') != "") {
      socialLinks.add({
        "title": "Facebook",
        "icon": "assets/images/communication.png",
        "color": Colors.blue,
        "url": prefs!.getString('facebook_url').toString(),
      });
    }

    if (prefs!.getString('instagram_url') != null &&
        prefs!.getString('instagram_url') != "") {
      socialLinks.add({
        "title": "Instagram",
        "icon": "assets/images/instagram.png",
        "color": Colors.purple,
        "url": prefs!.getString('instagram_url').toString(),
      });
    }

    if (prefs!.getString('twitter_url') != null &&
        prefs!.getString('twitter_url') != "") {
      socialLinks.add({
        "title": "Twitter",
        "icon": "assets/images/twitter.png",
        "color": Colors.blue,
        "url": prefs!.getString('twitter_url').toString(),
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
                  border:
                      Border.all(color: (item["color"] as Color), width: 0.5)),
              child: Image.asset(
                item["icon"],
                scale: 3.0,
              )),
        );
      }).toList(),
    );
  }
}
