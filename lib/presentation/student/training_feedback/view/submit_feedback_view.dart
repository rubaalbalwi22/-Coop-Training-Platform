// student/views/submit_feedback_view.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../../core/app_export.dart';
import '../controller/feedback_controller.dart';

class SubmitFeedbackView extends StatelessWidget {
  final String trainingId;
  final FeedbackController controller = Get.put(FeedbackController());

  SubmitFeedbackView({super.key, required this.trainingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تقييم التدريب'),
        backgroundColor: theme.primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Obx(
          () => controller.flowState.value.getScreenWidget(_body(), () {
            controller.flowState.value = ContentState();
          }),
        ),
      ),
    );
  }

  _body() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'كيف تقيم هذا التدريب؟',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16),
      Center(
        child: StarRating(
          rating: controller.rating.value,
          onRatingChanged: (rating) {
            controller.rating.value = rating;
          },
        ),
      ),
      SizedBox(height: 24),
      Text('شاركنا بتعليقك:', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      TextField(
        controller: controller.commentController,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'أكتب تعليقك عن التدريب...',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 8),
      Text(
        'ملاحظة: سيتم مراجعة تعليقك للتأكد من خلوه من الكلمات غير المناسبة',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => controller.submitFeedback(trainingId),
          child: Text('إرسال التقييم', style: TextStyle(fontSize: 16)),
        ),
      ),
    ],
  );
}



class StarRating extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  StarRating({super.key, required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            onRatingChanged(index + 1);
          },
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: 40,
            color: Colors.amber,
          ),
        );
      }),
    );
  }
}
