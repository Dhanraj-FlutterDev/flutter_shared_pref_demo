class NotesList {
  final String notes;

  NotesList({this.notes});

  factory NotesList.fromJson(Map<String, dynamic> parsedJson) {
    return new NotesList(
      notes: parsedJson['notes'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "notes": this.notes,
    };
  }
}
