// ignore_for_file: prefer_final_fields, avoid_print, body_might_complete_normally_nullable, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/forgotpassword.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String iduser = "";
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool passvisible = true;

  Future<User?> loginUsingEmailPasswrd(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No User found for that email');
      }
    }
    return user;
  }

  Future<User?> signUp(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        user = auth.currentUser;
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(value.user?.uid)
            .set({
          'uid': user?.uid,
          'email': email,
          'password': password,
        });
      });
      return user;
      // user = userCredential.user;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                _inputField(context),
                _forgotPassword(context),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: const [
        Text(
          "Welcome To NoteApp",
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue),
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Please login your account",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person),
              ),
              obscureText: passvisible,
            ),
            Positioned(
              right: 10,
              bottom: 5,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    passvisible = !passvisible;
                  });
                },
                icon: Icon(
                  passvisible ? Icons.visibility : Icons.visibility_off,
                  size: 30,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Don't forget your password",
          style: TextStyle(
            color: Colors.lightBlue,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (_usernameController.text == '' ||
                _passwordController.text == '') {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Please complete to email and password'),
                    );
                  });
            } else {
              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_usernameController.text) ||
                  _passwordController.text.length < 6) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text(
                            'Wrong email or passwpord! Please complete again!'),
                      );
                    });
              } else {
                User? user = await loginUsingEmailPasswrd(
                    email: _usernameController.text,
                    password: _passwordController.text,
                    context: context);
                if (user != null) {
                  _usernameController.clear();
                  _passwordController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
              }
            }
          },
          child: const Text(
            "Login",
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

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ForgotPass(),
          ),
        );
      },
      child: const Text(
        "Forget password?",
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: const Text(
            "Sign Up",
          ),
        )
      ],
    );
  }
}
