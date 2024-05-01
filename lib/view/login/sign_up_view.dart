import 'package:fit/common/color_extension.dart';
import 'package:fit/common_widget/round_button.dart';
import 'package:fit/view/home/fitness_home.dart';
import 'package:fit/view/login/register.dart';
import 'package:fit/view/login/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;

  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _CpasswordController = TextEditingController();

  bool _isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 38.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30,),
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
                Text(
                  "Welcome to Fitness Fuel,",
                  style: TextStyle(
                      color: TColor.gray, fontSize: 12, fontFamily: "Poppins"),
                ),
                Text(
                  "Create an Account",
                  style: TextStyle(
                      color: TColor.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins"),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _firstNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name must not be empty!";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            focusedBorder: InputBorder.none,
                            hintText: "First Name",
                            prefixIcon: Image.asset("images/person.png"),
                            prefixIconColor: TColor.darkgray,
                            hintStyle: TextStyle(
                                color: TColor.darkgray,
                                fontSize: 18,
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
                          controller: _lastnameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Last name must not be empty!";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            focusedBorder: InputBorder.none,
                            hintText: "Last Name",
                            prefixIcon: Image.asset("images/person.png"),
                            prefixIconColor: TColor.darkgray,
                            hintStyle: TextStyle(
                                color: TColor.darkgray,
                                fontSize: 18,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email must not be empty";
                            } else if (!value.contains("@")) {
                              return "Please enter a valid email.";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            focusedBorder: InputBorder.none,
                            hintText: "Email",
                            prefixIcon: Image.asset("images/message_mail.png"),
                            prefixIconColor: TColor.secondaryColor1,
                            hintStyle: TextStyle(
                                color: TColor.darkgray,
                                fontSize: 18,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _passwordController,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'This field is required';
                            }
                            if(val.length < 6){
                              return 'Enter a password 6+ chars long';
                            }

                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            focusedBorder: InputBorder.none,
                            hintText: "Password",
                            prefixIcon: Image.asset("images/lock.png"),
                            prefixIconColor: TColor.darkgray,
                            hintStyle: TextStyle(
                                color: TColor.darkgray,
                                fontSize: 18,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          controller: _CpasswordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'This field is required';
                            }
                            if (val != _passwordController.text) {
                              return 'Password Do Not Match';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            focusedBorder: InputBorder.none,
                            hintText: "Confirm Password",
                            prefixIcon: Image.asset("images/lock.png"),
                            prefixIconColor: TColor.darkgray,
                            hintStyle: TextStyle(
                                color: TColor.darkgray,
                                fontSize: 18,
                                fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 30,
                        color: TColor.white,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      " I agree to the terms and conditions",
                      style: TextStyle(color: TColor.darkgray1, fontSize: 13),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _signUp,
                  child: _isSigningUp == true
                      ? CircularProgressIndicator(
                          color: TColor.white,
                        )
                      : RoundButton(
                          title: "Register",
                          onPressed: () {
                            _signUp();
                          }),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: TColor.darkgray,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Or",
                        style: TextStyle(
                            color: TColor.white,
                            fontSize: 13,
                            fontFamily: "Poppins"),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: TColor.white,
                      ),
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginViewPage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: TColor.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins"),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const LoginViewPage()));
                          },
                          child: Text(
                            " Login",
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
    );
  }

  _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSigningUp = true);
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      try {
        await auth
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((value) async {
          await auth.currentUser?.updateDisplayName(
              "${_firstNameController.text} ${_lastnameController.text}");

          setState(() => _isSigningUp = false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegisterView()));
        });
      } on FirebaseAuthException catch (e) {
        setState(() => _isSigningUp = false);
        if (e.code == 'The Email already Registered') {
          Fluttertoast.showToast(msg: "Account already created. Please Login!");
        } else if (e.code == 'invalid-email') {
          Fluttertoast.showToast(
              msg: "Invalid email. Please check your email.");
        } else if (e.code == 'weak-password') {
          Fluttertoast.showToast(msg: "The password is not strong enough!");
        } else {
          Fluttertoast.showToast(msg: "Error: ${e.message}");
        }
      }
    } else {
      return null;
    }
  }

}
