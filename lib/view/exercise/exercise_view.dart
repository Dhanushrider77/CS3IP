import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit/common/color_extension.dart';
import 'package:fit/view/home/fitness_home.dart';
import 'package:fit/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
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
                                      builder: (context) =>
                                          const FitnessHome()));
                            },
                            icon: Image.asset("images/before_nav.png"),
                          ),
                          const Text(
                            "Activity Tracker",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
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
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: media.width * 0.4,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: TColor.primaryColor1.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Today's Target",
                                    style: TextStyle(
                                        color: TColor.white,
                                        fontFamily: "Poppins",
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        dailytarget();
                                      },
                                      icon: Image.asset("images/plus.png")),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 160,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Image.asset(
                                                "images/water.png",
                                                height: 60,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "8 ounces",
                                                  style: TextStyle(
                                                      color:
                                                          TColor.primaryColor1,
                                                      fontSize: 15,
                                                      fontFamily: "Poppins"),
                                                ),
                                                Text("Water intake",
                                                    style: TextStyle(
                                                        color: TColor.darkgray,
                                                        fontSize: 12,
                                                        fontFamily: "Poppins"))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 160,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Image.asset(
                                                "images/boot.png",
                                                height: 50,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "4000",
                                                  style: TextStyle(
                                                      color:
                                                          TColor.primaryColor1,
                                                      fontSize: 15,
                                                      fontFamily: "Poppins"),
                                                ),
                                                Text("Foot Steps",
                                                    style: TextStyle(
                                                        color: TColor.darkgray,
                                                        fontSize: 12,
                                                        fontFamily: "Poppins"))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Text("Recommended Meals",
                          style: TextStyle(
                              color: TColor.white,
                              fontSize: 20,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            height: media.width * 0.25,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/kales.jpg",
                                    height: 100,
                                    width: 70,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Avocado and Dark Leafy Greens",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins",
                                              fontSize: 18),
                                        ),
                                        Text(
                                          "A spinach or kale salad is low in calories and high in nutrients, ",
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 10),
                                        ),

                                        Text(
                                          "Bonus:Avocado also helps your body absorb more of the ",
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 10),
                                        ),
                                        Text(
                                          "veggies’ disease-fighting antioxidants.",
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          child: Container(
                            height: media.width * 0.25,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/m_2.jpg",
                                    height: 100,
                                    width: 70,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Eggs, Black Beans, and Peppers",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins",
                                              fontSize: 18),
                                        ),
                                        Text(
                                          "Start your day with this protein-packed scramble.",
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "Black beans and peppers make this morning meal even ",
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "more filling,thanks to a double dose of fiber.",
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),


                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          child: Container(
                            height: media.width * 0.33,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/lemon.jpg",
                                    height: 100,
                                    width: 70,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Green Tea and Lemon",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Poppins",
                                              fontSize: 18),
                                        ),

                                        Text(
                                          "The low-calorie drink is packed with antioxidants ." ,
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "called catechins, which may help you burn more calories " ,
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "and fat.One study suggested that drinking 4 cups of green " ,
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "tea every day may lead to decreases in weight " ,
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),
                                       Text(
                                          "and blood pressure .To make it even healthier,  " ,
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "add a squeeze of lemon-- it helps your body absorb them." ,
                                          style: TextStyle(
                                              color: TColor.darkgray,
                                              fontFamily: "Poppins",
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ]))),

    );
  }
  dailytarget() async {
    var db = FirebaseFirestore.instance;
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser?.uid;
    final DocumentSnapshot snapshot =
    await db.collection('users').doc(user).get();

    var calorie = snapshot['calories'];

    db.collection('users').doc(user).update({"calories": calorie + 200});
  }
}
