import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:train_link/presentation/student/training_feedback/model/training_feedback_model.dart';
import 'package:train_link/widgets/drawer/admin_drawer.dart';

import '../controller/comment_management_controller.dart';
import '../model/comment_model.dart';

class ListCommentsView extends GetWidget<CommentManagementController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('إدارة التعليقات', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.filteredComments.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد تعليقات متاحة',
                    textDirection: TextDirection.rtl,
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: controller.filteredComments.length,
                itemBuilder: (context, index) {
                  final comment = controller.filteredComments[index];
                  return _buildCommentCard(comment);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                labelText: 'بحث في التعليقات',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.applyFilters();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(TrainingFeedback comment) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Icon(
                        Icons.person,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      comment.student?.name??"",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  intl.DateFormat('yyyy/MM/dd HH:mm').format(comment.submittedAt),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              comment.comment,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'التقييم:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(width: 8),
                _buildRatingStars(comment.rating.toDouble()),
              ],
            ),

            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () => controller.deleteComment(comment.id??""),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(120, 40),
                ),
                child: Text('حذف التعليق'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return Icon(Icons.star_border, color: Colors.grey, size: 20);
        }
      }),
    );
  }

}
