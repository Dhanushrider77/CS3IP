import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit/view/diary/utils/pallete.dart';

import 'package:flutter/material.dart';

import '../../services/firestore_crud_methods.dart';


class DisplayJournal extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> data;
  const DisplayJournal({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.gradient1,
        title: Text(data['title']),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Delete"),
                    content:
                        const Text("Do you really want to delete this entry?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            DiaryClass(FirebaseFirestore.instance)
                                .delete(docId: data.id);
                            Navigator.pop(context);
                          },
                          child: const Text("Continue")),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(data['date']),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 150,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Pallete.gradient3,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Pallete.gradient3),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(data['text']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
