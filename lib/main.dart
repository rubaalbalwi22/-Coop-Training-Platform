import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:train_link/routes/app_routes.dart';
import 'package:train_link/theme/theme_helper.dart';
import 'core/utils/initial_bindings.dart';
import 'core/utils/logger.dart';
import 'core/utils/size_utils.dart';
import 'localization/app_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        translations: AppLocalization(),
        locale: Locale('ar', 'SA'),
        fallbackLocale:Locale('ar', 'SA'),
        title: 'Train Link',
        initialBinding: InitialBindings(),
        initialRoute: AppRoutes.initialRoute,
        getPages: AppRoutes.pages,
      );
    });
  }
}
