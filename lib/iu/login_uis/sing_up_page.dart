import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_firebase/iu/login_uis/login_page.dart';
import 'package:todo_with_firebase/models/models.dart';

class SingUpPage extends StatelessWidget{
  TextEditingController userController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneNumController=TextEditingController();
  TextEditingController passController=TextEditingController();

FirebaseAuth auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SingUp"),
      ),
      body: Center(
        child: Container(
          width: 200,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            /// user textfield
            TextField(
              controller:userController,
              decoration: InputDecoration(
                hintText: "Enter User Name......"
              ),
            ),
            /// email textfield
            TextField(
              controller:emailController ,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter Email......"
              ),
            ),
            /// phone number textfield
            TextField(
              controller:phoneNumController ,
              keyboardType:TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter PhoneNumber......"
              ),
            ),
            /// pass textfield
            StatefulBuilder(builder: (context, setState) {
              return TextField(
                controller:passController ,
                obscureText: LoginPage.isHidden,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    LoginPage.isHidden=!LoginPage.isHidden;
                    setState((){

                    });
                  }, icon:LoginPage.isHidden ? Icon(Icons.visibility_off):Icon(Icons.visibility)),
                    hintText: "Enter password......"
                ),
              );
            },),
              SizedBox(height: 50,),
              ElevatedButton(onPressed: ()async{
                if(userController.text.isNotEmpty && emailController.text.isNotEmpty &&phoneNumController.text.isNotEmpty&&passController.text.isNotEmpty ){
                  try {
                    UserCredential usercred= await auth.createUserWithEmailAndPassword(email: emailController.text, password: passController.text);
                    FirebaseFirestore.instance.collection("user").doc(
                        usercred.user!.uid).set(UserModel(
                      useName: userController.text,
                      email: emailController.text,
                      phoneNum: phoneNumController.text,
                    image: "",
                    ).toMap());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success:User with ${usercred.user!.uid} Register Successfully")));
                    Navigator.pop(context);
                  }on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The password provided is too weak !!!!!")));
                    } else if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The account already exists for that email !!!!!")));
                    }

                  }
                  catch (e){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error:$e")));
                  }
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("fill all the blancks!!!!")));
                }
              }, child: Text("Sing up")),
              SizedBox(height: 20,),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("all Ready have an Account?"))
          ],),
        ),
      ),
    );
  }
}