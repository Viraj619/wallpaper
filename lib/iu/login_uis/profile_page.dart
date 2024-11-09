import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> ProfileState();

}
class ProfileState extends State<ProfilePage>{
  File? profilePic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body:Center(
        child: Stack(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(width: 4,color: Colors.orange),
                shape: BoxShape.circle,
                image:profilePic!=null?DecorationImage(image:FileImage(profilePic!,),fit: BoxFit.cover):DecorationImage(image: NetworkImage("https://cdn-icons-png.flaticon.com/128/3135/3135715.png"),fit:BoxFit.cover),
              ),
            ),
            Positioned(
                top: 160,
                left: 100,
                child: IconButton(onPressed: (){
                  showModalBottomSheet(context: context, builder:(_){
                    return Container(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          /// camera button
                          Column(children: [
                           InkWell(
                               onTap:()async{
                                 Navigator.pop(context);
                                 /// image picker from camera
                                 XFile? imagePicker= await  ImagePicker().pickImage(source: ImageSource.camera);
                                 if(imagePicker!=null){
                                   CroppedFile? croppedFile= await ImageCropper().cropImage(sourcePath: imagePicker.path,
                                       uiSettings: [
                                         AndroidUiSettings(
                                           toolbarTitle: 'Cropper',
                                           toolbarColor: Colors.deepOrange,
                                           toolbarWidgetColor: Colors.white,
                                         ),
                                         IOSUiSettings(
                                           title: 'Cropper',
                                         ),
                                       ]);
                                   if(croppedFile!=null){
                                     profilePic=File(croppedFile.path);
                                     setState(() {

                                     });
                                   }
                                 }
                               },
                               child: Image.network("https://cdn-icons-png.flaticon.com/128/1042/1042390.png",width: 60,height: 60,)),
                            Text("Camera")
                          ],),

                          /// gallery click button
                          Column(children: [
                           InkWell(
                               onTap:()async{
                                 Navigator.pop(context);
                                 ///  image picker from gallery
                                 XFile? imageCameraPicker= await ImagePicker().pickImage(source: ImageSource.gallery);
                                 if(imageCameraPicker!=null){
                                   CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: imageCameraPicker.path,
                                     uiSettings: [
                                       AndroidUiSettings(
                                         toolbarTitle: 'Cropper',
                                         toolbarColor: Colors.deepOrange,
                                         toolbarWidgetColor: Colors.white,
                                       ),
                                       IOSUiSettings(
                                         title: 'Cropper',
                                       ),
                                     ],
                                   );
                                   if(croppedFile!=null){
                                     profilePic=File(croppedFile.path);
                                     setState(() {

                                     });
                                   }
                                 }

                               },
                               child: Image.network("https://cdn-icons-png.flaticon.com/128/10054/10054280.png",width: 60,height: 60,)),
                            Text("gallery")
                          ],)
                        ],),
                      ),
                    );
                  } );
                }, icon:Icon(Icons.edit,size: 30,)))
          ],
        ),
      ),
    );
  }
}