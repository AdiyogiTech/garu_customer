import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/cms_screens/cmsController.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import '../../constant/api.dart';

class CMSScreen extends StatefulWidget {
  final String? title;
  String? id;
  var slug;

  CMSScreen({
    super.key,
    this.title,
    this.id,
    this.slug
  });

  @override
  State<CMSScreen> createState() => _CMSScreenState();
}

class _CMSScreenState extends State<CMSScreen> {
  CMSController cmsController = Get.put(CMSController());

  @override
  void initState() {
    super.initState();
    var cmsUrl = Uri.parse('${baseurl}cms/${widget.slug}');
    cmsController.cmsAPICalling(cmsUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: HelperAppBar(
        title: widget.title ?? 'Information',
        displayCart: false,
        displaySearch: false,
      ),
      body: GetBuilder<CMSController>(
        builder: (cmsController) {
          // Loading State
          if (cmsController.cmsload.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primarylogin),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading ${widget.title ?? 'Content'}...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Empty State
          if (cmsController.cmsdata.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ${widget.title ?? 'Content'} Found!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please check back later',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Content State
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primarylogin,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.title ?? 'Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // HTML Content
                  HtmlWidget(
                    cmsController.cmsdata['description']?.toString() ?? '',
                    textStyle: TextStyle(
                      fontSize: 15,
                      height: 1.8,
                      color: Colors.grey.shade800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}