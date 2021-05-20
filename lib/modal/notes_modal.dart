class NotesList {
  String note;

  NotesList({this.note});

  NotesList.fromMap(Map map) : this.note = map['title'];

  Map toMap() {
    return {
      'title': this.note,
    };
  }
}
