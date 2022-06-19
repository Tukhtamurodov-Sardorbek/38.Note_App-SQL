// * In order to store note => create a table
const String tableNotes = 'notes';

// * Column names
class NoteFields {
  // * By default in SQL Database we always have an underscore before id
  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';

  // * All Column names list
  static final List<String> values = [
    id,
    isImportant,
    title,
    description,
    time,
  ];
}

class Note {
  final int? id;
  final bool isImportant;
  final String title;
  final String description;
  final DateTime createdTime;
  bool isSelected;

  Note({
    this.id,
    required this.isImportant,
    required this.title,
    required this.description,
    required this.createdTime,
    this.isSelected = false,
  });

  Note copy({
    int? id,
    bool? isImportant,
    String? title,
    String? description,
    DateTime? createdTime,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      createdTime: createdTime ?? this.createdTime,
      isImportant: isImportant ?? this.isImportant,
      description: description ?? this.description,
    );
  }

  // * SQL database can't understand bool & DateTime types =>
  //   So, we need to convert them into int & String accordingly
  Map<String, Object?> toJson() {
    return {
      NoteFields.id: id,
      NoteFields.isImportant: isImportant ? 1 : 0,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.time: createdTime.toIso8601String(),
    };
  }

  static Note fromJson(Map<String, Object?> json){
    return Note(
      id: json[NoteFields.id] as int?,
      isImportant: json[NoteFields.isImportant] == 1,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      createdTime: DateTime.parse(json[NoteFields.time] as String),
    );
  }
}
