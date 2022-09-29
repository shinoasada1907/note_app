// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/screens/note-reader.dart';
import 'package:notes_app/screens/note_editor.dart';
import 'package:notes_app/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final users = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'FireNotes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              color: Colors.lightBlue,
              icon: const Icon(
                Icons.people,
                size: 30,
              ),
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  child: Text(
                    'Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: 0,
                ),
                const PopupMenuItem<int>(
                  child: Text(
                    'Setting',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: 1,
                ),
                PopupMenuItem<int>(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Signout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  value: 2,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your recent Notes',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    size: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Notes")
                    .where("uid", isEqualTo: users.uid)
                    .orderBy("important", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //kiểm tra kết nối với dữ liệu
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map((note) => notecard(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NoteReaderScreen(note),
                                  ),
                                );
                              }, note))
                          .toList(),
                    );
                  }
                  return Text(
                    'There is no Notes',
                    style: GoogleFonts.nunito(color: Colors.black),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditorScreen(),
            ),
          );
        },
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  onSelected(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        print('Email: ' + users.email!);
        print('Uid: ' + users.uid);
        break;
      case 1:
        break;
      case 2:
        FirebaseAuth.instance.signOut();
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
    }
  }
}
