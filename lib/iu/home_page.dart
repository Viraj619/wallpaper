import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_firebase/iu/detail_page.dart';
import 'package:todo_with_firebase/iu/login_uis/login_page.dart';
import 'package:todo_with_firebase/iu/login_uis/profile_page.dart';
import 'package:todo_with_firebase/models/models.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var currentTime = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    getUid();
  }

  String? uid;
  void getUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getString(LoginPage.USER_UID) ?? "";
    Future<QuerySnapshot<Map<String, dynamic>>> collection = firestore
        .collection("user")
        .doc(uid)
        .collection("notes")
        .orderBy("create_at", descending: true)
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/128/3135/3135715.png"),
            ),
          ),
        ),
        title: Text("Todo Apllication"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(onTap: () {}, child: Text("Setting")),
                PopupMenuItem(
                    onTap: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString(LoginPage.USER_UID, "");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    },
                    child: Text('LogOut'))
              ];
            },
          )
        ],
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: firestore
                .collection("user")
                .doc(uid)
                .collection("notes")
                .orderBy("create_at", descending: true)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              if (snapshot.hasData) {
                return snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          var eachData = TodoModel.fromMap(
                              snapshot.data!.docs[index].data());
                          return Card(
                              color: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          title: eachData.title,
                                          desc: eachData.desc,
                                        ),
                                      ));
                                },
                                title: Text(eachData.title),
                                trailing: FittedBox(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                titleController.text =
                                                    eachData.title;
                                                descController.text =
                                                    eachData.desc;
                                                return bottomSheet(
                                                  context,
                                                  eachData.create_at,
                                                  isUpdate: true,

                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            firestore.collection("user").doc(uid).collection("notes").doc(eachData.create_at).delete();
                                          },
                                          icon: Icon(Icons.delete)),
                                    ],
                                  ),
                                ),
                              ));
                        })
                    : Center(
                        child: Text("No data yet !!!"),
                      );
              }
              return Container();
            },
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  titleController.clear();
                  descController.clear();
                  return bottomSheet(context, DateTime.now().millisecondsSinceEpoch.toString());
                });
          },
          child: Icon(Icons.add)),
    );
  }

  Widget bottomSheet(
    BuildContext context, String time, {
    bool isUpdate = false,

  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            Text(isUpdate ? "Update todos" : "Add todos"),
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: "Enter Title......"),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(hintText: "Enter desc......"),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {

                      if (isUpdate) {
                        firestore
                            .collection("user")
                            .doc(uid)
                            .collection("notes")
                            .doc(time)
                            .update(TodoModel(
                                    title: titleController.text,
                                    desc: descController.text,
                                    create_at: DateTime.now().millisecondsSinceEpoch.toString())
                                .toMap());
                      } else {
                        firestore
                            .collection("user")
                            .doc(uid)
                            .collection("notes")
                            .doc(time)
                            .set(TodoModel(
                                    title: titleController.text,
                                    desc: descController.text,
                                    create_at: time)
                                .toMap());
                      }
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text(isUpdate ? "update" : "add")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("cancle")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
