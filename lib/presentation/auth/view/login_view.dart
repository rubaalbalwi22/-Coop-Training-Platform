import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../core/app_export.dart';
import '../controller/auth_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(()=>
             authController.loginState.value.getScreenWidget(_loginBody(),(){
               authController.loginState.value = ContentState();
            }),
          )
        ),
      ),
    );
  }
 _loginBody()=>Form(
   key: authController.loginFormKey,
   child: Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: [
       SizedBox(height: 40),
       Image.asset(
         ImageConstant.imgLogo,
         height: 150,
       ),
       SizedBox(height: 30),
       _buildEmailField(),
       SizedBox(height: 15),
       _buildPasswordField(),
       SizedBox(height: 10),
       Align(
         alignment: Alignment.centerLeft,
         child: TextButton(
           onPressed: () => Get.toNamed(AppRoutes.forgotPasswordScreen),
           child: Text(
             'نسيت كلمة المرور؟',
             textDirection: TextDirection.rtl,
             style: TextStyle(color: Color(0xFF8417F4)),
           ),
         ),
       ),
       SizedBox(height: 25),
       _buildLoginButton(),
       SizedBox(height: 20),
       _buildRegisterRedirect(),
     ],
   ),
 );
  Widget _buildEmailField() {
    return TextFormField(
      controller: authController.loginEmailController,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'البريد الإلكتروني مطلوب';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: authController.loginPasswordController,
      textDirection: TextDirection.rtl,
      obscureText: authController.hidePassword.value,
      validator: (value) {
          if (value == null || value.isEmpty) {
            return 'كلمة المرور مطلوبة';
          }
          return null;
      },
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(authController.hidePassword.value
              ? Icons.visibility_off
              : Icons.visibility),
          onPressed: () => authController.togglePasswordVisibility(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ));
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () => authController.login(),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text('تسجيل الدخول', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildRegisterRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ليس لديك حساب؟', textDirection: TextDirection.rtl),
        TextButton(
          onPressed: () {
            authController.clearLoginForm();
            Get.toNamed(AppRoutes.registerScreen);
          },
          child: Text(
            'إنشاء حساب جديد',
            style: TextStyle(color: Color(0xFF8417F4)),
          ),
        ),
      ],
    );
  }
}