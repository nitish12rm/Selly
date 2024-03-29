import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellingportal/data/data_repository/product_repository.dart';
import 'package:sellingportal/data/model/product_model.dart';
import 'package:sellingportal/logic/cubits/products/Product_state.dart';
import 'package:sellingportal/logic/cubits/user/userToke.dart';
import 'package:sellingportal/logic/cubits/user/user_cubit.dart';
import 'package:sellingportal/logic/cubits/user/user_state.dart';

class ProductCubit extends Cubit<ProductState> {
 final  UserCubit? userCubit;
  StreamSubscription? _userSubscription;

  ProductCubit({ this.userCubit}) : super(ProductInitialState()) {
    _handUserState(userCubit!.state);

    _userSubscription = userCubit!.stream.listen(_handUserState);
  }

  void _handUserState(UserState userState) {
    if (userState is UserLoggedInState) {
      initialize(UserToken.token.toString());
    } else if (userState is UserLoggedOutState) {
      emit(ProductInitialState());
    }
  }

  final ProductRepository _productRepository = ProductRepository();

  void initialize(String BEARER_TOKN) async {
    emit(ProductLoadingState(state.products));
    try {
      List<ProductModel> products =
          await _productRepository.FetchAllProduct(BEARER_TOKN);
      products.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      emit(ProductLoadedState(products));
    } catch (error) {
      emit(ProductErrorState(error.toString(), state.products));
    }
  }

 void Search(String BEARER_TOKEN,String query) async {
   emit(ProductLoadingState(state.products));
   try {
     List<ProductModel> products =
     await _productRepository.Search(query, BEARER_TOKEN);
     products.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
     emit(ProductLoadedState(products));
   } catch (error) {
     emit(ProductErrorState(error.toString(), state.products));
   }
 }
}
