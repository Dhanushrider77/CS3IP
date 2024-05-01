import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit/view/diary/utils/pallete.dart';
import 'package:fit/view/diary/widgets/custom_text_field.dart';

import 'package:flutter/material.dart';

import '../../services/firestore_crud_methods.dart';


class CreateJournal extends StatelessWidget {
  final TextEditingController dataController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  CreateJournal({super.key});

  void uploadData(String title, String data, BuildContext context) async {
    await DiaryClass(FirebaseFirestore.instance)
        .addData(title: title, data: data, context: context)
        .then((result) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.gradient1,
        title: const Text("New Entry"),
        actions: [
          GestureDetector(
            onTap: () {
              uploadData(titleController.text, dataController.text, context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.file_upload),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              CustomTextField(
                  controller: titleController,
                  hintText: "Title/Quote for the day",
                  maxLines: 1),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: dataController,
                  hintText: "How was your day?",
                  maxLines: 20)
            ],
          ),
        ),
      ),
    );
  }
}
