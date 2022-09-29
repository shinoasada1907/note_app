// ignore_for_file: unused_local_variable, prefer_final_fields, unused_field, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future forgotPassword() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      await auth
          .sendPasswordResetEmail(email: _emailController.text.trim())
          .then((value) => Navigator.pop(context));
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Password reset link sent! Check your email!'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            'Forgot Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: const [
        Text(
          "Enter your account",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // TextField(
        //   controller: _usernameController,
        //   decoration: InputDecoration(
        //       hintText: "Username",
        //       border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(18),
        //           borderSide: BorderSide.none),
        //       fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
        //       filled: true,
        //       prefixIcon: const Icon(Icons.person)),
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email Address",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        // const SizedBox(height: 18),
        // TextField(
        //   controller: _passwordController,
        //   decoration: InputDecoration(
        //     hintText: "New password",
        //     border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(18),
        //         borderSide: BorderSide.none),
        //     fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
        //     filled: true,
        //     prefixIcon: const Icon(Icons.security),
        //   ),
        //   obscureText: true,
        // ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            //_emailController.clear;
            //_passwordController.clear;
            if (_emailController.text != '') {
              if (RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                  .hasMatch(_emailController.text)) {
                forgotPassword();
                _emailController.clear;
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text('Email must be in the correct format!'),
                      );
                    });
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Please enter your email!'),
                    );
                  });
            }
          },
          child: const Text(
            "Complete",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        )
      ],
    );
  }
}
