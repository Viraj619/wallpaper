import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget{
  TextEditingController titleController=TextEditingController();
  TextEditingController descController=TextEditingController();
  String title;
  String desc;
  DetailPage({required this.title,required this.desc});
  @override
  Widget build(BuildContext context) {
    titleController.text=title;
    descController.text=desc;
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: InputBorder.none
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  border: InputBorder.none
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}