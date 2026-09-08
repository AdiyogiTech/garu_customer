import 'package:flutter/material.dart';
import 'package:garu_customer/helper_widget/appbar_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/constant/colors.dart';

class RazorpayWebViewScreen extends StatefulWidget {
  final String url;

  const RazorpayWebViewScreen({
    super.key,
    required this.url,
  });

  @override
  State<RazorpayWebViewScreen> createState() =>
      _RazorpayWebViewScreenState();
}

class _RazorpayWebViewScreenState
    extends State<RazorpayWebViewScreen> {

  late final WebViewController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(

        NavigationDelegate(

          onPageStarted: (url) {
            setState(() {
              loading = true;
            });
          },

          onPageFinished: (url) {
            setState(() {
              loading = false;
            });
          },

          onNavigationRequest: (request) {

            final url = request.url.toLowerCase();

            /// Payment Success
            if (url.contains("success") ||
                url.contains("payment_success") ||
                url.contains("paymentdone")) {

              Get.back(result: true);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
        title: const Text(
          "Complete Payment",
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

      body: Stack(
        children: [

          WebViewWidget(
            controller: controller,
          ),

          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),

        ],
      ),
    );
  }
}