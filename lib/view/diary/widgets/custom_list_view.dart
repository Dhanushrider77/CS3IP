import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/pallete.dart';
import '../display_journal_screen.dart';

class CustomListView extends StatefulWidget {
  const CustomListView({super.key});

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users/${currentUser?.email}/journals")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot<Object?> journal =
                    snapshot.data!.docs[index];
                return CustomTile(
                  entryData: journal,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomTile extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> entryData;
  const CustomTile(
      {super.key,
      required this.entryData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        ListTile(
          tileColor: Pallete.gradient3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(entryData['title']),
          subtitle: Text(entryData['date']),
          trailing: const Icon(Icons.arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => DisplayJournal(
                      data: entryData,
                    )),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
