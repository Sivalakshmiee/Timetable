// ignore_for_file: unnecessary_string_escapes, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetable_manager/screens/home_screen.dart';
import 'package:timetable_manager/screens/signup_screen.dart';
import 'package:timetable_manager/utils/color_utils.dart';

import '../reusable_widgets/reusable_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key, required String title}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{
  String emailid = '';
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [
    hexStringToColor("CB2B93"), 
    hexStringToColor("9546C4"), 
    hexStringToColor("5E61F4")
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
   child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 400),
            child: Column(
              children: <Widget>[
                const SizedBox(
                height: 25,
                ),
            reusableTextField("Enter  Username", Icons.account_circle, false, _emailTextController),
              const SizedBox(
                height: 20
              ),
            reusableTextField("Enter Password", Icons.lock_outline, true,_passwordTextController),
              const SizedBox(
                height: 25,
                ),
                //signInSignUpButton(context, false, () {}),
                //signUpOption()
     Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: (){
          FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((value) {
            Navigator.push(context, MaterialPageRoute(builder: ((context) => HomeScreen())));
          }).onError((error, stackTrace) {
            print("Error ${error.toString()}");
          });
          
          //onTap({});
        },
        child: Text(
          "LOG IN",
          style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if(states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
          
        ),
      ),
    ),
     ),
         const SizedBox(
          height: 20
         ),
         signUpOption()
      ],
      ),
    ),
    ),
    ),
    );
}

Row signUpOption() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have account?",
      style: TextStyle(color: Colors.white70)),
      GestureDetector(
        onTap: () {
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) =>  SignUpScreen()));
          
        },
        child: const Text(
          " Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
      
    ],
  );
}
}