import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sellingportal/logic/cubits/category/category_cubit.dart';
import 'package:sellingportal/logic/cubits/category/category_state.dart';
import 'package:sellingportal/logic/cubits/products/Product_state.dart';
import 'package:sellingportal/logic/cubits/products/product_cubit.dart';
import 'package:sellingportal/logic/cubits/user/userToke.dart';
import 'package:sellingportal/logic/cubits/user/user_cubit.dart';
import 'package:sellingportal/presentation/widget/cards.dart';
import 'package:sellingportal/presentation/widget/itemCard.dart';
import 'package:sellingportal/presentation/widget/searchBar.dart';
import 'package:sellingportal/presentation/widget/sliverSearchBar.dart';

import '../../../../logic/cubits/user/user_state.dart';
import '../../../../res/drawable/backgroundWave.dart';
import '../../splash/splash_screen.dart';
import '../profile/profile_screen.dart';



class explorePage extends StatefulWidget {
  const explorePage({super.key});
static const String routeName = 'explorePage';

  @override
  State<explorePage> createState() => _explorePageState();
}

class _explorePageState extends State<explorePage> {
  @override
  Widget build(BuildContext context) {

    List<String> categName = [
      'Books',
      'Gadgets',
      'Room Essentials',
      'Kitchen Appliances'
    ];

    return BlocListener<UserCubit,UserState>(
      listener: (context,state){
        if(state is UserLoggedOutState){
          Navigator.pushReplacementNamed(context, SplashScreen.routeName);
        }
      },
      child: BlocBuilder<UserCubit,UserState>(
        builder: (context,state) {
          if(state is UserLoggedInState){
            return Scaffold(
                backgroundColor: Color.fromRGBO(255 , 255, 255, 100),
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: Text('Hi, ${state.userModel.name} 👋',style: GoogleFonts.poppins(color: Colors.white),),
                  ),
                  actions: [IconButton(onPressed: (){Navigator.pushNamed(context, ProfileScreen.routeName);}, icon: Icon(FontAwesomeIcons.user,color: Colors.white,)),Container(width: 8,)],
                  backgroundColor:Color.fromRGBO(74, 67, 236, 1) ,
                ),
                body: RefreshIndicator(
                  onRefresh: () async{

                    setState(() {
                      return BlocProvider.of<ProductCubit>(context).initialize(UserToken.token!);
                    });
                  },
                  child: ListView(

                    children: [
                      //Background wave
                      SizedBox(
                        height: 210,
                        child: Stack(
                          children: [
                            BackgroundWave(
                              colors: Color.fromRGBO(74, 67, 236, 1),
                              height: 150,
                            ),
                            Positioned(
                              top: MediaQuery.of(context).padding.top-30,
                              child: SearchBarCustom(),
                              left: 16,
                              right: 16,
                            ),
                            Positioned(
                              // top: MediaQuery.of(context).padding.top + 100,
                              top: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 85,
                                  child: BlocBuilder<CategoryCubit,CategoryState>(
                                    builder: (context,state) {
                                      if (state is CategoryLoadingState && state.categories.isEmpty) {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                      if (state is CategoryErrorState && state.categories.isEmpty) {
                                        return Center(
                                          child: Text(state.message.toString()),
                                        );
                                      }
                                      return (state.categories.isEmpty)?Container():ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 4,
                                        shrinkWrap: false,
                                        itemBuilder: (BuildContext context, int index) {
                                          final category = state.categories[index];
                                          return CardsCategory(
                                            index: index,
                                            categoryModel:category ,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //new i
                      Padding(
                        padding: const EdgeInsets.only( left: 10),
                        child: Text(
                          'New Items',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          child: BlocBuilder<ProductCubit,ProductState>(
                              builder: (context,state) {
                                if (state is ProductLoadingState && state.products.isEmpty) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (state is ProductErrorState && state.products.isEmpty) {
                                  return Center(
                                    child: Text(state.message.toString(),),
                                  );
                                }
                                return GridView.builder(
                                  padding: EdgeInsets.only(bottom: 110),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.products.length,
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.8,
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    final product = state.products[index];
                                    return cardItem(productModel: product,);
                                  },
                                );
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            );
          }
          if(state is UserLoadingState){
            return Center(child: CircularProgressIndicator(),);
          }
          return Container();
        }
      ),
    );
  }
}
