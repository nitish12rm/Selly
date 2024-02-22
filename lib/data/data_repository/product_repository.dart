import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/api.dart';
import '../model/product_model.dart';

class ProductRepository {
  Api _api = Api();

  Future<List<ProductModel>> FetchAllProduct(String BEARER_TOKEN) async {
    try {
      Response response = await _api.sendRequest.get(
          'user/listing/showAllListing',
          options: Options(headers: {'Authorization': BEARER_TOKEN}));
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return (apiResponse.data as List<dynamic>)
          .map((json) => ProductModel.fromJson(json))
          .toList();
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

  Future<List<ProductModel>> FetchMyItems(String userId,String BEARER_TOKEN) async {
    try {
      Response response = await _api.sendRequest.get(
          'user/profile/listings/${userId}',
          options: Options(headers: {'Authorization': BEARER_TOKEN}));
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return (apiResponse.data as List<dynamic>)
          .map((json) => ProductModel.fromJson(json))
          .toList();
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

  // Future<List<ProductModel>> FetchProductByCategory(
  //     String categoryId, String TOKEN) async {
  //   try {
  //     Response response = await _api.sendRequest.get(
  //       'user/listing/getListing/category/${categoryId}',
  //       options: Options(headers: {'Authorization': TOKEN}),
  //     );
  //     ApiResponse apiResponse = ApiResponse.fromResponse(response);
  //     if (!apiResponse.success) {
  //       throw apiResponse.message.toString();
  //     }
  //     return (apiResponse.data as List<dynamic>).map((json) => ProductModel.fromJson(json)).toList();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  Future<List<ProductModel>> FetchProductByCategory(
      String categoryId, String TOKEN) async {
    try {
      Response response = await _api.sendRequest.get(
        'user/listing/getListing/category/${categoryId}',
        options: Options(headers: {'Authorization': TOKEN}),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      log('product by categ-after success');
      return (apiResponse.data as List<dynamic>).map((json) => ProductModel.fromJson(json)).toList();
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

  Future<ProductModel> AddProducts(
      ProductModel productModel, String BEARER_TOKEN) async {
    try {
      Response response = await _api.sendRequest.post(
        'user/listing/create',
        options: Options(headers: {'Authorization': BEARER_TOKEN}),
        data: jsonEncode(productModel.toJson(),),
      );
      // log(productModel.toJson().toString());
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        log(apiResponse.message.toString());
        throw apiResponse.message.toString();
      }
      return ProductModel.fromJson(apiResponse.data);
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
  //search
Future<List<ProductModel>> Search(String query, String BEARER_TOKEN) async{
    Map<String,dynamic> data = {
      'query':query,

    };
    Response response = await _api.sendRequest.get(
      'user/listing/searchListing',
      data: jsonEncode(data),
      options: Options(headers:  {'Authorization': BEARER_TOKEN})
    );
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if(!apiResponse.success){
      throw apiResponse.message.toString();
    }
    if(apiResponse.data!=null) {
      return (apiResponse.data as List<dynamic>).map((json) => ProductModel.fromJson(json)).toList();

    }
    return [];
}
//Delete
  Future<String> Delete(String productId, String BEARER_TOKEN) async{
    Response response = await _api.sendRequest.delete(
        'user/listing//delete/${productId}',
        options: Options(headers:  {'Authorization': BEARER_TOKEN})
    );
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if(!apiResponse.success){
      return apiResponse.message.toString();
    }
    return 'something went wrong';

  }
}
