import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/screens/home_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<User?> signUp(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
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
          "Register Account",
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
        //   controller: _fullnameController,
        //   decoration: InputDecoration(
        //       hintText: "Fullname",
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
          controller: _usernameController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.email)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.security),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(_usernameController.text) &&
                _passwordController.text.length >= 6) {
              User? user = await signUp(
                  _usernameController.text, _passwordController.text);
              if (user != null) {
                _usernameController.clear();
                _passwordController.clear();
                print('Sign Up success!');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text(
                          'Email must be in the correct format and password must be at least 6 characters! Please enter again!'),
                    );
                  });
            }
          },
          child: const Text(
            "Register",
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
