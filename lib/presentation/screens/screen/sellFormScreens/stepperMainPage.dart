import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellingportal/data/model/product_model.dart';
import 'package:sellingportal/logic/cubits/products/Product_state.dart';
import 'package:sellingportal/logic/cubits/products/productUpload_state.dart';
import 'package:sellingportal/logic/cubits/products/product_cubit.dart';
import 'package:sellingportal/logic/cubits/products/product_upload_cubit.dart';
import 'package:sellingportal/logic/cubits/user/user_cubit.dart';
import 'package:sellingportal/logic/cubits/user/user_state.dart';
import 'package:sellingportal/logic/services/preferences.dart';
import 'package:sellingportal/presentation/screens/screen/home/explorePage.dart';
import 'package:sellingportal/presentation/screens/screen/home/homescreen.dart';
import 'package:sellingportal/presentation/screens/screen/sellFormScreens/firebase/firebase_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../logic/cubits/user/userToke.dart';
import 'CustomInput.dart';
import 'CustomRadioBtn.dart';
import 'image_picker_button.dart';
import 'image_display_container.dart';

class FormPage extends StatefulWidget {
  static const String routeName = 'FormPage';

  String catId;
  FormPage({Key? key,required this.catId}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int currentStep = 0;
  List<String> _imagePaths = [];
  String _selectedCondition = 'New';
  bool _isUploading = false;

  void _updateImagePaths(List<String> paths) {
    setState(() {
      _imagePaths = paths;
    });
  }

  ProductModel productModel = ProductModel();
  TextEditingController photoController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    //useercubut
    UserCubit userCubit= BlocProvider.of<UserCubit>(context);
    late UserLoggedInState ?userState;
    if(userCubit.state is UserLoggedInState){
      userState = userCubit.state as UserLoggedInState;

    }
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 67, 236, 1),
        title: Text('Form' ,style:commonTextsStyle(fontsize: 20,color: Colors.white),),
        // Add more app bar properties if needed
      ),
      body: BlocListener<ProductUploadCubit,ProductUploadState>(

        listener: (context,state){
          if(state is ProductUploadLoadingState){
            log("uploading");
          }
          if(state is ProductUploadedState){
            SnackBar snackBar = SnackBar(content: Text('Uploaded!'),backgroundColor: Colors.green,);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            log('...........≥..uploaded..........');
            Timer(Duration(milliseconds: 200), () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, homeScreen.routeName);
            });

          }
          if(state is ProductUploadErrorState){
            log('in stepperpage: ${state.message.toString()}');
            SnackBar snackBar = SnackBar(content: Text('Upload fail!'),backgroundColor: Colors.red,);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: SafeArea(

          child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            if (state is UserLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UserErrorState) {
              return Center(
                child: Text(state.message.toString()),
              );
            }
            //USER LOGGED IN STATE...........DO STUFF HERE
            if (state is UserLoggedInState) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Stepper(

                  type: StepperType.horizontal,
                  currentStep: currentStep,
                  onStepCancel: () => currentStep == 0
                      ? null
                      : setState(() {
                    currentStep -= 1;
                  }),
                  onStepContinue: () async {
                    bool isLastStep = (currentStep == getSteps().length - 1);
                    if (isLastStep) {

                      setState(() {
                        _isUploading = true;
                      });

                      try{
                        if (_imagePaths!=null) {
                          UserState userState = BlocProvider.of<UserCubit>(context).state;
                          if(userState is UserLoggedInState){
                            var userId = userState.userModel.sId;

                            showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {return AlertDialog(content: Row(children: [CircularProgressIndicator(), SizedBox(width: 20), Text("Uploading Images..."),],),);},);

                            List<String> imageUrls = await uploadAndReturnImageUrls(userId!, _imagePaths);

                            Navigator.of(context).pop();

                            productModel.photos = imageUrls.isNotEmpty ? imageUrls : ["https://firebasestorage.googleapis.com/v0/b/selly-b1801.appspot.com/o/logo.png?alt=media&token=b7e5e875-eab8-4367-a0bc-1ef12c5a8495"];
                          }
                        }

                      }
                      catch(e){
                        print('An error occurred: $e');
                        Navigator.of(context).pop();
                      }

                      setState(() {
                        _isUploading = false;
                      });


                      // Do something with this information
                      // productModel.listedBy = state.userModel.sId;
                      productModel.category = widget.catId;
                      productModel.link = userState!.userModel.telegram_username;
                      BlocProvider.of<ProductUploadCubit>(context).addToProductListings(productModel,UserToken.token.toString());
                      // Navigator.pushReplacementNamed(context,explorePage.routeName );
                      // Navigator.pushReplacementNamed(context, homeScreen.routeName);

                    } else {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  },
                  onStepTapped: (step) => setState(() {
                    currentStep = step;
                  }),
                  steps: getSteps(),
                ),
              );
            }
            return Center(child: Text('an error occured'),);

          }),
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: Text("BOOK INFO", style: commonTextsStyle()),
        content: Column(
          children: [
            CustomInput(
              hint: "Add title*",
              inputBorder: OutlineInputBorder(),
              onChanged: (value) {
                productModel.title = value;
              },
            ),
            CustomInput(
              hint: "Describe the product*",
              inputBorder: OutlineInputBorder(),
              onChanged: (value) {
                productModel.description = value;
              },
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Condition', style: commonTextsStyle(fontsize: 12),),
                  SizedBox(height: 8),
                  CustomRadioButton(options: ['New', 'Slightly Used', 'Old'], onChanged: (condition) {
                    setState(() {
                      _selectedCondition = condition;
                    });
                    // Assign the selected condition to your productModel or handle it as per your logic
                    productModel.condition = _selectedCondition;
                    log(_selectedCondition);
                    log(condition);

                  },
                  ),
                ]),
            // CustomInput(
            //   hint: "Category*",
            //   inputBorder: OutlineInputBorder(),
            //   onChanged: (value) {
            // //     productModel.category = value;
            // },
            // ),
            CustomInput(
              hint: "Tags*",
              inputBorder: OutlineInputBorder(),
              onChanged: (value) {},

            ),
            // CustomInput(hint: "Quantity*", inputBorder: OutlineInputBorder(),onChanged: (value){productModel.=value;},),
            CustomInput(
              hint: "Mention use period*",
              inputBorder: OutlineInputBorder(),
              onChanged: (value) {
                productModel.usePeriod = value;
              },
            ),
            // CustomInput(hint: "Mention defects", inputBorder: OutlineInputBorder(),onChanged: (value){productModel.=value;},),
            // CustomInput(hint: "Link to original product page", inputBorder: OutlineInputBorder(),onChanged: (value){productModel.title=value;},),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: Text("Upload picture", style: commonTextsStyle()),
        // content: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     ImagePickerButton(onImagesPicked: _updateImagePaths),
        //     SizedBox(height: 20),
        //     _imagePaths.isNotEmpty ? ImageDisplayContainer(imagePaths: _imagePaths, onDeleteImage: (int index) {
        //       setState(() {_imagePaths.removeAt(index);});},) : Container(),
        //   ],
        // ),
        content: Column(
          children: [

            ImagePickerButton(onImagesPicked: _updateImagePaths),
            SizedBox(height: 20),
            _imagePaths.isNotEmpty ? ImageDisplayContainer(imagePaths: _imagePaths, onDeleteImage: (int index) {
              setState(() {_imagePaths.removeAt(index);});},) : Container(),

            // CustomInput(
            //   hint: "image link",
            //   inputBorder: OutlineInputBorder(),
            //   controller: photoController,
            //   onChanged: (j){},
            //
            // ),
            Container(
              width: 100,
              // child: ElevatedButton(onPressed: () async {
              //
              //
              //
              //     if(true){
              //     // for (String imagePat in _imagePaths) {
              //     //   productModel.photos!.add(imagePat);
              //     // }
              //
              //   } else {
              //     // Handle the case when photos is null, maybe initialize it or throw an error.
              //     productModel.photos = [photoController.text.toString()];
              //   }
              // }, child: Text('Confirm')),
            )
          ],
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: Text("Set Price", style: commonTextsStyle()),
        content: Column(
          children: [
            CustomInput(
              hint: "Set Price* (In ₹)",
              inputType: TextInputType.number,
              inputBorder: OutlineInputBorder(),
              onChanged: (value) {
                productModel.price = int.tryParse(value);
              },
            ),
          ],
        ),
      ),
    ];
  }

  TextStyle commonTextsStyle(
      {Color color = Colors.black, double fontsize = 10.0}) {
    return TextStyle(
        fontSize: fontsize,
        color: color,
        fontWeight: FontWeight.normal,
        fontFamily: "Poppins");
  }
}

Future<List<String>> uploadAndReturnImageUrls(String username, List<String> imagePaths) async {
  try {
    List<String> imageUrls = await FirebaseRepository().uploadImagesToFirebaseStorage(username, imagePaths);
    return imageUrls;
    print('Uploaded image URLs: $imageUrls');
  } catch (e) {

    print('Error uploading images and getting URLs: $e');
    //upload default images if any error happen  // add only hyperlink  for images
    List<String> imageUrls=[];
    return imageUrls;

  }
}