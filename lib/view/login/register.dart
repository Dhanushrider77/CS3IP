import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit/common/color_extension.dart';
import 'package:fit/common_widget/round_button.dart';
import 'package:fit/view/home/fitness_home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  List<String> gender = ['Male', 'Female'];
  String selectedValue = "Male";
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              ClipRect(

                child: Padding(
                  padding: const EdgeInsets.all(5), // Border radius
                  child: ClipOval(child: Image.asset('images/details.png',height: 100,)),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: TColor.white, fontSize: 27, fontFamily: "Poppins"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "It will help us to know more about you!",
                  style: TextStyle(
                      color: TColor.darkgray,
                      fontSize: 15,
                      fontFamily: "Poppins"),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _formKey,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButtonFormField<String>(

                          hint: const Text('Select a Category '),
                          value: selectedValue,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                          items: gender.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              focusedBorder: InputBorder.none,
                              hintText: "Gender",
                              prefixIcon: const Icon(Icons.man),
                              prefixIconColor: TColor.darkgray,
                              hintStyle: TextStyle(
                                  color: TColor.darkgray,
                                  fontSize: 16,
                                  fontFamily: "Poppins"),
                            ),

                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _dateOfBirthController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Age must not be empty!";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            focusedBorder: InputBorder.none,
                            hintText: "Age in years",
                            prefixIcon: const Icon(Icons.calendar_month_outlined),
                            prefixIconColor: TColor.darkgray,
                            hintStyle: TextStyle(
                                color: TColor.darkgray,
                                fontSize: 16,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _weightController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Weight must not be empty!";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            focusedBorder: InputBorder.none,
                            hintText: "Your Weight in Kg",
                            prefixIcon: Image.asset("images/weight.png"),
                            prefixIconColor: TColor.darkgray,
                            hintStyle: TextStyle(
                                color: TColor.darkgray,
                                fontSize: 16,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _heightController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Height must not be empty!";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            focusedBorder: InputBorder.none,
                            hintText: "Your Height in CM",
                            prefixIcon: const Icon(Icons.height_outlined),
                            prefixIconColor: TColor.darkgray,
                            hintStyle: TextStyle(
                                color: TColor.darkgray,
                                fontSize: 16,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: _welcome,
                        child: _isCompleted == true
                            ? CircularProgressIndicator(
                                color: TColor.white,
                              )
                            : RoundButton(
                                title: "Complete Registration",
                                onPressed: () {
                                  _welcome();
                                }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _welcome() async {
    var db = FirebaseFirestore.instance;
    User? auth = FirebaseAuth.instance.currentUser;
    var eml = auth?.email;
    var name = auth?.displayName;
    var height = int.parse(_heightController.text) / 100;
    var heightSq = pow(height, 2);
    var we = int.parse(_weightController.text);
    var bmi = (we / heightSq).toStringAsFixed(2);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCompleted = true;
      });
      final users = <String, dynamic>{
        "email": eml,
        "name": name,
        "age": _dateOfBirthController.text,
        "height": _heightController.text,
        "weight": _weightController.text,
        "gender": selectedValue,
        "bmi": bmi,
        "calories":0
      };

      try {
        db.collection("users").doc(auth!.uid).set(users)
          .onError((e, _) => print("Error writing document: $e"));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FitnessHome()));
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: "Error: ${e.message}");
      }
    }
  }
}
