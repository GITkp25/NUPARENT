// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nu_parent/main.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset Email Sent'),
            content: const Text(
              'An email with instructions to reset your password has been sent to your email address.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 175, 203, 244),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
      ),
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          colors: [
            Color.fromARGB(255, 245, 251, 255),
            Color.fromARGB(255, 175, 203, 244),
          ],
          radius: .5, // Adjust the radius based on your preference
          center: Alignment(0.1, -.1),
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                child: const Text("Reset Password",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 28)),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                child: const Text("Enter your registered email address",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14)),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(5),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "Email Address",
                      hintStyle: TextStyle(
                          color: AppColors.primaryColor, fontSize: 12)),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    resetPassword(context, emailController.text);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ))),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
