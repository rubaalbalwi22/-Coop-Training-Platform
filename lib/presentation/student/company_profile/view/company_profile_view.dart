import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/app_export.dart';

import '../controller/company_profile_controller.dart';
import '../model/company_model.dart';

class CompanyProfileView extends StatelessWidget {
  final String companyId;

  CompanyProfileView({required this.companyId, Key? key}) : super(key: key);

  final CompanyProfileController controller = Get.put(CompanyProfileController());

  @override
  Widget build(BuildContext context) {
    controller.fetchCompanyProfile(companyId);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ملف الشركة'),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
      
          if (controller.companyProfile.value == null) {
            return Center(child: Text('لا يوجد بيانات للشركة'));
          }
      
          final company = controller.companyProfile.value!;
      
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCompanyHeader(company),
                SizedBox(height: 24),
                _buildCompanyInfo(company),
                SizedBox(height: 24),
                _buildRatingsSection(company),
                SizedBox(height: 24),
                _buildOpportunitiesStats(company),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCompanyHeader(CompanyProfile company) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage:AssetImage(ImageConstant.imgLogo) ,
              onBackgroundImageError: (exception, stackTrace) => Image.asset(ImageConstant.imgLogo),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildRatingStars(company.averageRating, showText: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(CompanyProfile company) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الشركة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              company.description,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            if (company.website != null) _buildInfoRow(Icons.language, 'الموقع الإلكتروني', company.website!),
            if (company.phone != null) _buildInfoRow(Icons.phone, 'الهاتف', company.phone!),
            if (company.email != null) _buildInfoRow(Icons.email, 'البريد الإلكتروني', company.email!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.primaryColor),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildRatingsSection(CompanyProfile company) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التقييمات والتعليقات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildRatingStars(company.averageRating),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '${company.ratings.length} تقييم',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            if (company.ratings.isEmpty)
              Center(
                child: Text(
                  'لا توجد تقييمات بعد',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...company.ratings.map((rating) => _buildRatingCard(rating)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(CompanyRating rating) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: Icon(Icons.person,color: Colors.white,),
                /*backgroundImage: rating.studentImage != null
                    ? NetworkImage(rating.studentImage!)
                    : AssetImage(ImageConstant.imageNotFound) as ImageProvider*/ 
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rating.studentName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    rating.date.toString().split(' ')[0],
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              _buildRatingStars(rating.rating),
            ],
          ),
          SizedBox(height: 8),
          Text(rating.comment),
          Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildOpportunitiesStats(CompanyProfile company) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(Icons.work, 'فرص تدريب', company.opportunitiesCount),
            _buildStatItem(Icons.school, 'دورات', company.trainingsCount),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, int count) {
    return Column(
      children: [
        Icon(icon, size: 30, color: theme.primaryColor),
        SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildRatingStars(double rating, {bool showText = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: 20),
        SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (showText) ...[
          SizedBox(width: 4),
          Text('(متوسط التقييم)'),
        ],
      ],
    );
  }

}