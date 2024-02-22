import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sellingportal/data/model/product_model.dart';
import 'package:sellingportal/logic/services/format.dart';
import 'package:sellingportal/presentation/screens/screen/home/productPage2.dart';

import '../../res/colors/colors.dart';

class cardItem extends StatelessWidget {
  final ProductModel productModel;

  @override
  cardItem({super.key, required this.productModel});

  Colours uiColor = Colours();

  @override
  Widget build(BuildContext context) {
    var Swidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        width: (Swidth / 2) - 10,
        // width: 200,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          onTap: () => {
            Navigator.pushNamed(context, productScreen.routeName,
                arguments: productModel),
          },
          child: Card(
            surfaceTintColor: Colors.white,
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: Container(
                          height: 130,
                          child: Center(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              child: Image.network(
                                      productModel.photos![0],
                                      frameBuilder: (BuildContext context,
                                          Widget child,
                                          int? frame,
                                          bool wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        }
                                        return AnimatedOpacity(
                                          opacity: frame == null ? 0 : 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeOut,
                                          child: child,
                                        );
                                      },
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {

                                  return const Text('😢');
                                },
                                    ),
                            ),
                          ),
                        )),
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Text(
                          productModel.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 17)
                        )),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Expanded(
                            child: Text(
                              Formatter.formatPrice(productModel.price!),

                              overflow: TextOverflow.ellipsis,
                              style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 14,color: Color.fromRGBO(0, 0, 0, 0.8)),
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
