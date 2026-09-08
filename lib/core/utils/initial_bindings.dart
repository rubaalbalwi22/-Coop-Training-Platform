import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';
import 'package:train_link/data/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:train_link/data/client_service/client_service_api.dart';
import 'package:train_link/data/company_remote_data_source/company_remote_data_source.dart';

import '../../data/user_remote_data_source/user_remote_data_source.dart';
import '../app_export.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PrefUtils());
    Get.put(ClientServiceApi());
    Get.put(
      AuthRemoteDataSourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        firebaseFirestore: FirebaseFirestore.instance,
        clientServiceApi: Get.find<ClientServiceApi>(),
      ),
    );
    Get.put(
      AdminRemoteDataSourceImpl(firebaseFirestore: FirebaseFirestore.instance),
    );
    Get.put(
      CompanyRemoteDataSourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        clientServiceApi:  Get.find<ClientServiceApi>(),
        firebaseFirestore: FirebaseFirestore.instance,
      ),
    );
    Get.put(
      UserRemoteDataSourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        clientServiceApi:  Get.find<ClientServiceApi>(),
        firebaseFirestore: FirebaseFirestore.instance,
      ),
    );

  }

}
