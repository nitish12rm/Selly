import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sellingportal/data/model/category_model.dart';
import 'package:sellingportal/logic/cubits/category_product/category_product_cubit.dart';
import 'package:sellingportal/logic/cubits/category_product/category_product_state.dart';
import 'package:sellingportal/presentation/screens/screen/sellFormScreens/CustomInput.dart';
import 'package:sellingportal/res/drawable/backgroundWave.dart';

import '../../../../logic/cubits/products/Product_state.dart';
import '../../../../logic/cubits/products/product_cubit.dart';
import '../../../widget/itemCard.dart';
class categoryPage extends StatefulWidget {
  const categoryPage({super.key});
static const String routeName = "categoryPage";
  @override
  State<categoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {

  @override

  Widget build(BuildContext context) {
final cubit = BlocProvider.of<CategoryProductCubit>(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(cubit.category.title!,style: GoogleFonts.poppins(fontSize: 20,color: Colors.white),),
        backgroundColor: Color.fromRGBO(74, 67, 236, 1),
      ),
      body:  ListView(
        children: [
          BackgroundWave(
            colors: Color.fromRGBO(74, 67, 236, 1),
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              child: BlocBuilder<CategoryProductCubit,CategoryProductState>(
                  builder: (context,state) {
                    if (state is CategoryProductLoadingState && state.products.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is CategoryProductErrorState && state.products.isEmpty) {
                      return Center(
                        child: Text(state.message.toString(),),
                      );
                    }
                    if (state is CategoryProductLoadedState && state.products.isEmpty) {
                      return Center(
                        child: Text("No product listed 😢"),
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
      )
    );
  }
}
