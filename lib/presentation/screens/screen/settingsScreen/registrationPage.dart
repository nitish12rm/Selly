import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellingportal/data/model/user_model.dart';
import 'package:sellingportal/logic/cubits/user/user_cubit.dart';
import 'package:sellingportal/presentation/screens/splash/splash_screen.dart';
import 'package:sellingportal/presentation/widget/MyElevatedButton.dart';

import '../../../../res/drawable/backgroundWave.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _isSaveEnabled = false;

class registration extends StatelessWidget {
  final UserModel userModel;

  const registration({super.key, required this.userModel});

  static const String routeName = 'registration';

  @override
  Widget build(BuildContext context) {
    TextEditingController telegram_username = TextEditingController();
    TextEditingController address = TextEditingController();

    double screenHeight = MediaQuery.of(context).size.height;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Stack(
          children: [
            Container(
              height: height * 0.20,
              child: BackgroundWave(
                height: height * 20,
                colors: Color.fromRGBO(74, 67, 236, 1),
              ),
            ),
            AppBar(
              backgroundColor: Color.fromRGBO(74, 67, 236, 1),
              title: Text(
                'Profile',
                style: commonTextsStyle(fontsize: 20, color: Colors.white),
              ),
              // Add more app bar properties if needed
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text(
                        ' Registration ',
                        style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.02),
                      child: TextFormField(
                        // controller: ,

                        decoration: commonInputDecoration(
                            labelText: "Telegram username"),
                        onChanged: (value) {
                          userModel.telegram_username =
                              value.trim().toString();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.02),
                      child: TextFormField(
                        // controller: ,

                        decoration: commonInputDecoration(labelText: "Address"),
                        onChanged: (value) {
                          userModel.address =
                              value.trim().toString();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.02),
                      child: DropdownButtonFormField<String>(
                        decoration:
                            commonInputDecoration(labelText: "College Name"),
                        items: [
                          DropdownMenuItem<String>(
                            value: "JSS College",
                            child: Text("JSS College"),
                          ),
                          DropdownMenuItem<String>(
                            value: "JIIT Sector-62",
                            child: Text("JIIT Sector-62"),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          userModel.college = value.toString();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15.0, 20, 0),
                      child: Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.02),
                        width: double.infinity,
                        child: MyElevatedButton(
                          child: Text('SAVE',
                              style: commonTextsStyle(color: Colors.white)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is validated, enable save functionality here
                              // For now, just print a message
                              print(
                                  'Form is valid, enable save functionality here');
                              //updating user model


                              BlocProvider.of<UserCubit>(context)
                                  .updateUser(userModel);
                              Navigator.pushReplacementNamed(context, SplashScreen.routeName);
                            } else {
                              // Form is not valid, show an error message or handle accordingly
                              print('Form is invalid');
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

InputDecoration commonInputDecoration({
  required String labelText,
  Color borderColor = Colors.grey,
  double borderWidth = 2.0,
  Color focusedBorderColor = Colors.black,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      fontFamily: 'Poppins', // Apply Poppins font to labelText
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
          color: focusedBorderColor,
          width: borderWidth), // Specify focused border color and width
    ),
  );
}

TextStyle commonTextsStyle(
    {Color color = Colors.black, double fontsize = 18.0}) {
  return TextStyle(
      fontSize: fontsize,
      color: color,
      fontWeight: FontWeight.normal,
      fontFamily: "Poppins");
}

ButtonStyle ButtonView() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
}
