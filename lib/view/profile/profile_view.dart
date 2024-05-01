import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit/common/color_extension.dart';
import 'package:fit/common_widget/round_button.dart';
import 'package:fit/view/home/home_view.dart';
import 'package:fit/view/home/fitness_home.dart';
import 'package:fit/view/login/sign_up_view.dart';
import 'package:fit/view/profile/about_us.dart';
import 'package:fit/view/profile/personal_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../login/sign_in.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var auth = FirebaseAuth.instance;
  var gender = "Male";
  var image = "images/profile_active.png";
  var height = "172";
  var weight = "60";
  var age = "14";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser?.displayName;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot snapshot =
        await firestore.collection('users').doc(user).get();

    if (snapshot.exists) {
      // Data exists, you can access it using snapshot.data()
      if (!mounted) return;
      gender = snapshot['gender'];
      setState(() {
        weight = snapshot['weight'];
        height = snapshot['height'];
        age = snapshot['age'];
      });

      if (gender == 'male' || gender == "Male") {
        if (!mounted) return;
        setState(() {
          image = "images/male_profile.png";
        });
      } else if (gender == "female" || gender == "Female") {
        if (!mounted) return;
        setState(() {
          image = "images/profile_active.png";
        });
      }
    } else {
      // Document doesn't exist
    }
  }

  @override
  Widget build(BuildContext context) {
    var name = auth.currentUser?.displayName;
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
            child: Column(
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
                      const Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset("images/about_us.png"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Transform.scale(
                        scale: 1.3,
                        child: Image.asset(
                          image,
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "Lose fat program",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontFamily: "Poppins",
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 80,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              weight,
                              style: TextStyle(
                                  color: TColor.primaryColor1,
                                  fontFamily: "Poppins",
                                  fontSize: 17),
                            ),
                            Text(
                              "Weight",
                              style: TextStyle(
                                  color: TColor.darkgray,
                                  fontFamily: "Poppins",
                                  fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              height,
                              style: TextStyle(
                                  color: TColor.primaryColor1,
                                  fontFamily: "Poppins",
                                  fontSize: 17),
                            ),
                            Text(
                              "Height",
                              style: TextStyle(
                                  color: TColor.darkgray,
                                  fontFamily: "Poppins",
                                  fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              age,
                              style: TextStyle(
                                  color: TColor.primaryColor1,
                                  fontFamily: "Poppins",
                                  fontSize: 17),
                            ),
                            Text(
                              "Age",
                              style: TextStyle(
                                  color: TColor.darkgray,
                                  fontFamily: "Poppins",
                                  fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: media.width * 0.7,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Account",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Transform.scale(
                                  scale: 1.3,
                                  child: Image.asset(
                                    "images/person.png",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PersonalData()));
                                  },
                                  child: const Text("Personal Data",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Poppins",
                                          fontSize: 16)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PersonalData()));
                                    },
                                    icon: const Icon(Icons.navigate_next)),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Transform.scale(
                                  scale: 1.3,
                                  child: Image.asset(
                                    "images/about_us.png",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const AboutUs()));
                                  },
                                  child: const Text("About Us",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Poppins",
                                          fontSize: 16)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AboutUs()));
                                    },
                                    icon: const Icon(Icons.navigate_next)),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Transform.scale(
                                  scale: 1.3,
                                  child: Image.asset(
                                    "images/out.png",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: TextButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 const LoginViewPage()));
                                    showToast(message: "Successfully signed out");
                                  },
                                  child: const Text("Logout",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Poppins",
                                          fontSize: 16)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: IconButton(
                                    onPressed: () {
                                      Fluttertoast.showToast(msg: "Logged out");
                                      _logout();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginViewPage()));
                                    },
                                    icon: const Icon(Icons.navigate_next)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showToast({required String message}){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  _logout() async {
    var auth = FirebaseAuth.instance;
    await auth.signOut();
  }
}
