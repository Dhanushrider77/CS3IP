import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit/common/color_extension.dart';
import 'package:fit/view/home/fitness_home.dart';
import 'package:fit/view/login/forgot_pass.dart';
import 'package:fit/view/login/register.dart';
import 'package:fit/view/login/sign_up_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../common_widget/round_button.dart';

class LoginViewPage extends StatefulWidget {
  const LoginViewPage({Key? key}) : super(key: key);

  @override
  State<LoginViewPage> createState() => _LoginViewPageState();
}

class _LoginViewPageState extends State<LoginViewPage> {

  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return ' Afternoon';
    }
    return ' Evening';
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.black,
      body: SingleChildScrollView(
        child: SafeArea(
           child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 15),
            child: Center(
              child: Column(
                children:[
                  const SizedBox(height: 70,),
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.blueGrey,
                    child: Padding(
                      padding: const EdgeInsets.all(5), // Border radius
                      child: ClipOval(child: Image.asset('images/logo.png')),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Good,${greeting()}",
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 15,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500
                  ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Welcome Back",
                  style: TextStyle(
                     color: TColor.white,
                    fontSize: 30,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700
                  ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: TColor.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Email must not be empty!";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              focusedBorder: InputBorder.none,
                              hintText: "Email",
                              prefixIcon: Image.asset("images/message_mail.png"),
                              prefixIconColor: TColor.darkgray,
                              hintStyle: TextStyle(
                                  color: TColor.darkgray,
                                  fontSize: 18,
                                  fontFamily: "Poppins"
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Container(
                          decoration: BoxDecoration(
                              color: TColor.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Password name must not be empty!";
                              }  else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              focusedBorder: InputBorder.none,
                              hintText: "Password",
                              prefixIcon: Image.asset("images/lock.png"),
                              prefixIconColor: TColor.darkgray,
                              hintStyle: TextStyle(
                                  color: TColor.darkgray,
                                  fontSize: 18,
                                  fontFamily: "Poppins"
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),


                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _loggedIN,
                    child: _isSigningIn == true ? CircularProgressIndicator(color: TColor.white,) :
                    RoundButton(title: "Login", onPressed: (){
                        if(_formKey.currentState!.validate()){
                      _loggedIN();
                      }
                    }),
                  ),
                  TextButton(
                    onPressed: (){
                      _forgot();
                    },
                    child: Text("Forgot your password?",
                      style: TextStyle(
                          color: TColor.white,
                          fontSize: 14,
                          fontFamily: "Poppins"
                      ),),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SignUpView()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create an account?",
                            style: TextStyle(
                                color: TColor.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins"),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const SignUpView()));
                            },
                            child: Text(
                              " Register",
                              style: TextStyle(
                                  color: TColor.primaryColor2,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Poppins"),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )),

                ],
              ),
            ),
          ),
        ),
      )
    );



  }

  _loggedIN() async {
    var auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((value){
        setState(() {
          _isSigningIn = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessHome()));
      });
    } on FirebaseAuthException catch(e){
      setState(() => _isSigningIn = false);
      if(e.code == 'user-not-fount'){
        Fluttertoast.showToast(msg: "User not found!");
      } else if (e.code == 'wrong-password'){
        Fluttertoast.showToast(msg: "Wrong password");
      } else {
        Fluttertoast.showToast(msg: "Error: ${e.message}");
      }

    }
  }

  _forgot(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassView()));
  }

}

