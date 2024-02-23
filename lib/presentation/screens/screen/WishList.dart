import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sellingportal/logic/cubits/my%20wish%20lis/myWishList_state.dart';
import 'package:sellingportal/logic/cubits/my%20wish%20lis/mywishlist_cubit.dart';
import 'package:sellingportal/logic/cubits/myItems/myItems_cubit.dart';
import 'package:sellingportal/logic/cubits/myItems/myitems_state.dart';
import 'package:sellingportal/logic/cubits/user/userToke.dart';
import 'package:sellingportal/presentation/screens/Auth/loginPage.dart';

import '../../../res/drawable/backgroundWave.dart';
import '../../widget/itemCard.dart';

class MyWishListScreen extends StatefulWidget {
  static const String routeName = 'WishListScreen';

  @override
  State<MyWishListScreen> createState() => _MyWishListScreenState();
}

class _MyWishListScreenState extends State<MyWishListScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255 , 255, 255, 100),

      appBar: AppBar(
        title: Text('My Wishlist',style: GoogleFonts.poppins(color: Colors.white),),
        backgroundColor: Color.fromRGBO(74, 67, 236, 1),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          setState(() {
            return BlocProvider.of<MyWishListCubit>(context).initialize(UserToken.id!);
          });
        },
        child: ListView(
          children: [
            BackgroundWave(
              height: 50,
              colors: Color.fromRGBO(74, 67, 236, 1),
            ),


            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: BlocBuilder<MyWishListCubit, MyWishListState>(
                  builder: (context, state) {
                    if (state is MyWishListLoadingState && state.mywshListItem.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is MyWIshListErrorState && state.mywshListItem.isEmpty) {
                      return Center(
                        child: Text(
                          state.message.toString(),
                        ),
                      );
                    }
                    if (state is MyWishListLoadedState && state.mywshListItem.isEmpty) {
                      return Center(
                        child: Text("No Wishlist 😢"),
                      );
                    }
                    return GridView.builder(
                      padding: EdgeInsets.only(bottom: 110),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.mywshListItem.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: .8,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final product = state.mywshListItem[index];
                        return cardItem(
                          productModel: product.product!,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // body: Column(
      //   children: [
      //     Stack(
      //       children: [
      //         Positioned(
      //           top: 0,
      //           left: 0,
      //           right: 0,
      //           child: Container(
      //             height: height * 0.20,
      //             child: BackgroundWave(
      //               height: height * 20,
      //               colors: Color.fromRGBO(74, 67, 236, 1),
      //             ),
      //           ),
      //         ),
      //         Positioned(
      //           top: 0,
      //           left: 0,
      //           right: 0,
      //           child: AppBar(
      //             backgroundColor: Color.fromRGBO(74, 67, 236, 1),
      //             title: Text(
      //               'My Items',
      //               style: commonTextsStyle(
      //                 fontsize: 20,
      //                 color: Colors.white,
      //               ), // You can use your commonTextsStyle here),
      //             ),
      //             // Add more app bar properties if needed
      //           ),
      //         ),
      //
      //       ],
      //     ),
      //
      //
      //
      //     Flexible(
      //       child: Container(
      //         child: BlocBuilder<MyItemsCubit,MyItemsState>(
      //           builder: (context,state){
      //             if (state is MyItemsLoadingState && state.products.isEmpty) {
      //               return Center(child: CircularProgressIndicator());
      //             }
      //             if (state is MyItemsErrorState && state.products.isEmpty) {
      //               return Center(
      //                 child: Text(state.message.toString(),),
      //               );
      //             }
      //             if (state is MyItemsLoadedState && state.products.isEmpty) {
      //               return Center(
      //                 child: Text("No product listed 😢"),
      //               );
      //             }
      //             return GridView.builder(
      //               padding: EdgeInsets.only(bottom: 110),
      //               // physics: NeverScrollableScrollPhysics(),
      //               itemCount: state.products.length,
      //               shrinkWrap: true,
      //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                 childAspectRatio: 0.8,
      //                 crossAxisCount: 2,
      //               ),
      //               itemBuilder: (BuildContext context, int index) {
      //                 final product = state.products[index];
      //                 return cardItem(productModel: product,);
      //               },
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      // Add the rest of your Scaffold properties here
    );
  }
}
