import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project23/note/view.dart';

import '../component/material_button.dart';
import '../component/textField.dart';

class EditNote extends StatefulWidget {
  final String noteId;
  final String categoryId;
  final String oldValue;

  const EditNote(
      {super.key,
      required this.noteId,
      required this.categoryId, required this.oldValue});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool isLoading = false;

  editNote() async {
    CollectionReference categoriesNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection("note");
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categoriesNote.doc(widget.noteId).update({
          "note": note.text,
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NotePage(
                  categoryId: widget.categoryId,
                )));
      } catch (e) {
        isLoading = false;
        setState(() {});
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
  void initState() {
    super.initState();
    note.text = widget.oldValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
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
              text: 'Save',
              onPressed: () {
                editNote();
              },
            ),
          ],
        ),
      ),
    );
  }
}
