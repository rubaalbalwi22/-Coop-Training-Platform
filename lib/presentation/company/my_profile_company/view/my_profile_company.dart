import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app_export.dart';
import '../controller/my_profile_company_controller.dart';

class CompanyProfileView extends StatelessWidget {
  final CompanyProfileController controller = Get.put(
    CompanyProfileController(),
  );

  CompanyProfileView({super.key});
  RxBool isEditing = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملف الشركة', textDirection: TextDirection.rtl),
        backgroundColor: Color(0xFF8417F4),
        actions: [
          Obx(
            () =>  IconButton(
              icon: Icon(!isEditing.value ? Icons.edit_off : Icons.edit),
              onPressed: () {
                isEditing.value = !isEditing.value;
              },
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildSectionTitle('شعار الشركة'),
              _buildLogoPicker(),

              _buildSectionTitle('معلومات الشركة'),
              _buildCard([
                _buildTextField(
                  controller.nameController,
                  'اسم الشركة',
                  Icons.business,
                ),
                _buildTextField(
                  controller.descriptionController,
                  'وصف الشركة',
                  Icons.description,
                  maxLines: 3,
                ),
                _buildTextField(
                  controller.locationController,
                  'العنوان',
                  Icons.location_on,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSectionTitle('بيانات التواصل'),
              _buildCard([
                _buildTextField(
                  controller.emailController,
                  'البريد الإلكتروني',
                  Icons.email,
                  readOnly:  true,

                ),
                _buildTextField(
                  controller.websiteController,
                  'الموقع الإلكتروني',
                  Icons.language,
                ),
                _buildTextField(
                  controller.phoneController,
                  'رقم الهاتف',
                  Icons.phone,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSectionTitle('بيانات رسمية'),
              _buildCard([
                _buildTextField(
                  controller.registerNumberController,
                  'رقم السجل التجاري',
                  Icons.numbers,
                ),
              ]),
              const SizedBox(height: 16),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: controller.updateProfile,
                icon: const Icon(Icons.save),
                label: const Text('تحديث البيانات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8417F4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
        bool readOnly = false
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly:isEditing.value ? true : readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 15),
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textDirection: TextDirection.rtl,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8417F4),
      ),
    );
  }

  Widget _buildLogoPicker() {
    return Obx(
      () => InkWell(
        onTap: () => controller.pickCompanyLogo(),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                controller.company.value?.companyLogo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          controller.company.value?.companyLogo??"",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    :
                controller.companyLogo.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          controller.companyLogo.value!,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                const SizedBox(height: 8),
                Text(
                  controller.companyLogo.value != null
                      ? 'تم اختيار شعار جديد'
                      : 'اضغط لاختيار شعار الشركة',
                  style: const TextStyle(color: Colors.black87),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
