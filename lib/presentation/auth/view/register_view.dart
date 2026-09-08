import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../core/utils/image_constant.dart';
import '../../../routes/app_routes.dart';
import '../controller/auth_controller.dart';

class RegisterView extends StatelessWidget {
  final AuthController authController = Get.find();
  final _formKey = GlobalKey<FormState>();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء حساب جديد', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Obx(
        () => authController.registerState.value.getScreenWidget( _registerBody(),(){
          if(authController.registerState.value is SuccessState){
            Get.back();
          }
          authController.registerState.value = ContentState();
        }),
      ),
    );
  }

  _registerBody()=> Form(
    key: _formKey,
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Image.asset(ImageConstant.imgLogo, height: 150),
            SizedBox(height: 20),
            _buildUserTypeSelector(),
            SizedBox(height: 15),
            _buildNameField(),
            SizedBox(height: 15),
            _buildEmailField(),
            SizedBox(height: 15),
            _buildPhoneField(),
            SizedBox(height: 15),
            _buildPasswordField(),
            SizedBox(height: 15),
            _buildConfirmPasswordField(),
            if (authController.userType.value == 'company') ...[
              SizedBox(height: 15),
              _buildCompanyFields(),
            ] else ...[
              SizedBox(height: 15),
              _buildStudentFields(),
            ],
            SizedBox(height: 25),
            _buildRegisterButton(),
            SizedBox(height: 20),
            _buildLoginRedirect(),
          ],
        ),
      ),
    ),
  );

  Widget _buildUserTypeSelector() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نوع الحساب',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: Text('طالب', textDirection: TextDirection.rtl),
                  selected: authController.userType.value == 'student',
                  onSelected: (selected) {
                    if (selected) authController.setUserType('student');
                  },
                  selectedColor: Color(0xFF8417F4),
                  labelStyle: TextStyle(
                    color: authController.userType.value == 'student'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ChoiceChip(
                  label: Text('شركة', textDirection: TextDirection.rtl),
                  selected: authController.userType.value == 'company',
                  onSelected: (selected) {
                    if (selected) authController.setUserType('company');
                  },
                  selectedColor: Color(0xFF8417F4),
                  labelStyle: TextStyle(
                    color: authController.userType.value == 'company'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: authController.registerNameController,
      textDirection: TextDirection.rtl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الاسم الكامل مطلوب';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'الاسم الكامل',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: authController.registerEmailController,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'البريد الإلكتروني مطلوب';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'البريد الإلكتروني غير صحيح';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: authController.registerPhoneController,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'رقم الهاتف مطلوب';
        }
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'رقم الهاتف يجب أن يكون 10 أرقام';
        }

        if (!RegExp(r'^05[0-9]{8}$').hasMatch(value)) {
          return 'رقم الهاتف يجب أن يبدأ ب 05';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'رقم الهاتف',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        controller: authController.registerPasswordController,
        textDirection: TextDirection.rtl,
        obscureText: authController.hidePassword.value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'كلمة المرور مطلوبة';
          }
          if (value.length < 6) {
            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'كلمة المرور',
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              authController.hidePassword.value
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () => authController.togglePasswordVisibility(),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => TextFormField(
        controller: authController.registerConfirmPasswordController,
        textDirection: TextDirection.rtl,
        obscureText: authController.hidePassword.value,
        validator: (value) {
          if (value != authController.registerPasswordController.text) {
            return 'كلمة المرور غير متطابقة';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'تأكيد كلمة المرور',
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              authController.hidePassword.value
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () => authController.togglePasswordVisibility(),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildCompanyFields() {
    return Column(
      children: [
        TextFormField(
          controller: authController.companyNameController,
          textDirection: TextDirection.rtl,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'اسم الشركة مطلوب';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'اسم الشركة',
            prefixIcon: Icon(Icons.business),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: authController.companyAddressController,
          textDirection: TextDirection.rtl,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'عنوان الشركة مطلوب';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'عنوان الشركة',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: authController.companyWebsiteController,
          textDirection: TextDirection.rtl,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: 'الموقع الإلكتروني (اختياري)',
            prefixIcon: Icon(Icons.language),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: authController.companyRegisterNumberController,
          textDirection: TextDirection.rtl,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'رقم السجل التجاري مطلوب';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'رقم السجل التجاري',
            prefixIcon: Icon(Icons.numbers),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: authController.companyDescriptionController,
          textDirection: TextDirection.rtl,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'وصف الشركة',
            prefixIcon: Icon(Icons.description),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        _buildCompanyLogoField(), // Add this at the top

      ],
    );
  }

  Widget _buildStudentFields() {
    return Column(
      children: [
        Obx(
          () => authController.isUniversityLoading.value ? Center(child: CircularProgressIndicator()) : DropdownButtonFormField<String>(
            value: authController.selectedUniversityId.value == '0'
                ? null
                : authController.selectedUniversityId.value,
            decoration: InputDecoration(
              labelText: 'الجامعة',
              prefixIcon: Icon(Icons.school),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: authController.universities.map((university) {
              return DropdownMenuItem<String>(
                value: university.id,
                child: Text(
                  university.name,
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.rtl,
                ),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value == '0') {
                return 'الجامعة مطلوبة';
              }
              return null;
            },
            onChanged: (value) {
              authController.selectedUniversityId.value = value!;
            },
          ),
        ),
        SizedBox(height: 15),
        Obx(
          () => authController.isSpecializationLoading.value ? Center(child: CircularProgressIndicator()) : DropdownButtonFormField<String>(
            value: authController.selectedSpecializationId.value == '0'
                ? null
                : authController.selectedSpecializationId.value,
            decoration: InputDecoration(
              labelText: 'التخصص',
              prefixIcon: Icon(Icons.work),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: authController.specializations.map((specialization) {
              return DropdownMenuItem<String>(
                value: specialization.id,
                child: Text(
                  specialization.name,
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.rtl,
                ),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value == '0') {
                return 'التخصص مطلوب';
              }
              return null;
            },
            onChanged: (value) {
              authController.selectedSpecializationId.value = value!;
            },
          ),
        ),
        SizedBox(height: 15),
        _buildCvUploadField(),
      ],
    );
  }

  Widget _buildCvUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السيرة الذاتية (PDF)',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Obx(
          () => InkWell(
            onTap: () => authController.pickCvFile(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: authController.cvFile.value == null
                      ? Colors.grey[400]!
                      : Colors.green,
                  width: 1.5,
                ),
                color: Colors.grey[50],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.attach_file,
                    color: authController.cvFile.value == null
                        ? Colors.grey
                        : Colors.green,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        authController.cvFile.value != null
                            ? authController.cvFile.value!.path.split('/').last
                            : 'اضغط لاختيار ملف السيرة الذاتية',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: authController.cvFile.value == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (authController.cvFile.value != null)
                    Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Obx(
          () =>
              authController.cvFile.value == null &&
                  authController.userType.value == 'student'
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'يجب اختيار ملف السيرة الذاتية بصيغة PDF',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : SizedBox(),
        ),
        if (authController.cvFile.value != null) ...[
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => authController.pickCvFile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF8417F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Color(0xFF8417F4)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text('تغيير الملف', style: TextStyle(fontSize: 14)),
          ),
        ],
      ],
    );
  }
  Widget _buildCompanyLogoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'شعار الشركة (صورة)',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Obx(() => InkWell(
          onTap: () => authController.pickCompanyLogo(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: authController.companyLogo.value == null
                    ? Colors.grey[400]!
                    : Colors.green,
                width: 1.5,
              ),
              color: Colors.grey[50],
            ),
            child: Column(
              children: [
                if (authController.companyLogo.value != null)
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(authController.companyLogo.value!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: authController.companyLogo.value == null
                          ? Colors.grey
                          : Colors.green,
                    ),
                    SizedBox(width: 8),
                    Text(
                      authController.companyLogo.value != null
                          ? 'تم اختيار الشعار'
                          : 'اضغط لاختيار شعار الشركة',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: authController.companyLogo.value == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    if (authController.companyLogo.value != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        )),
        SizedBox(height: 4),
        Obx(() => authController.companyLogo.value == null &&
            authController.userType.value == 'company'
            ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            'يجب اختيار شعار للشركة (JPG, PNG)',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        )
            : SizedBox()),
        if (authController.companyLogo.value != null) ...[
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => authController.pickCompanyLogo(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF8417F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Color(0xFF8417F4)),
              ),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              'تغيير الشعار',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ],
    );
  }
  Widget _buildRegisterButton() {
    return  ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  authController.register();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8417F4),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'إنشاء حساب',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
  }

  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('لديك حساب بالفعل؟', textDirection: TextDirection.rtl),
        TextButton(
          onPressed: () {
            authController.clearRegisterForm();
            Get.back();
          },
          child: Text(
            'تسجيل الدخول',
            style: TextStyle(color: Color(0xFF8417F4)),
          ),
        ),
      ],
    );
  }
}
