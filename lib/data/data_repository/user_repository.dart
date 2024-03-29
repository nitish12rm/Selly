import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sellingportal/logic/cubits/user/userToke.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api.dart';
import '../model/user_model.dart';

class UserRepository {
  final Api _api = Api();

  Future<UserModel> createAccount({
    required String email,
    required String password,
    required String name,
    required int phoneNumber,
  }) async {
    try {
      Response response = await _api.sendRequest.post('user/auth/signup',
          data: jsonEncode({
            "name": name,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber
          }));
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      //agar manlo response galat aata h then we canm throw error
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      //convert this raw response data into user model
      return UserModel.fromJson(apiResponse.data);
    } on DioException catch(ex) {
      switch(ex.type){
        case DioExceptionType.connectionTimeout:
          throw 'Server not responding';
        case DioExceptionType.connectionError:
          throw 'Server not responding';
        case DioExceptionType.sendTimeout:
          throw 'Check network connection';
        case DioExceptionType.receiveTimeout:
          throw 'Check network connection';
        case DioExceptionType.badCertificate:
          throw 'badCertificate';
        case DioExceptionType.badResponse:
          throw 'Bad Response';
        case DioExceptionType.cancel:
          throw 'cancel';
        case DioExceptionType.unknown:
          throw 'Some Error occured';


      }
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await _api.sendRequest.post('user/auth/login',
          data: jsonEncode({"email": email, "password": password}));
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      List bearerToken = response.headers['Authorization']!;
      SharedPreferences sharedPreferencesInstance =
          await SharedPreferences.getInstance();
      await sharedPreferencesInstance.setString(
          'token', bearerToken[0].toString());

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      //convert this raw response data into user model
      return UserModel.fromJson(apiResponse.data);
    } on DioException catch(ex) {
      switch(ex.type){
        case DioExceptionType.connectionTimeout:
          throw 'Server not responding';
        case DioExceptionType.connectionError:
          throw 'Server not responding';
        case DioExceptionType.sendTimeout:
          throw 'Check network connection';
        case DioExceptionType.receiveTimeout:
          throw 'Check network connection';
        case DioExceptionType.badCertificate:
          throw 'badCertificate';
        case DioExceptionType.badResponse:
          throw 'Bad Response';
        case DioExceptionType.cancel:
          throw 'cancel';
        case DioExceptionType.unknown:
          throw 'Some Error occured';


      }
    }
  }

  Future<UserModel> updateUser(UserModel userModel) async {
    try {
      Response response = await _api.sendRequest.put(
          "user/auth/update/${userModel.sId}",
          data: jsonEncode(userModel.toJson())
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if(!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      return UserModel.fromJson(apiResponse.data);
    }on DioException catch(ex) {
      switch(ex.type){
        case DioExceptionType.connectionTimeout:
           throw 'connectionTimeout';
        case DioExceptionType.connectionError:
           throw 'connectionError';
        case DioExceptionType.sendTimeout:
           throw ' sendTimeout';
        case DioExceptionType.receiveTimeout:
           throw 'receiveTimeout';
        case DioExceptionType.badCertificate:
           throw 'badCertificate';
          case DioExceptionType.badResponse:
         throw 'badResponse';
        case DioExceptionType.cancel:
           throw 'cancel';
        case DioExceptionType.unknown:
           throw 'unknown';


      }
    }
  }
}

// List bearerToken = response.headers['Authorization']!;
// SharedPreferences sharedPreferencesInstance = await SharedPreferences.getInstance();
// await sharedPreferencesInstance.setString('token', bearerToken[0].toString());
