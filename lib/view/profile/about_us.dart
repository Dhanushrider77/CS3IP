import 'package:fit/common/color_extension.dart';
import 'package:fit/view/home/fitness_home.dart';
import 'package:fit/view/profile/profile_view.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.black,
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
                      icon: Image.asset("images/before_nav.png"),
                    ),
                    const Text(
                      "About Us",
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
                      icon: Image.asset("images/logo.png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Image.asset("images/fitnessabout.jpg"),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Stay Fit with Fitness Flex",
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: "Poppins"),
              ),
              const Padding(
                padding:
                     EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "At FitnessFlex, we believe that everyone deserves access to tools and resources that empower them to lead healthier lives. Whether you're a seasoned fitness enthusiast or just starting your wellness journey, our app is designed to support you every step of the way.",
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: "Poppins"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
