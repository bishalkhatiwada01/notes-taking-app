import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal/screens/home_screen.dart';
import 'package:journal/style/app_stype.dart';


class JournalUpdate extends StatefulWidget {
  JournalUpdate(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<JournalUpdate> createState() => _JournalUpdateState();
}

class _JournalUpdateState extends State<JournalUpdate> {
  int color_id = Random().nextInt(AppStyle.cardColor.length);
  String date = DateTime.now().toString();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();
  final journalsDb = FirebaseFirestore.instance.collection('journals');

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.doc["journal_title"];
    _mainController.text = widget.doc["journal_content"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardColor[color_id],
      appBar: AppBar(
        title: Text(
          "Edit Journal",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Journal Title"),
              style: AppStyle.mainTitle,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              date,
              style: AppStyle.dateTitle,
            ),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Journal Title"),
              style: AppStyle.mainTitle,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () async {

          journalsDb.doc(widget.doc.id).update(
            {
              "journal_title": _titleController.text,
              "creation_date": date,
              "journal_content": _mainController.text,
              "color_id": color_id,
            }
          );

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        },
        child: Icon(Icons.save, color: Colors.white,),
      ),
    );
  }
}
