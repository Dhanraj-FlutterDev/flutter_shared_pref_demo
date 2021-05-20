import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewNoted extends StatefulWidget {
  bool isEditing;
  String indexValue;
  bool toDelete;

  AddNewNoted(
      {@required this.isEditing, this.indexValue, this.toDelete, Key key})
      : super(key: key);

  @override
  _AddNewNotedState createState() => _AddNewNotedState();
}

class _AddNewNotedState extends State<AddNewNoted> {
  TextEditingController addNewNotesController = TextEditingController();
  String addedNotes;
  SharedPreferences sharedPreferences;
  //NotesList notesList;
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

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      addNewNotesController.text = widget.indexValue;
    } else {
      addNewNotesController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(addedNotes);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: widget.toDelete
            ? Text(
                'Delete',
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            : widget.isEditing
                ? Text(
                    'Edit',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )
                : Text(
                    'Add',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
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
