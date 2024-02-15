// import 'dart:async';
// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../logic/cubits/user/user_cubit.dart';
// import '../../../../logic/cubits/user/user_state.dart';
//
// class SignUpProvider with ChangeNotifier{
//   BuildContext context;
//   LoginProvider(this.context){
//     _ListenToCubit();
//   }
//
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   bool isLoading = false;
//   String error = '';
//   StreamSubscription? _userSubscription;
//   //this will help in validating the form
//   final formKey = GlobalKey<FormState>();
//   void  login () async{
//     //toh pehle hm validate krre hong textfields using the FORM widgets
//     //usme ek key lagaya h jisse hm uski state ko access kar payenge
//     //agar udhar se error ayega toh hm aage ka code iss block me execute nai karemge which is about login
//     if(!formKey.currentState!.validate()) return;
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//
//     BlocProvider.of<UserCubit>(context).Login(email: email, password: password);
//     //abhi bhi half baked hai ye.. signin hone ke bad kya state milra h. iska toh hme abi kuch pata chal nai ra.
//     //so hme usercubit ke state changes ko listen karna hoga. uske changes ko dekhna hogda
//
//
//   }
//   void _ListenToCubit(){
//     //ye object ke create hote he it should listen to state so call it in the constructor
//     log("listening to user state....");
//     _userSubscription = BlocProvider.of<UserCubit>(context).stream.listen((userState) {
//       if(userState is UserLoadingState){
//         isLoading = true;
//         error = "";
//         notifyListeners();
//       }
//       else if(userState is UserErrorState){
//         isLoading = false;
//         error = userState.message;
//         notifyListeners();
//       }
//       else{
//         isLoading = false;
//         error = "";
//         notifyListeners();
//       }
//     });
//     //jabhi streamsubscrion krte h i.e, listen karte use hme close bhi karna hota h
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _userSubscription?.cancel();
//     super.dispose();
//   }
// }