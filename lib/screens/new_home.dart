import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shared_pref_demo/login_page.dart';
import 'package:flutter_shared_pref_demo/screens/list_of_notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesHome extends StatefulWidget {
  NotesHome({Key key}) : super(key: key);

  @override
  _NotesHomeState createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  SharedPreferences sharedPreferences;
  String email;
  String getNotes;
  List<String> notess = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getUserData();
    notess == null ? Container() : getNotesData();
  }

  getNotesData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    notess.addAll(Iterable.castFrom(
        jsonDecode(sharedPreferences.getString('useradded')) ?? ''));

    //getNotes = sharedPreferences.getString('useradded');
    _notify();
    //print('notes in home $getNotes');
    //print('notes in home $notess');
  }

  getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString('mail');
    _notify();

    print('user email is: $email');
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('notes to show in list $notess');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 16, top: 10),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: () async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                })
          ],
        ),
      ),
      body: notess == null
          ? Container()
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                _refresh();
              },
              child: ListView.builder(
                  //shrinkWrap: true,
                  itemCount: notess.length,
                  itemBuilder: (context, index) {
                    return Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: notess == null
                                  ? Container()
                                  : Text(
                                      notess[index].toString(),
                                      maxLines: 4,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      print('notess index ${notess[index]}');
                                      var refresh = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddNewNoted(
                                                    isEditing: true,
                                                    indexValue: notess[index],
                                                    toDelete: false,
                                                  )));
                                      if (refresh != null) {
                                        _refresh();
                                      }
                                    },
                                    child: Icon(Icons.edit)),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  // onTap: () async {
                                  //   print('notess index ${notess[index]}');
                                  //   var refresh = await Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => AddNewNoted(
                                  //                 isEditing: true,
                                  //                 indexValue: notess[index],
                                  //                 toDelete: true,
                                  //               )));
                                  //   if (refresh != null) {
                                  //     _refresh();
                                  //   }
                                  // },
                                  child: Icon(Icons.delete),

                                  onTap: () {
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
                                                  print(notess);
                                                },
                                                child: Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  print(
                                                      'notess remove value ${notess.elementAt(index)}');
                                                  notess.remove(
                                                      notess.elementAt(index));
                                                  //getNotesData();
                                                  print(notess);
                                                  Navigator.pop(
                                                      context, 'refresh');
                                                },
                                                child: Text('Delete')),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        // onPressed: () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => addEditPage(false, false),
        //           fullscreenDialog: true));
        // },
        onPressed: () async {
          var refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewNoted(
                        isEditing: false,
                        toDelete: false,
                      )));
          if (refresh != null) {
            _refresh();
          }
        },
      ),
    );
  }

  _refresh() {
    notess.clear();
    getNotesData();
  }
}
