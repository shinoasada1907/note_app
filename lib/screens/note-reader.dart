// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  bool _iconColor = false;
  String date = "";
  int color_id = 0;
  String note_title = "";
  String note_content = "";
  TextEditingController _titleController =
      TextEditingController(); //su dung kieu private
  TextEditingController _mainController = TextEditingController();

  void update() async {
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(widget.doc.id)
        .update({
      "note_title": _titleController.text,
      "creation":
          DateFormat('E,dMMM yyyy HH:mm').format(DateTime.now()).toString(),
      "note_content": _mainController.text,
      "color_id": color_id,
      "important": _iconColor,
    }).then((value) {
      Navigator.pop(context);
    });
  }

  void delete() async {
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(widget.doc.id)
        .delete()
        .then((value) {
      print('Delete seccess');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
    color_id = widget.doc["color_id"];
    note_title = widget.doc["note_title"];
    note_content = widget.doc["note_content"];
    date = widget.doc["creation"];
    _iconColor = widget.doc["important"];
    _titleController = TextEditingController(text: note_title);
    _mainController = TextEditingController(text: note_content);
  }

  @override
  Widget build(BuildContext context) {
    // int color_id = widget.doc["color_id"];
    // String note_title = widget.doc["note_title"];
    // String note_content = widget.doc["note_content"];
    // TextEditingController _titleController =
    //     TextEditingController(text: note_title);
    // TextEditingController _mainController =
    //     TextEditingController(text: note_content);
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // FirebaseFirestore.instance
              //     .collection("Notes")
              //     .doc(widget.doc.id)
              //     .update({
              //   "note_title": _titleController.text,
              //   "creation": date,
              //   "note_content": _mainController.text,
              //   "color_id": color_id,
              // }).then((value) {
              //   Navigator.pop(context);
              // }).catchError((erro) =>
              //         print("Failed to update new Note due to $erro"));
              update();
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Yes?'),
                  content:
                      Text("Do you want to Delete ${_titleController.text}"),
                  backgroundColor: AppStyle.cardsColor[color_id],
                  actions: [
                    TextButton(
                      onPressed: () {
                        // FirebaseFirestore.instance
                        //     .collection("Notes")
                        //     .doc(widget.doc.id)
                        //     .delete()
                        //     .then((value) {
                        //   print('Delete seccess');
                        //   Navigator.of(context)
                        //       .popUntil((route) => route.isFirst);
                        // }, onError: (error) => print("Fail ${error}"));
                        delete();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
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
              decoration: const InputDecoration(
                border: InputBorder.none,
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
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
    );
  }
}
