import 'package:flutter/material.dart';
import 'package:note_app_sql_database/models/note.dart';
import 'package:note_app_sql_database/services/sql_database.dart';
import 'package:note_app_sql_database/widgets/form_widget.dart';

class AddEditPage extends StatefulWidget {
  final Note? note;
  const AddEditPage({Key? key, this.note}) : super(key: key);
  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  Future<void> createOrUpdate() async{
    final isValid = _formKey.currentState!.validate();

    if(isValid){
      final isUpdating = widget.note != null;

      if(isUpdating){
        await updateNote();
      }else{
        await addNote();
      }

      Navigator.pop(context);
    }
  }

  Future updateNote() async{
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );
    await SQLDatabase.instance.update(note);
  }

  Future addNote() async{
    final note = Note(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );
    await SQLDatabase.instance.create(note);
  }

  @override
  void initState() {
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: FormWidget(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        onChangedImportant: (isImportant) =>
            setState(() => this.isImportant = isImportant),
        onChangedNumber: (number) => setState(() => this.number = number),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: createOrUpdate,
        child: Text('Save'),
      ),
    );
  }
}
