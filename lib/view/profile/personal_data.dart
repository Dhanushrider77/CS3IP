import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit/view/home/fitness_home.dart';
import 'package:fit/view/profile/profile_view.dart';
import 'package:flutter/material.dart';

class PersonalData extends StatefulWidget {
  const PersonalData({super.key});

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  var email = "example@gmail.com";
  var name = "your name";
  var email_verified = false;
  var age = 10;
  var bmi = 20;
  var gender = "Male";
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser?.uid;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection("users").doc(user);

    if (!mounted) return;
    setState(() {
      email = auth.currentUser!.email!;
      name = auth.currentUser!.displayName.toString();
      email_verified = auth.currentUser!.emailVerified;
      docRef.get().then(
              (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
              gender=data['gender'].toString();
            age=data['age'];
            bmi=data['bmi'];
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
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
                                builder: (context) => const ProfileView()));
                      },
                      icon: Image.asset("images/info.png"),
                    ),
                    const Text(
                      "Personal Info",
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
                                builder: (context) => const FitnessHome()));
                      },
                      icon: Image.asset("images/about_us.png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: media.width * 0.5,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Account Details",
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Name -",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Email -",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                email,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Gender - ",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                gender.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Age -",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                age.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
