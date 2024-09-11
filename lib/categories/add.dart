import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../component/material_button.dart';
import '../component/textField.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  bool isLoading = false;

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {
        });
        DocumentReference response = await categories.add(
            {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
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
  void dispose() {
    // TODO: implement dispose
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
              text: 'Add',
              onPressed: () {
                addCategory();
              },
            ),
          ],
        ),
      ),
    );
  }
}
