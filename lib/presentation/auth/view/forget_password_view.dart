import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../core/app_export.dart';
import '../controller/auth_controller.dart';

class ForgetPasswordView extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نسيت كلمة المرور', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () =>authController.forgetPasswordState.value.getScreenWidget(forgetPasswordBody(),(){
                authController.forgetPasswordState.value  = ContentState();
            }),
          )
        ),
      ),
    );
  }

  forgetPasswordBody()=> Form(
    key: authController.forgetPasswordFormKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 40),
        Icon(
          Icons.lock_reset,
          size: 100,
          color: Color(0xFF8417F4),
        ),
        SizedBox(height: 20),
        Text(
          'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 30),
        _buildEmailField(),
        SizedBox(height: 30),
        _buildResetButton(),
        SizedBox(height: 20),
        _buildBackToLogin(),
      ],
    ),
  );

  Widget _buildEmailField() {
    return TextFormField(
      controller: authController.forgetEmailController,
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
      } ,
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: () => authController.resetPassword(),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text('إرسال رابط التعيين', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildBackToLogin() {
    return TextButton(
      onPressed: () => Get.back(),
      child: Text(
        'العودة إلى تسجيل الدخول',
        textDirection: TextDirection.rtl,
        style: TextStyle(color: Color(0xFF8417F4)),
      ),
    );
  }
}