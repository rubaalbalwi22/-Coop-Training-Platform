import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../../core/app_export.dart';
import '../controller/training_opportunity_controller.dart';

class OpportunityFormView extends GetWidget<TrainingOpportunityController> {
  final bool isEditMode;
  final String? opportunityId;

  const OpportunityFormView({
    Key? key,
    this.isEditMode = false,
    this.opportunityId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize for edit mode if needed
     if (isEditMode && opportunityId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadOpportunityForEdit(opportunityId!);
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'تعديل فرصة تدريب' : 'نشر فرصة تدريب جديدة'),
          backgroundColor: theme.primaryColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Obx(
            () =>
                controller.flowState.value.getScreenWidget(_body(context), () {
                  controller.flowState.value = ContentState();
                }),
          ),
        ),
      ),
    );
  }

  _body(context) => Form(
    key: controller.formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information Section
        _buildSectionHeader('معلومات أساسية'),
        SizedBox(height: 16),

        _buildTextField(
          controller: controller.titleController,
          label: 'عنوان فرصة التدريب',
          validator: (value) =>
              value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
        ),

        SizedBox(height: 16),

        _buildTextField(
          controller: controller.descriptionController,
          label: 'وصف الفرصة',
          maxLines: 4,
          validator: (value) =>
              value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
        ),

        // Training Details Section
        SizedBox(height: 24),
        _buildSectionHeader('تفاصيل التدريب'),
        SizedBox(height: 16),
        Obx(
          () => controller.isTrainingTypeLoading.value
              ? CircularProgressIndicator()
              : _buildDropdown(
                  label: 'نوع التدريب',
                  value: controller.selectedType.value,
                  items: controller.trainingTypes,
                  onChanged: (value) => controller.selectedType.value = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
        ),

        SizedBox(height: 16),

        _buildDropdown(
          label: 'وضع التدريب',
          value: controller.selectedMode.value,
          items: controller.trainingModes,
          onChanged: (value) => controller.selectedMode.value = value,
          validator: (value) =>
              value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
        ),

        SizedBox(height: 16),

        if (controller.selectedMode.value == 'حضوري')
          _buildTextField(
            controller: controller.locationController,
            label: 'موقع التدريب',
            validator: (value) =>
                value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
          ),

        SizedBox(height: 16),

        _buildTextField(
          controller: controller.durationController,
          label: 'عدد الساعات',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'هذا الحقل مطلوب';
            if (int.tryParse(value!) == null) return 'يجب أن يكون رقماً';
            return null;
          },
        ),

        SizedBox(height: 16),

        _buildTextField(
          controller: controller.capacityController,
          label: 'عدد المقاعد',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'هذا الحقل مطلوب';
            if (int.tryParse(value!) == null) return 'يجب أن يكون رقماً';
            return null;
          },
        ),

        // Dates Section
        SizedBox(height: 16),
        _buildSectionHeader('التواريخ'),
        SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                context: context,
                label: 'تاريخ البدء',
                date: controller.startDate.value,
                onTap: () => controller.selectStartDate(context),
                validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildDatePicker(
                context: context,
                label: 'تاريخ الانتهاء',
                date: controller.endDate.value,
                onTap: () => controller.selectEndDate(context),
                validator: (value) {
                  if (value == null) return 'هذا الحقل مطلوب';
                  if (controller.startDate.value != null &&
                      value.isBefore(controller.startDate.value!)) {
                    return 'يجب أن يكون بعد تاريخ البدء';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

        // Criteria Section
        SizedBox(height: 32),
        _buildSectionHeader('المعايير'),

        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.criteriaList.isNotEmpty)
                Text(
                  'المعايير المضافة:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

              ...controller.criteriaList.map(
                (criterion) => ListTile(
                  title: Text(criterion),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.criteriaList.remove(criterion),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.criteriaController,
                decoration: InputDecoration(
                  labelText: 'أدخل معيارًا',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: theme.primaryColor),
              onPressed: () {
                final text = controller.criteriaController.text.trim();
                if (text.isNotEmpty) {
                  controller.criteriaList.add(text);
                  controller.criteriaController.clear();
                }
              },
            ),
          ],
        ),

        // Submit Button
        SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => isEditMode
                ? controller.updateOpportunity(opportunityId!)
                : controller.submitOpportunity(),
            child: Text(
              isEditMode ? 'حفظ التعديلات' : 'نشر الفرصة',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: value.isEmpty ? null : value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: TextStyle(color: theme.primaryColor)),
        );
      }).toList(),
      onChanged: (value) => onChanged(value!),
      validator: validator,
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    String? Function(DateTime?)? validator,
  }) {
    return FormField<DateTime>(
      initialValue: date,
      validator: validator,
      builder: (formFieldState) {
        return InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              errorText: formFieldState.errorText,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null
                      ? '${date.day}/${date.month}/${date.year}'
                      : 'اختر التاريخ',
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        );
      },
    );
  }
}
