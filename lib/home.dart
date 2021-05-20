import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shared_pref_demo/login_page.dart';
import 'package:flutter_shared_pref_demo/modal/notes_modal.dart';
import 'package:flutter_shared_pref_demo/new_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<NotesList> list = List<NotesList>();
  SharedPreferences sharedPreferences;
  String email = 'fake data';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
    getUserData();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString('mail');
    setState(() {});
    print('user email is: $email');
  }

  @override
  Widget build(BuildContext context) {
    print('list at start $list');
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: AppBar(
            elevation: 0.0,
            key: Key('main-app-title'),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => goToNewItemView(),
        ),
        body: list.isEmpty ? emptyList() : buildListView());
  }

  Widget emptyList() {
    return Center(child: Text('No items'));
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return buildListTile(list[index], index);
      },
    );
  }

  // Widget buildItem(NotesList item, index) {
  //   return Dismissible(
  //     key: Key('${item.hashCode}'),
  //     background: Container(color: Colors.red[700]),
  //     onDismissed: (direction) => removeItem(item),
  //     direction: DismissDirection.startToEnd,
  //     child: buildListTile(item, index),
  //   );
  // }

  Widget buildListTile(NotesList item, int index) {
    // print(item.completed);
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
              child: list == null
                  ? Container()
                  : Text(
                      item.note,
                      maxLines: 4,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      goToEditItemView(item);
                      print('list at edit ${list[index]}');
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
                          content: Text("Would you like to delete the note?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  print('list at delete ${list[index]}');
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  removeItem(item);
                                  print('list at delete ${list[index]}');
                                  Navigator.pop(
                                    context,
                                  );
                                  loadData();
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
  }

  void goToNewItemView() {
    // Here we are pushing the new view into the Navigator stack. By using a
    // MaterialPageRoute we get standard behaviour of a Material app, which will
    // show a back button automatically for each platform on the left top corner
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewNote();
    })).then((title) {
      if (title != null) {
        addItem(NotesList(note: title));
      }
    });
  }

  void addItem(NotesList item) {
    // Insert an item into the top of our list, on index zero
    //list.insert(0, item);
    list.add(item);
    saveData();
  }

  // void changeItemCompleteness(NotesList item) {
  //   setState(() {
  //     item.completed = !item.completed;
  //   });
  //   saveData();
  // }

  void goToEditItemView(item) {
    // We re-use the NewTodoView and push it to the Navigator stack just like
    // before, but now we send the title of the item on the class constructor
    // and expect a new title to be returned so that we can edit the item
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewNote(note: item);
    })).then((title) {
      if (title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(NotesList item, String title) {
    item.note = title;
    saveData();
  }

  void removeItem(NotesList item) {
    list.remove(item);
    saveData();
  }

  void loadData() {
    List<String> listString = sharedPreferences.getStringList('list');
    if (listString != null) {
      list = listString
              .map((item) => NotesList.fromMap(json.decode(item)))
              ?.toList() ??
          [];
      setState(() {});
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap()))?.toList() ?? [];
    sharedPreferences.setStringList('list', stringList);
  }
}
