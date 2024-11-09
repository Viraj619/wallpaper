
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_firebase/firebase_options.dart';
import 'package:todo_with_firebase/iu/login_uis/splash_page.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}
class MainApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashPage(),
    );
  }
}