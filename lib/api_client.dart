import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService{
  late String token;
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl}){
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = '';
  }

  void updateHeader(String token){
    _mainHeaders = {
      'Authorization' : 'Token $token'
    };
  }


  Future<Response> postData(String uri, dynamic body ) async{
    try{
      Response response = await post(uri, body,);
      return response;
    }
    catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }
  }


  Future<Response> getData(String uri) async{
    try{
      Response response = await get(uri, headers: _mainHeaders);
      return response;
    }
    catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }
  }


  Future<Response> updateData(String uri, dynamic body) async{
    try{
      Response response = await patch(uri, body, headers: _mainHeaders);
      return response;
    }
    catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }
  }


  Future<Response> deleteData(String uri) async{
    try{
      Response response = await delete(uri, headers: _mainHeaders);
      return response;
    }
    catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

}