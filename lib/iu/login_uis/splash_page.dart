import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_firebase/iu/home_page.dart';
import 'package:todo_with_firebase/iu/login_uis/login_page.dart';

class SplashPage extends StatefulWidget{
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), ()async{
      SharedPreferences pref= await SharedPreferences.getInstance();
      String userUid=pref.getString(LoginPage.USER_UID)??"";
      Widget logedIn=LoginPage();
      if(userUid!=""){
        logedIn=HomePage();
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => logedIn,));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.network("https://images.pexels.com/photos/6956183/pexels-photo-6956183.jpeg?auto=compress&cs=tinysrgb&w=600",width: 400,height: 400,fit: BoxFit.cover,),),
    );
  }
}