import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'add.dart';
import 'edit.dart';

class NotePage extends StatefulWidget {
  final String categoryId;

  const NotePage({super.key, required this.categoryId});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("note")
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(
                    docId: widget.categoryId,
                  )));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          "Note",
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
      body: WillPopScope(
          child: isLoading
              ? Center(child: const CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 180,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNote(
                                    noteId: data[index].id,
                                    categoryId: widget.categoryId,
                                    oldValue: data[index]['note'],
                                  )));
                        },
                        onLongPress: () {
                          // AwesomeDialog(
                          //   context: context,
                          //   dialogType: DialogType.warning,
                          //   animType: AnimType.rightSlide,
                          //   title: 'Error',
                          //   desc: 'what you want?',
                          //   btnCancelText: "Delete",
                          //   btnCancelIcon: Icons.delete,
                          //   btnOkIcon: Icons.edit_note,
                          //   btnOkText: "Edit",
                          //   btnOkOnPress: () async {
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) => EditCategory(
                          //           docId: data[index].id,
                          //           oldname: data[index]["name"],
                          //         )));
                          //   },
                          //   btnCancelOnPress: () async {
                          //     await FirebaseFirestore.instance
                          //         .collection("categories")
                          //         .doc(data[index].id)
                          //         .delete();
                          //     Navigator.of(context)
                          //         .pushReplacementNamed("Note");
                          //   },
                          // ).show();
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Image.asset(
                                //   "assets/images/folder.png",
                                //   height: 130,
                                // ),
                                Text(
                                  "${data[index]["note"]}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.rightSlide,
                                          title: 'Error',
                                          desc: 'Are you sure ',
                                          btnCancelText: "Cancel",
                                          btnOkText: "yes",
                                          btnCancelOnPress:() {} ,
                                          btnOkOnPress: () async {
                                            await FirebaseFirestore.instance
                                                .collection("categories")
                                                .doc(widget.categoryId)
                                                .collection("note")
                                                .doc(data[index].id)
                                                .delete();
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NotePage(
                                                            categoryId: widget.categoryId)));
                                          }).show();
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => EditNote(
                                                      noteId: data[index].id,
                                                      categoryId:
                                                          widget.categoryId,
                                                      oldValue: data[index]
                                                          ['note'],
                                                    )));
                                      },
                                      icon: const Icon(
                                        Icons.edit_note,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          onWillPop: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("HomePage", (route) => false);
            return Future.value(false);
          }),
    );
  }
}
