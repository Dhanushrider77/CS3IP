import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common_widget/round_button.dart';
import '../view/home/fitness_home.dart';
import '../view/profile/profile_view.dart';
class GoalView extends StatefulWidget {
  final String name;
  final String date;
  final String description;
  final String image;
  final String time;
  final String calories;
  final String level;
  const GoalView({
    super.key,
    required this.name,
    required this.date,
    required this.description,
    required this.image,
    required this.calories,
    required this.level,
    required this.time,
  });

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FitnessHome()));
                      },
                      icon: Image.asset("images/before_nav.png"),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileView()));
                      },
                      icon: Image.asset("images/about_us.png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 3, color: Colors.white),
                  image:  DecorationImage(
                      image: NetworkImage( widget.image),
                      fit: BoxFit.fill),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: "Poppins", fontSize: 20),
                ),
              ),
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                 "${widget.level} | ${widget.calories} calories",
                  style: const TextStyle(
                      color: Colors.blueAccent,
                      fontFamily: "Poppins",
                      fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Description",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Poppins", fontSize: 20),
                ),
              ),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                      color: Colors.brown,
                      fontFamily: "Poppins",
                      fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "You will need ${widget.time} to complete it. After that press complete it button.",
                  style: const TextStyle(
                      color: Colors.brown,
                      fontFamily: "Poppins",
                      fontSize: 15),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: RoundButton(
                    title: "Complete it",
                    onPressed: () {
                      _plank();
                      Fluttertoast.showToast(msg: "Task Completed Successfully");
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  _plank() async {
    var db = FirebaseFirestore.instance;
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser?.uid;
    final DocumentSnapshot snapshot =
    await db.collection('users').doc(user).get();

    var calorie = snapshot['calories'];
    var addcalorie=int.tryParse(widget.calories);

    db.collection('users').doc(user).update({"calories": calorie + addcalorie});
  }
}
