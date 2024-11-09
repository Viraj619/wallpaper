import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_firebase/iu/home_page.dart';
import 'package:todo_with_firebase/iu/login_uis/sing_up_page.dart';

class LoginPage extends StatelessWidget{
  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();
  FirebaseAuth auth=FirebaseAuth.instance;
   static bool isHidden=true;
  /// user uid
  static String USER_UID="uid";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Login"),
      ),
      body: Center(child: SizedBox(
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextField(controller:emailController ,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Enter email...."
          ),),
          StatefulBuilder(builder: (context, setState) {
            return  TextField(controller:passController,
              obscureText: isHidden,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                  suffixIcon:IconButton(onPressed: (){
                    isHidden=!isHidden;
                    setState((){

                    });
                  }, icon: isHidden? Icon(Icons.visibility_off):Icon(Icons.visibility)),
                  hintText: "Enter pass...."
              ),);
          },),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: ()async{
            if(emailController.text.isNotEmpty&&passController.text.isNotEmpty){
              try {
                UserCredential userCred = await auth.signInWithEmailAndPassword(
                    email: emailController.text, password: passController.text);

                /// set value in share pref
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString(USER_UID, userCred.user!.uid);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage(),));
              }on FirebaseAuthException catch (e){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invailid")));
              }
              catch (e){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("${e.toString()}")));
              }
            }else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Fill the blancks!!!")));
            }
          }, child: Text("Log in")),
          SizedBox(height: 20,),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SingUpPage(),));
          }, child: Text("Create an Account!!"))
        ],),
      ),),
    );
  }
}