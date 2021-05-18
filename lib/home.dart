import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shared_pref_demo/login_page.dart';
import 'package:flutter_shared_pref_demo/modal/notes_modal.dart';
import 'package:flutter_shared_pref_demo/notes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userEmail;
  String notes;
  List<String> note = [];
  SharedPreferences sharedPreferences;

  List<NotesList> list = [];

  TextEditingController initialNotes = TextEditingController();
  _notify() {
    if (mounted) setState(() {});
  }

  void _addNewNotes() {
    list.add(
      NotesList(
        notesController: TextEditingController(),
      ),
    );
    _notify();
  }

  void getDataonHome() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(userEmail);
    setState(() {
      userEmail = (sharedPreferences.getString('email') ?? '');
    });
    print(userEmail);
  }

  void userNotes() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(note);
    setState(() {
      note.addAll(Iterable.castFrom(
          jsonDecode(sharedPreferences.getString('notes') ?? '')));
    });
    print('shared notes');
    print(sharedPreferences.getString('notes'));
    print(note);
  }

  @override
  void initState() {
    super.initState();
    // sharedPreferences = await SharedPreferences.getInstance();
    userNotes();
    getDataonHome();
  }

  @override
  Widget build(BuildContext context) {
    print(list.length);
    print(notes);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Welcome',
          style: TextStyle(color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Container(
            margin: EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              'email $userEmail',
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.remove('email');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
      body: Container(
          child: note == null
              ? Container()
              : RefreshIndicator(
                  onRefresh: () {
                    userNotes();
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: note.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100,
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(note[index]),
                              )),
                              ButtonBar(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.edit), onPressed: () {}),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Alert"),
                                              content: Text(
                                                  "Would you like to delete the note?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel')),
                                                TextButton(
                                                    onPressed: () async {
                                                      sharedPreferences =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      sharedPreferences
                                                          .remove('notes');
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Delete')),
                                              ],
                                            );
                                          },
                                        );
                                      }),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                )),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Notes()));
          }),
    );
  }
}
