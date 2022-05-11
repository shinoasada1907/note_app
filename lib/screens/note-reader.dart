import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/screens/note_editor.dart';
import 'package:notes_app/style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  String date = DateTime.now().toString();
  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc["color_id"];
    String note_title = widget.doc["note_title"];
    String note_content = widget.doc["note_content"];
    TextEditingController _titleController =
        TextEditingController(text: note_title);
    TextEditingController _mainController =
        TextEditingController(text: note_content);
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("Notes")
                  .doc(widget.doc.id)
                  .update({
                "note_title": _titleController.text,
                "creation": date,
                "note_content": _mainController.text,
                "color_id": color_id,
              }).then((value) {
                Navigator.pop(context);
              }).catchError((erro) =>
                      print("Failed to update new Note due to $erro"));
            },
            icon: Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Yes?'),
                  content:
                      Text("Do you want to Delete ${_titleController.text}"),
                  backgroundColor: AppStyle.cardsColor[color_id],
                  actions: [
                    TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Notes")
                            .doc(widget.doc.id)
                            .delete()
                            .then((value) {
                          print('Delete seccess');
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }, onError: (error) => print("Fail ${error}"));
                      },
                      child: Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
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
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
    );
  }
}
