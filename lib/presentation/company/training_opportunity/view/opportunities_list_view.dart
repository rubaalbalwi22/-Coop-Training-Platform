// company/views/opportunities_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../controller/training_opportunity_controller.dart';
import '../model/training_opportunity_model.dart';
import 'create_opportunity_view.dart';

class OpportunitiesListView extends GetWidget<TrainingOpportunityController>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فرص التدريب الخاصة بي'),
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(() => OpportunityFormView());
            },
          ),
        ],
      ),
      body: Obx(()=>controller.flowState.value.getScreenWidget(_body(), (){
        controller.fetchOpportunities();
      })),
    );
  }
_body() {

  if (controller.opportunities.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline, size: 60, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'لا توجد فرص تدريب مضافة بعد',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.to(() => OpportunityFormView());
            },
            child: Text('إضافة فرصة تدريب جديدة'),
          ),
        ],
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: controller.fetchOpportunities,
    color: theme.primaryColor,
    child: ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: controller.opportunities.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final opportunity = controller.opportunities[index];
        return _buildOpportunityCard(opportunity);
      },
    ),
  );
}
  Widget _buildOpportunityCard(TrainingOpportunity opportunity) {
    final statusColor = opportunity.status == 'approved'
        ? Colors.green
        : opportunity.status == 'rejected'
        ? Colors.red
        : Colors.orange;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // الذهاب إلى تفاصيل الفرصة
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    opportunity.title??"",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      opportunity.status == 'approved'
                          ? 'مقبولة'
                          : opportunity.status == 'rejected'
                          ? 'مرفوضة'
                          : 'قيد المراجعة',
                      style: TextStyle(color: statusColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'النوع: ${opportunity.type}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                'الوضع: ${opportunity.mode}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              if (opportunity.mode == 'حضوري') ...[
                SizedBox(height: 4),
                Text(
                  'الموقع: ${opportunity.location}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
              Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'عدد الساعات:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${opportunity.durationHours}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'عدد المقاعد:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${opportunity.capacity}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'الحالة:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        opportunity.status == 'approved'
                            ? 'مفعلة'
                            : opportunity.status == 'rejected'
                            ? 'مرفوضة'
                            : 'معلقة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(onPressed:() {
                      Get.to(OpportunityFormView(isEditMode: true ,
                      opportunityId: opportunity.id,));
                  }, icon: Icon(Icons.edit))
                ],
              ),
              if (opportunity.status == 'rejected' && opportunity.rejectionReason != null) ...[
                Divider(height: 20, thickness: 1),
                Text(
                  'سبب الرفض:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(opportunity.rejectionReason!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}