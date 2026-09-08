import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:garu_customer/screens/orders/review_controller.dart';

import '../constant/colors.dart';

class ReviewDialog extends StatefulWidget {
  final Function(int, String) onSubmit;

  ReviewDialog({required this.onSubmit});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 0;
  TextEditingController _commentController = TextEditingController();
  ReviewController reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Leave a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Rate the product:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                child: Icon(
                  _rating > index ? Icons.star : Icons.star_border,
                  color: primarylogin,
                  size: 22, // Set a fixed size for the icon
                ),
              );
            }),
          ),
          SizedBox(height: 16), // Add some spacing
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
            ),
            maxLines: 1,
          ),
        ],
      ),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.of(context).pop(),
        //   child: Text('Cancel'),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     widget.onSubmit(_rating, _commentController.text);
        //     Navigator.of(context).pop();
        //   },
        //   child: Text('Submit'),
        // ),
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(
              horizontal: 0, vertical: 4),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryn),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: white),)
          ),
        ),
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(
              horizontal: 0, vertical: 4),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryn),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReviewDialog(
                      onSubmit: (rating, comment) {
                        // Handle form submission here
                        print('Rating: $rating, Comment: $comment');
                        // Send data to server or perform other actions

                      },
                    );
                  },
                );
              },
              child: Text('Submit',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: white),)
          ),
        )
      ],
    );
  }
}
