import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../component/material_button.dart';
import '../component/textField.dart';

class EditCategory extends StatefulWidget {
  final String oldname;
  final String docId;
  const EditCategory({super.key, required this.docId, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  bool isLoading = false;

  CollectionReference categories =
  FirebaseFirestore.instance.collection('categories');

  editCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {
        });
        await categories.doc(widget.docId).update({"name": name.text});
        Navigator.of(context).pushNamedAndRemoveUntil("HomePage",(route) => false,);
      } catch (e) {
        isLoading = false;
        setState(() {
        });
        print("Eroooorrrrrrr $e");
      }
    }
  }
  @override
  void initState() {
    super.initState();
    name.text = widget.oldname;
  }
  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: CustomTextFormField(
                hint: 'Enter Name',
                controller: name,
                validator: (val) {
                  if (val == "") {
                    return "Can't to be empty";
                  }
                },
              ),
            ),
            CustomMaterialButton(
              isLoading: isLoading,
              text: 'Save',
              onPressed: () {
                editCategory();
              },
            ),
          ],
        ),
      ),
    );
  }
}
