import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const BASE_URL = 'http://192.168.1.5:5000/api/';
const Map<String, dynamic>DEFAULT_HEADERS = {
  'content-type':'application/json'
};
class Api{
  final Dio _dio = Dio();
  Api(){
    _dio.options.baseUrl = BASE_URL;
    _dio.options.headers = DEFAULT_HEADERS;
    _dio.interceptors.add(PrettyDioLogger(
      responseHeader: true,
      responseBody: true,
      requestHeader: true,
      requestBody: true,
    ));

  }
  //getter
  Dio get sendRequest =>_dio;
}
class ApiResponse {

  bool success;
  dynamic data;
  String? message;

  ApiResponse({required this.success, this.data, this.message});

  factory ApiResponse.fromResponse(Response res){
    final data = res.data;
    return ApiResponse(
        success: data["success"],
        data: data["data"],
        message: data["message"] ?? "unexpected error",
    );
  }
}
