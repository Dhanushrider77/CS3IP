import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit/view/diary/utils/pallete.dart';
import 'package:fit/view/diary/widgets/custom_list_view.dart';
import 'package:fit/view/diary/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

import 'create_journal_screen.dart';
class DiaryHome extends StatefulWidget {
  const DiaryHome({super.key});

  @override
  State<DiaryHome> createState() => _DiaryHomeState();
}

class _DiaryHomeState extends State<DiaryHome> {
  final User? currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.gradient1,
        title: const Text("Entries"),
        centerTitle: true,
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: Pallete.gradient2,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateJournal()));
              },
              child: const Icon(
                Icons.add,
                color: Pallete.backgroundColor,
                size: 50,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
            height: 150,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const CustomListView(),
      ),
    );
  }
}
