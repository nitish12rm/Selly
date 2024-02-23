import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sellingportal/presentation/screens/screen/WishList.dart';
import 'package:sellingportal/presentation/screens/screen/category/categoryPage.dart';

import 'package:sellingportal/presentation/screens/screen/home/chatPage.dart';
import 'package:sellingportal/presentation/screens/screen/home/myAccountsPage.dart';
import 'package:sellingportal/presentation/screens/screen/home/myAdsPage.dart';
import 'package:sellingportal/presentation/screens/screen/sellFormScreens/stepperMainPage.dart';
import 'package:sellingportal/presentation/screens/screen/sellPage.dart';
import 'package:sellingportal/presentation/widget/bottomBarIcons.dart';
import 'package:sellingportal/res/colors/colors.dart';
import 'package:sellingportal/res/drawable/bottom_clipper.dart';

import '../../../../logic/cubits/user/user_state.dart';
import '../../splash/splash_screen.dart';
import 'explorePage.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  static const String routeName = 'homeScreen';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final _controllerBottom = NotchBottomBarController(index: 0);
  int _selectedIndex = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    BottomBarIcons bottomBarIconsInactive = BottomBarIcons(colorIndex: 0);
    BottomBarIcons bottomBarIconsActive = BottomBarIcons(colorIndex: 1);

    final _pageViewController = PageController(initialPage: 0);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Colours uiColor = Colours();
    @override
    void dispose() {
      _pageViewController.dispose();
      super.dispose();
    }

    //Pages list
    final List<Widget> bottomBarPages = [
      const explorePage(),
      MyWishListScreen(),
      const chatPage(),
      const myAdsPage(),
      const myAccountsPage(),
    ];

    return Scaffold(

      backgroundColor: Color.fromRGBO(255 , 255, 255, 40),
      resizeToAvoidBottomInset: false,
      //very important.. keyboard open karne pe scrollable widget ko bahar fek dera tha.. usse bachane ke liye use kia h isse.

      extendBody: true,

      body: PageView(
        controller: _pageViewController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),

      floatingActionButton: Container(height: 80,width: 80,child: FloatingActionButton( onPressed: (){Navigator.pushNamed(
        context,
        // FormPage.routeName,
        CategorySelectionPage.routeName,

      );},child: Icon(Icons.add_box,size: 35,),shape: CircleBorder(),foregroundColor: Colors.white,backgroundColor: Color.fromRGBO(86, 105, 255, 1),)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor:  Color.fromRGBO(255, 255, 255, 1),
        color: Color.fromRGBO(255, 255, 255, 1),
        notchMargin: 15,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: NavButton(

                icon: bottomBarIconsActive.bottomBarIconsList[0],
                isSelected: _selectedIndex == 0,
                onPress: () {
                  _pageViewController.jumpToPage(0);
                  _onNavItemTapped(0);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right:20),
              child: NavButton(

                icon: Icon(FontAwesomeIcons.bookmark,color: Color.fromRGBO(58, 120, 255, 1),),
                isSelected: _selectedIndex == 1,
                onPress: () {
                  _pageViewController.jumpToPage(1);
                  _onNavItemTapped(1);
                },
              ),
            ),
            // Add more NavButtons as needed
          ],
        ),
      ),
    );
  }
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class NavButton extends StatelessWidget {
  final Icon icon;
  final bool isSelected;
  final Function() onPress;

  NavButton({
    required this.icon,
    required this.isSelected,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: Icon(
        icon.icon,
        color: isSelected ? Colors.blue : null,
      ),
    );
  }
}




