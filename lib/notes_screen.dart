import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notes extends StatefulWidget {
  Notes({Key key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController addedNote = TextEditingController();

  String list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            TextField(
              controller: addedNote,
              maxLines: 5,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 14, 20, 14),
                hintText: "Enter Notes",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, letterSpacing: 0.5),
                ),
                color: Colors.orange,
                onPressed: () {
                  getNotes();
                })
          ],
        ),
      ),
    );
  }

  getNotes() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    List<String> oldList = [];
    String old_data = sharedPreferences.getString('notes');

    if (old_data != null) {
      oldList.addAll(Iterable.castFrom(jsonDecode(old_data)));
    }

    if (addedNote.text.isNotEmpty) {
      oldList.add(addedNote.text.toString());
    } else {
      print('empty');
    }

    sharedPreferences.setString('notes', jsonEncode(oldList));
    Navigator.pop(context);

    print(sharedPreferences.getString('notes'));

    print(addedNote.text);
  }
}
