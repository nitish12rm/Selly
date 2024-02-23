import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sellingportal/data/data_repository/product_repository.dart';
import 'package:sellingportal/data/model/product_model.dart';
import 'package:sellingportal/logic/cubits/my%20wish%20lis/myWishList_state.dart';
import 'package:sellingportal/logic/cubits/my%20wish%20lis/mywishlist_cubit.dart';
import 'package:sellingportal/logic/cubits/myItems/myItems_cubit.dart';
import 'package:sellingportal/logic/cubits/user/userToke.dart';
import 'package:sellingportal/logic/cubits/user/user_cubit.dart';
import 'package:sellingportal/logic/cubits/user/user_state.dart';
import 'package:sellingportal/logic/services/format.dart';
import 'package:sellingportal/res/colors/colors.dart';
import 'package:sellingportal/res/drawable/backgroundWave.dart';
import 'package:telegram/telegram.dart';

class productScreen extends StatefulWidget {
  ProductModel productModel;

  productScreen({super.key, required this.productModel});

  @override
  static const String routeName = 'productScreen';

  @override
  State<productScreen> createState() => _productScreenState();
}

class _productScreenState extends State<productScreen> {
  Colours uiColor = Colours();

  Widget build(BuildContext context) {
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    late UserLoggedInState? userState;
    if (userCubit.state is UserLoggedInState) {
      userState = userCubit.state as UserLoggedInState;
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255 , 255, 255, 10),

      appBar: AppBar(
        backgroundColor: Color.fromRGBO(
          74,
          67,
          236,
          1,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  BackgroundWave(
                      colors: Color.fromRGBO(23, 16, 193, 1),
                      height: height * .30),
                  BackgroundWave(
                      height: height * .22,
                      colors: Color.fromRGBO(
                        53,
                        45,
                        229,
                        1,
                      )),
                  BackgroundWave(
                      height: height * .14,
                      colors: Color.fromRGBO(
                        74,
                        67,
                        236,
                        1,
                      )),
                  Positioned(
                    top: 30,
                    left: width / 4,
                    child: SizedBox(
                      height: height * .19,
                      width: 200,
                      child: CarouselSlider.builder(
                        slideIndicator: CircularSlideIndicator(currentIndicatorColor: Colors.white),
                        itemCount: widget.productModel.photos?.length ?? 0,
                        slideBuilder: (index) {
                          return Image.network(
                            widget.productModel.photos![index],
                            frameBuilder: (BuildContext context, Widget child,
                                int? frame, bool wasSynchronouslyLoaded) {
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
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Center(child: const Text('😢'));
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  // Container(
                  //   width: double.infinity,
                  //
                  //   height: height * .29,
                  //   child: Center(
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.all(Radius.circular(50)),
                  //       child:
                  //     ),
                  //   ),
                  // )
                ],
              ),
              //Stack khatam

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(widget.productModel.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        BlocBuilder<MyWishListCubit, MyWishListState>(
                            builder: (context, state) {
                          return IconButton(
                              onPressed: () {
                                if ((BlocProvider.of<MyWishListCubit>(context)
                                    .cartContains(widget.productModel))) {
                                  BlocProvider.of<MyWishListCubit>(context)
                                      .removeFromCart(widget.productModel);
                                } else {
                                  BlocProvider.of<MyWishListCubit>(context)
                                      .addToCart(widget.productModel);
                                }
                              },
                              icon: (BlocProvider.of<MyWishListCubit>(context)
                                      .cartContains(widget.productModel))
                                  ? Icon(
                                      FontAwesomeIcons.solidBookmark,
                                      size: 30,
                                    )
                                  : Icon(FontAwesomeIcons.bookmark, size: 30));
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Text('Jss Academy of Technical Education',
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal))),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 1,
                color: Color.fromRGBO(
                  12,
                  12,
                  12,
                  0.1,
                ),
              ),
              //line

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Flexible(
                      child: Text(
                        widget.productModel.description!,
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 1,
                color: Color.fromRGBO(
                  12,
                  12,
                  12,
                  0.1,
                ),
              ),
              //line

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Condition',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Flexible(
                      child: Text(
                        widget.productModel.condition!,
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 1,
                color: Color.fromRGBO(
                  12,
                  12,
                  12,
                  0.1,
                ),
              ),
              //line

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Use Period',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Flexible(
                      child: Text(
                        widget.productModel.usePeriod!,
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 1,
                color: Color.fromRGBO(
                  12,
                  12,
                  12,
                  0.1,
                ),
              ),
              //line

              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Defects',
              //         style:
              //             TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //       ),
              //       Text(
              //         'lorem ipsum',
              //         maxLines: 20,
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              // Text(
              //   'Simillar items',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: SizedBox(
              //     height: 250,
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: 4,
              //       shrinkWrap: false,
              //       itemBuilder: (BuildContext context, int index) {
              //         // return cardItem();
              //         return Container();
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomAppBar(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  Formatter.formatPrice(widget.productModel.price!),
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              (widget.productModel.listedBy == UserToken.id!)

                  ?ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(86, 105, 255, 1)),
                onPressed: _showAlertDialog,
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ):ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(86, 105, 255, 1)),
                onPressed: () => {
                  //to open telegram
                  //link-->user telegram username
                  Telegram.send(username: widget.productModel.link!),
                },
                child: Text(
                  'Chat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          title: const Text('Cancel booking'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to delete AD?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async{
                    await productRepository.Delete(
                    widget.productModel.sId!, UserToken.token!);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
