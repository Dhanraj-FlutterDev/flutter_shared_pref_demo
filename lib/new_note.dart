import 'package:flutter/material.dart';
import 'package:flutter_shared_pref_demo/modal/notes_modal.dart';

class NewNote extends StatefulWidget {
  NotesList note;

  NewNote({this.note});

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  TextEditingController addNewNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addNewNotesController = TextEditingController(
        text: widget.note == null ? null : widget.note.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          widget.note != null ? 'Edit' : 'Add',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        key: Key('new-item-title'),
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
            TextFormField(
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
                  'Save',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, letterSpacing: 0.5),
                ),
                color: Colors.orange,
                onPressed: () {
                  submit();
                })
          ],
        ),
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop(addNewNotesController.text.toString());
  }
}
