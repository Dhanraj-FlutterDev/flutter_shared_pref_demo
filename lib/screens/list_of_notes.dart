import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shared_pref_demo/modal/notes_modal.dart';
import 'package:flutter_shared_pref_demo/notes_pref.dart';
import 'package:flutter_shared_pref_demo/screens/new_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewNoted extends StatefulWidget {
  bool isEditing;
  String intivalue;
  String indexValue;
  bool toDelete;

  AddNewNoted(
      {@required this.isEditing,
      this.intivalue,
      this.indexValue,
      this.toDelete,
      Key key})
      : super(key: key);

  @override
  _AddNewNotedState createState() => _AddNewNotedState();
}

class _AddNewNotedState extends State<AddNewNoted> {
  TextEditingController addNewNotesController = TextEditingController();
  String addedNotes;
  SharedPreferences sharedPreferences;
  NotesList notesList;
  List<String> oldValue = [];

  setNote() async {
    sharedPreferences = await SharedPreferences.getInstance();

    String newValue = sharedPreferences.getString('useradded');
    if (newValue != null) {
      oldValue.addAll(Iterable.castFrom(jsonDecode(newValue)));
    }
    if (addNewNotesController.text.isNotEmpty) {
      oldValue.add(addNewNotesController.text.toString());
    } else {
      print('empty');
    }
    widget.toDelete
        ? oldValue.remove(widget.indexValue)
        : print('object in the list is $oldValue');
    widget.isEditing
        ? oldValue.remove(widget.indexValue)
        : print('object in the list is $oldValue');
    sharedPreferences.setString('useradded', jsonEncode(oldValue));
    print(sharedPreferences.getString('useradded'));
  }

  // setNoteList() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   List oldNotesValue = sharedPreferences.getStringList('newvalue');

  //   if (addNewNotesController.text.isNotEmpty) {
  //     oldNotesValue.add(addNewNotesController.text.toString());
  //   } else {
  //     print('empty');
  //   }
  //   sharedPreferences.setStringList('newvalue', jsonEncode(oldNotesValue));
  //   print(sharedPreferences.getString('useradded'));
  // }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      addNewNotesController.text = widget.intivalue;
    } else {
      addNewNotesController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(addedNotes);
    return Scaffold(
      appBar: AppBar(
        title: widget.isEditing && widget.toDelete
            ? Text('Delete')
            : Text('Add/Edit'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            widget.toDelete
                ? Container()
                : TextFormField(
                    controller: addNewNotesController,
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
                  widget.toDelete ? 'Delete' : 'Save',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, letterSpacing: 0.5),
                ),
                color: Colors.orange,
                onPressed: () {
                  setNote();

                  Navigator.pop(context, 'refresh');
                })
          ],
        ),
      ),
    );
  }
}
