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
    getNotesData();
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
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Welcome',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            margin: EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              '$email',
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
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
                sharedPreferences.remove('useradded');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
      body: notess == null
          ? Container()
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                _refresh();
              },
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: notess.length,
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
                            child: notess == null
                                ? Container()
                                : Text(notess[index].toString()),
                          )),
                          ButtonBar(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    print('notess index ${notess[index]}');
                                    var refresh = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNewNoted(
                                                  isEditing: true,
                                                  intivalue: notess[index],
                                                  indexValue: notess[index],
                                                  toDelete: false,
                                                )));
                                    if (refresh != null) {
                                      _refresh();
                                    }
                                  }),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  print('notess index ${notess[index]}');
                                  var refresh = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddNewNoted(
                                                isEditing: true,
                                                intivalue: notess[index],
                                                indexValue: notess[index],
                                                toDelete: true,
                                              )));
                                  if (refresh != null) {
                                    _refresh();
                                  }
                                },
                                // onPressed: () {
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         title: Text("Alert"),
                                //         content: Text(
                                //             "Would you like to delete the note?"),
                                //         actions: [
                                //           TextButton(
                                //               onPressed: () {
                                //                 Navigator.pop(context);
                                //               },
                                //               child: Text('Cancel')),
                                //           TextButton(
                                //               onPressed: () {
                                //                 print(
                                //                     'notess remove value ${notess.elementAt(index)}');
                                //                 notess.remove(
                                //                     notess.elementAt(index));
                                //                 getNotesData();
                                //                 print(notess);
                                //                 Navigator.pop(
                                //                     context, 'refresh');
                                //               },
                                //               child: Text('Delete')),
                                //         ],
                                //       );
                                //     },
                                //   );
                                // },
                              ),
                            ],
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
          }),
    );
  }

  _refresh() {
    notess.clear();
    getNotesData();
  }
}
