import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'categories/edit.dart';
import 'note/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("AddCategory");
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text(
            "Home",
          ),
          actions: [
            IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("Login", (route) => false);
              },
              icon: const Icon(
                Icons.exit_to_app,
              ),
            )
          ],
        ),
        body: isLoading
            ? Center(child: const CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 180,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotePage(
                          categoryId: data[index].id,
                        )));
                      },
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'what you want?',
                          btnCancelText: "Delete",
                          btnCancelIcon: Icons.delete,
                          btnOkIcon: Icons.edit_note,
                          btnOkText: "Edit",
                          btnOkOnPress: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditCategory(
                                      docId: data[index].id,
                                      oldname: data[index]["name"],
                                    )));
                          },
                          btnCancelOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection("categories")
                                .doc(data[index].id)
                                .delete();
                            Navigator.of(context)
                                .pushReplacementNamed("HomePage");
                          },
                        ).show();
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/folder.png",
                                height: 130,
                              ),
                              Text(
                                "${data[index]["name"]}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}
