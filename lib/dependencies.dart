import 'package:get/get.dart';
import 'package:rice_leaf_disease_detection_flutter/api_client.dart';
import 'package:rice_leaf_disease_detection_flutter/app_constants.dart';
import 'package:rice_leaf_disease_detection_flutter/controller.dart';

Future<void> init() async{

  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl));

  Get.lazyPut(() => UploadController());
}