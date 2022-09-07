import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/style/app_style.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final users = FirebaseAuth.instance.currentUser!;
  bool _iconColor = false;

  int color_id = Random().nextInt(AppStyle.cardsColor.length);

  String date =
      DateFormat('E,dMMM yyyy HH:mm').format(DateTime.now()).toString();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainController = TextEditingController();

  void addData() async {
    await FirebaseFirestore.instance.collection("Notes").add({
      "note_title": _titleController.text,
      "creation": date,
      "note_content": _mainController.text,
      "color_id": color_id,
      "important": _iconColor,
      "uid": users.uid,
    }).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Add a new Note',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _iconColor = !_iconColor;
                });
              },
              icon: Icon(
                Icons.star,
                color: _iconColor ? Colors.yellow : Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note title',
              ),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              date,
              style: AppStyle.dateTitle,
            ),
            const SizedBox(
              height: 28,
            ),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note content',
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () {
          // FirebaseFirestore.instance.collection("Notes").add({
          //   "note_title": _titleController.text,
          //   "creation": date,
          //   "note_content": _mainController.text,
          //   "color_id": color_id,
          // }).whenComplete(() => Navigator.pop(context));
          addData();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
