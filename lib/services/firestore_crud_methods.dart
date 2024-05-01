import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../view/diary/utils/showSnackBar.dart';

class DiaryClass {
  final FirebaseFirestore _instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  DateTime today = DateTime.now();
  DiaryClass(this._instance);

  Future<void> addData({
    required String title,
    required String data,
    required BuildContext context,
  }) async {
    try {
      _instance
          .collection("Users")
          .doc(currentUser!.email)
          .collection("journals")
          .add({
        'title': title,
        'text': data,
        'date': "${today.day}-${today.month}-${today.year}",
        'time': "${today.hour}:${today.minute}",
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

 getData() async {
    return await _instance
        .collection("Users/${currentUser?.email}/journals")
        .get();
  }

Future<void> delete({required String docId}) async {
    return await _instance
        .collection("Users/${currentUser?.email}/journals")
        .doc(docId)
        .delete();
  }
}
