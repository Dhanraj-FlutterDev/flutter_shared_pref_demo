import 'dart:convert';

import 'package:flutter_shared_pref_demo/modal/notes_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesPreferences {
  static SharedPreferences _sharedPreferences;

  static const _keyNotess = 'notess';

  static Future init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  static Future setNotess(NotesList notesList) async {
    final json = jsonEncode(notesList.toJson());

    await _sharedPreferences.setString(_keyNotess, json);
  }

  static NotesList getNote() {
    final json = _sharedPreferences.getString(_keyNotess);

    return NotesList.fromJson(jsonDecode(json));
  }
}
