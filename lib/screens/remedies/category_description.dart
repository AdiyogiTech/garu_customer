import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:garu_customer/screens/constant/colors.dart';
import 'package:get/get.dart';

class CategoryDescription extends StatefulWidget {
  const CategoryDescription({super.key});

  @override
  State<CategoryDescription> createState() => _CategoryDescriptionState();
}

class _CategoryDescriptionState extends State<CategoryDescription> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final category = Get.arguments as Map<String, dynamic>?;

    final String title = category?['title']?.toString() ?? '';
    final String description =
        category?['description']?.toString() ?? '';
    final String image =
        category?['image_url']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: SafeArea(
        child: SingleChildScrollView(
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
              height: size.height * 0.28,
              fit: BoxFit.fill,
            ),
          ),
        
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            child: Column(
              children: [
        

        
                Container(
                  height: size.height*0.09,
                  width: size.height*0.09,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange.shade200,width: 0.5),
                    image: DecorationImage(image: NetworkImage(image,),
                    alignment: Alignment.center,fit: BoxFit.cover)
                  ),
                ),
                const SizedBox(height: 10),
                  // Category Title
                  SizedBox(
                    width: size.width*0.7,
                    child: Text(
                      title,
                      style:  TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: primarylogin,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
        
                  const SizedBox(height: 8),
        
                  // Small divider
                  Center(
                    child: Container(
                      height: 3,
                      width: 45,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
        
        
                  // Description Card
                  Padding(
                    padding:  EdgeInsets.only(top: size.height*0.05),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(description,
                      style: TextStyle(
                        color: const Color(0xFF444444),
                        fontSize: 16,
                      ),),
                    ),
                  ),
                ],
              ),
          ),

              // Back Button
          Padding(
            padding: const EdgeInsets.only(top: 15.0,left: 15),
            child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ),
                      ],
                    ),
          ),

            ],
          ),
        ),
      ),
    );
  }
}