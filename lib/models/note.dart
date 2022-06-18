// * In order to store note => create a table
const String tableNotes = 'notes';

// * Column names
class NoteFields {
  // * By default in SQL Database we always have an underscore before id
  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      createdTime: createdTime ?? this.createdTime,
      isImportant: isImportant ?? this.isImportant,
      number: number ?? this.number,
      description: description ?? this.description,
    );
  }

  // * SQL database can't understand bool & DateTime types =>
  //   So, we need to convert them into int & String accordingly
  Map<String, Object?> toJson() {
    return {
      NoteFields.id: id,
      NoteFields.isImportant: isImportant ? 1 : 0,
      NoteFields.number: number,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.time: createdTime.toIso8601String(),
    };
  }
}
