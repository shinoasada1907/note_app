import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/style/app_style.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);

  String date = DateTime.now().toString();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Add a new Note',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note title',
              ),
              style: AppStyle.mainTitle,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              date,
              style: AppStyle.dateTitle,
            ),
            SizedBox(
              height: 28,
            ),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
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
        onPressed: () async {
          FirebaseFirestore.instance.collection("Notes").add({
            "note_title": _titleController.text,
            "creation": date,
            "note_content": _mainController.text,
            "color_id": color_id,
          }).then((value) {
            print(value.id);
            print("${_titleController}");
            Navigator.pop(context);
          }).catchError((erro) => print("Failed to add new Note due to $erro"));
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
