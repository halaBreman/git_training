import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project23/note/view.dart';

import '../component/material_button.dart';
import '../component/textField.dart';

class AddNote extends StatefulWidget {
  final String docId;
  const AddNote({super.key, required this.docId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool isLoading = false;



  addNote() async {
    CollectionReference categoriesNote =
    FirebaseFirestore.instance.collection('categories').doc(widget.docId).collection("note");
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {
        });
        DocumentReference response = await categoriesNote.add(
            {"note": note.text,});
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotePage(categoryId: widget.docId,)));
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
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: CustomTextFormField(
                hint: 'Enter your note',
                controller: note,
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
                addNote();
              },
            ),
          ],
        ),
      ),
    );
  }
}
