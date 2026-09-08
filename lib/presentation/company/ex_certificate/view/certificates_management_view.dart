import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:train_link/core/app_export.dart';
import 'package:train_link/presentation/company/training_course/model/training_course_model.dart';
import 'package:train_link/presentation/company/training_opportunity/model/training_opportunity_model.dart';
import '../../../admin/report_management/view/certificate_view.dart';
import '../controller/certificate_controller.dart';
import '../model/certificate_model.dart';


class CertificatesManagementView extends GetWidget<ManageCertificateController> {
  const CertificatesManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إدارة الشهادات'),
          backgroundColor: theme.primaryColor,
       centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'التدريبات'),
              Tab(text: 'الدورات'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTrainingTab(),
            _buildCoursesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingTab() {
    return Obx(() {


      if (controller.trainings.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment, size: 60, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'لا توجد تدريبات',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchTrainings,
        color: theme.primaryColor,
        child: ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: controller.trainings.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final training = controller.trainings[index];
            return _buildTrainingCard(training);
          },
        ),
      );
    });
  }

  Widget _buildCoursesTab() {
    return Obx(() {

      if (controller.courses.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, size: 60, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'لا توجد دورات',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchCourses,
        color: theme.primaryColor,
        child: ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: controller.courses.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final course = controller.courses[index];
            return _buildCourseCard(course);
          },
        ),
      );
    });
  }

  Widget _buildTrainingCard(TrainingOpportunity training) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showTrainingParticipants(training),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    training.title??"",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Chip(
                    label: Text('${training.participants?.length} مشارك'),
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                training.description?? '',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاريخ البدء:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                       intl.DateFormat('dd/MM/yyyy').format(training.startDate??DateTime.now()),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تاريخ الانتهاء:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        intl.DateFormat('dd/MM/yyyy').format(training.endDate??DateTime.now()),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(TrainingCourse course) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showCourseParticipants(course),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Chip(
                    label: Text('${course.participants?.length} مشارك'),
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                course.description,
                style: TextStyle(color: Colors.grey[600]),
              ),
              Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاريخ البدء:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        intl.DateFormat('dd/MM/yyyy').format(course.startDate??DateTime.now()),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تاريخ الانتهاء:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        intl.DateFormat('dd/MM/yyyy').format(course.endDate??DateTime.now()),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
             /* SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _exportAllCertificates(course.id, 'course'),
                    child: Text('تصدير جميع الشهادات'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                      side: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  void _showTrainingParticipants(TrainingOpportunity training) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              'مشاركون في التدريب',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: training.participants?.length,
                itemBuilder: (context, index) {
                  final participant = training.participants![index];
                  return ListTile(
                    leading: CircleAvatar(
                      child:  Icon(Icons.person
                          ,color: Colors.white,
                      )  ,
                    ),
                    title: Text(participant.name),
                    subtitle: Text(participant.email),
                    trailing: IconButton(
                      icon: Icon(Icons.picture_as_pdf, color: theme.primaryColor),
                      onPressed: () => _generateCertificate(
                        participant.id??"",
                        training.id??"",
                        'training',
                        participant.name,
                        training.title??"",
                        DateTime.now()
                      ),
                    ),
                  );
                },
              ),
            ),
          /*  ElevatedButton(
              onPressed: () => _exportAllCertificates(training.id, 'training'),
              child: Text('تصدير جميع الشهادات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                minimumSize: Size(double.infinity, 50),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void _showCourseParticipants(TrainingCourse course) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              'مشاركون في الدورة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: course.participants?.length,
                itemBuilder: (context, index) {
                  final participant = course.participants![index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(course.participants![index].name[0]),
                    ),
                    title: Text(participant.name),
                    subtitle: Text(participant.email),
                    trailing: IconButton(
                      icon: Icon(Icons.picture_as_pdf, color: theme.primaryColor),
                      onPressed: () => _generateCertificate(
                        participant.id??"",
                        course.id??"",
                        'course',
                        participant.name,
                        course.title,
                        DateTime.now()
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _generateCertificate(
      String studentId,
      String itemId,
      String type,
      String studentName,
      String itemTitle,
      DateTime endDate
      ) {
    Get.to(() => CertificateView(
      duration: '25 ساعة',
      studentName: studentName,
      trainingTitle: itemTitle,
      endDate: endDate ,
    ));
  }


}