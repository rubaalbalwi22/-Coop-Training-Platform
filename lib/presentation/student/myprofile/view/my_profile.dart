import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../../core/utils/image_constant.dart';
import '../controller/my_profile_controller.dart';



class StudentProfileScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();
  final bool isEditing;

  StudentProfileScreen({this.isEditing = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
      
          title: Text(isEditing ? 'تعديل الملف الشخصي' : 'الملف الشخصي',
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ) ,
              textDirection: TextDirection.rtl),
          centerTitle: true,
          iconTheme: IconThemeData(color: theme.primaryColor),
          actions: [
            if (!isEditing)
              IconButton(
                icon: Icon(Icons.edit,color: theme.primaryColor,),
                onPressed: () => Get.to(() => StudentProfileScreen(isEditing: true)),
              ),
          ],
        ),
        body: Obx(
          () =>  profileController.flowState.value.getScreenWidget(_body(), (){
             profileController.flowState.value = ContentState();
          }),
        )
      ),
    );
  }

  _body()=>Form(
    key: _formKey,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
        //  _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildNameField(),
          const SizedBox(height: 15),
          _buildEmailField(),
          const SizedBox(height: 15),
          _buildPhoneField(),
          const SizedBox(height: 15),
          _buildUniversityField(),
          const SizedBox(height: 15),
          _buildSpecializationField(),
          const SizedBox(height: 15),
          if (isEditing) _buildPasswordFields(),
          const SizedBox(height: 15),
          _buildCvSection(),
          const SizedBox(height: 25),
          if (isEditing) _buildSaveButton(),
        ],
      ),
    ),
  );

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Obx(() =>  CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: profileController.profileImage.value != null
                  ? FileImage(profileController.profileImage.value!)
                  :  null,
              child: profileController.profileImage.value == null ?   Icon(Icons.person,size: 30,
                color: theme.primaryColor,) : null,
            )),
            if (isEditing)
              IconButton(
                icon:   Icon(Icons.camera_alt, color:  theme.primaryColor),
                onPressed: profileController.pickProfileImage,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          profileController.nameController.text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          'طالب',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: profileController.nameController,
      textDirection: TextDirection.rtl,
      readOnly: !isEditing,
      validator: (value) {
        if (value == null || value.isEmpty) return 'الاسم الكامل مطلوب';
        return null;
      },
      decoration: InputDecoration(
        labelText: 'الاسم الكامل',
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: profileController.emailController,
      textDirection: TextDirection.rtl,
      readOnly: true, // Email shouldn't be editable
      validator: (value) {
        if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
        if (!value.isEmail) return 'بريد إلكتروني غير صالح';
        return null;
      },
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: profileController.phoneController,
      textDirection: TextDirection.rtl,
      readOnly: !isEditing,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'رقم الهاتف مطلوب';
        if (value.length != 10) return 'يجب أن يكون 10 أرقام';
        if (!value.startsWith('05')) return 'يجب أن يبدأ بـ 05';
        return null;
      },
      decoration: InputDecoration(
        labelText: 'رقم الهاتف',
        prefixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildUniversityField() {
    return Obx(
          () => DropdownButtonFormField<String>(
        value: profileController.selectedUniversityId.value,
        decoration: InputDecoration(
          labelText: 'الجامعة',
          prefixIcon: const Icon(Icons.school),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: profileController.universities.map((university) {
          return DropdownMenuItem<String>(
            value: university.id,
            child: Text(
              university.name,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                 color: Colors.black
              ),
            ),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) return 'الجامعة مطلوبة';
          return null;
        },
        onChanged: isEditing ? (value) {
          profileController.selectedUniversityId.value = value!;
        } : null,
      ),
    );
  }

  Widget _buildSpecializationField() {
    return Obx(
          () => DropdownButtonFormField<String>(
        value: profileController.selectedSpecializationId.value,
        decoration: InputDecoration(
          labelText: 'التخصص',
          prefixIcon: const Icon(Icons.work),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: profileController.specializations.map((specialization) {
          return DropdownMenuItem<String>(
            value: specialization.id,
            child: Text(
              specialization.name,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) return 'التخصص مطلوب';
          return null;
        },
        onChanged: isEditing ? (value) {
          profileController.selectedSpecializationId.value = value!;
        } : null,
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        _buildCurrentPasswordField(),
        const SizedBox(height: 15),
        _buildNewPasswordField(),
        const SizedBox(height: 15),
        _buildConfirmPasswordField(),
      ],
    );
  }

  Widget _buildCurrentPasswordField() {
    return Obx(
          () => TextFormField(
        controller: profileController.currentPasswordController,
        textDirection: TextDirection.rtl,
        obscureText: profileController.hidePassword.value,
        validator: (value) {
          if ((value == null || value.isEmpty)&&profileController.newPasswordController.text.isNotEmpty) return 'كلمة المرور الحالية مطلوبة';
          return null;
        },
        decoration: InputDecoration(
          labelText: 'كلمة المرور الحالية',
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(profileController.hidePassword.value
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: profileController.togglePasswordVisibility,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return Obx(
          () => TextFormField(
        controller: profileController.newPasswordController,
        textDirection: TextDirection.rtl,
        obscureText: profileController.hidePassword.value,
        validator: (value) {
          if (value != null && value.isNotEmpty && value.length < 6) {
            return 'يجب أن تكون 6 أحرف على الأقل';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'كلمة المرور الجديدة (اختياري)',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(profileController.hidePassword.value
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: profileController.togglePasswordVisibility,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
          () => TextFormField(
        controller: profileController.confirmPasswordController,
        textDirection: TextDirection.rtl,
        obscureText: profileController.hidePassword.value,
        validator: (value) {
          if (profileController.newPasswordController.text.isNotEmpty &&
              value != profileController.newPasswordController.text) {
            return 'كلمة المرور غير متطابقة';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'تأكيد كلمة المرور الجديدة',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(profileController.hidePassword.value
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: profileController.togglePasswordVisibility,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildCvSection() {
    return isEditing ? _buildCvUploadField() : _buildCvView();
  }

  Widget _buildCvUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'السيرة الذاتية (PDF)',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: profileController.pickCvFile,
          child: Obx(() => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: profileController.cvFile.value == null
                    ? Colors.grey
                    : Colors.green,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_file),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    profileController.cvFile.value?.path.split('/').last ??
                        'اختر ملف السيرة الذاتية',
                    textDirection: TextDirection.rtl,
                  ),
                ),
                if (profileController.cvFile.value != null)
                  const Icon(Icons.check, color: Colors.green),
              ],
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildCvView() {
    return Obx(() {
      if (profileController.cvUrl.value.isEmpty) {
        return const Text(
          'لا يوجد سيرة ذاتية مرفقة',
          textDirection: TextDirection.rtl,
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'السيرة الذاتية',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: profileController.viewCv,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.red),
                  SizedBox(width: 8),
                  Text('عرض السيرة الذاتية', textDirection: TextDirection.rtl),
                  Spacer(),
                  Icon(Icons.chevron_left),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSaveButton() {
    return Obx(() {
      if (profileController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            profileController.updateProfile();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8417F4),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'حفظ التغييرات',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
    });
  }
}