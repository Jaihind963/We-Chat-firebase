import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/show_dialog.dart';
import 'package:we_chat/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  clickGoogleSignIn() {
     Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
     
      if (user != null) {
        print('User: ${user.user}');
        print('User:${user.additionalUserInfo}');

        if((await APIs.userExist())){
Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        }else{
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
          });
        }
        
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // show Dialog mess for internet connection lost
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackbar(
          context, "Something went wrong (Check Internet connection)");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 02,
        centerTitle: true,
        title: const Text("Welcome to We Chat"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/message.png",
              width: 200,
              height: 200,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: clickGoogleSignIn,
            icon: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 30, right: 30),
              child: Image.asset(
                "assets/images/google.png",
                height: 25,
                width: 25,
              ),
            ),
            label: const Text(
              "Sign In with Googlee",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 150,
          ),
        ],
      ),
    );
  }
}
