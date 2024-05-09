import 'dart:convert';

import 'package:get/get.dart';
import 'package:rice_leaf_disease_detection_flutter/response_model.dart';
import 'package:http/http.dart' as http;

import 'app_constants.dart';

class UploadController extends GetxController{

  String? leafClass;
  String? confidence;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> uploadImage(String filePath) async {
    _isLoading = true;
    update();

    ResponseModel responseModel;
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConstants.baseUrl}${AppConstants.predictEndpoint}"),
      );

      // Attach the file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Field name for the file
          filePath,
        ),
      );

      // Send the request
      var streamedResponse = await request.send();

      // Convert the StreamedResponse to a Response
      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        responseModel = ResponseModel(true, 'success');
        // Decode the JSON response body
        var jsonResponse = jsonDecode(response.body);

        // Store the values in the leafClass and confidence variables
        leafClass = jsonResponse['class'];
        confidence = jsonResponse['confidence'].toString();
      }

      else {
        responseModel = ResponseModel(false, 'error');

      }
    } catch (e) {
      responseModel = ResponseModel(false, 'error');
    }

    _isLoading = false;
    update();
    return responseModel;
  }

}