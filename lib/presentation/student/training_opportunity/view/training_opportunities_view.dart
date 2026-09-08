// student/views/training_opportunities_view.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/presentation/company/training_course/model/training_course_model.dart';
import '../../../company/training_opportunity/model/training_opportunity_model.dart';
import '../../company_profile/view/company_profile_view.dart';
import '../controller/training_opportunities_controller.dart';
 import 'course_detail_view.dart';
import 'training_detail_view.dart';

class TrainingOpportunitiesView extends GetWidget<TrainingOpportunitiesController> {
  const TrainingOpportunitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'التدريبات والدورات',
            style: TextStyle(fontWeight: FontWeight.bold ,
            color: theme.primaryColor),
          ),
        /*  actions: [
           InkWell(
             onTap: () {
               Get.toNamed(AppRoutes.listOfMyCertificatesScreen);
             },
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20.0),
               child: Column(
                 children: [
                   Icon(Icons.card_giftcard,
                     color: theme.primaryColor,
                   ),
                   Text('شهاداتي',style: TextStyle(color: theme.primaryColor),)
                 ],
               ),
             ),
           )

          ],*/
          backgroundColor: Colors.white,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: theme.primaryColor,
            labelColor: theme.primaryColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.work), text: 'فرص التدريب'),
              Tab(icon: Icon(Icons.school), text: 'الدورات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTrainingOpportunitiesTab(),
            _buildCoursesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingOpportunitiesTab() {
    return Obx(()=>controller.trainingFlowState.value.getScreenWidget(_body(), (){
      controller.fetchOpportunities();
    }));
  }

  _body()=>Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(
          () =>controller.isSpecializationLoaded.value ? Center(child
          : CircularProgressIndicator(),)
      : DropdownButtonFormField<int>(
            value: controller.selectedSpecialization.value,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (int? newValue) {
              controller.changeSpecialization(newValue??0);
            },
            items: List.generate(controller.specializations.length, (index) {
              return DropdownMenuItem<int>(
                value: index,
                child: Text(controller.specializations[index]),
              );
            }),
          ),
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: controller.fetchOpportunities,
          color: theme.primaryColor,
          child: controller.opportunities.isEmpty? Center(child: Text('لا توجد فرص تدريب')): ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: controller.opportunities.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final opportunity = controller.opportunities[index];
              return _buildTrainingOpportunityCard(opportunity);
            },
          ),
        ),
      ),
    ],
  );
  Widget _buildCoursesTab() {
    return Obx(()=>controller.coursesFlowState.value.getScreenWidget(_body2(), () {
      controller.fetchCourses();
    }));
  }
  _body2()=> Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(
              () =>controller.isSpecializationLoaded.value ? Center(child
              : CircularProgressIndicator(),)
              : DropdownButtonFormField<int>(
            value: controller.selectedSpecialization.value,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,

            style: TextStyle(color: Colors.deepPurple),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (int? newValue) {
              controller.changeSpecialization(newValue??0);
            },
            items: List.generate(controller.specializations.length, (index) {
              return DropdownMenuItem<int>(
                value: index,
                child: Text(controller.specializations[index]),
              );
            }),
          ),
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: controller.fetchCourses,
          color: theme.primaryColor,
          child: controller.courses.isEmpty? Center(child: Text('لا توجد دورات')): ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: controller.courses.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final course = controller.courses[index];
              return _buildCourseCard(course);
            },
          ),
        ),
      ),
    ],
  );

  Widget _buildTrainingOpportunityCard(TrainingOpportunity opportunity) {
    return  Card(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(opportunity.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),*/
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              opportunity.title??"",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: opportunity.isActive??false
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              opportunity.isActive??false ? 'متاحة' : 'مغلقة',
                              style: TextStyle(
                                color: opportunity.isActive??false
                                    ? Colors.green
                                    : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                         // Get.to(() => CompanyProfileView(companyId: '0'));
                        },
                        child: Text(
                          opportunity.companyName??"",
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ),
                      SizedBox(height: 4),
                     /* SizedBox(height: 4),
                      Text(
                        opportunity.,
                        style: TextStyle(color: Colors.grey[600]),
                      ),*/
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(opportunity.location??""),
                          SizedBox(width: 16),
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('${opportunity.durationHours} ساعات'),
                          Spacer(),
                          TextButton(
                            onPressed: () {

                              Get.to(() => TrainingDetailView(opportunity: opportunity));
                            },
                            child: Text(
                              'المزيد',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'يبدأ في:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${opportunity.startDate?.day}/${opportunity.startDate?.month}/${opportunity.startDate?.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ينتهي في:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${opportunity.endDate?.day}/${opportunity.endDate?.month}/${opportunity.endDate?.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'المقاعد:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${opportunity.capacity}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),

          ],
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(course.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              course.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: course.isActive
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              course.isActive ? 'متاحة' : 'مغلقة',
                              style: TextStyle(
                                color: course.isActive
                                    ? Colors.green
                                    : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        course.category,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(course.level),
                          SizedBox(width: 16),
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('${course.duration} أسابيع'),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Get.to(() => CourseDetailView(course: course));
                            },
                            child: Text(
                              'المزيد',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'يبدأ في:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${course.startDate.day}/${course.startDate.month}/${course.startDate.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ينتهي في:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${course.endDate.day}/${course.endDate.month}/${course.endDate.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'المقاعد:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${course.maxParticipants}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: theme.primaryColor.withOpacity(0.1),
      visualDensity: VisualDensity.compact,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}