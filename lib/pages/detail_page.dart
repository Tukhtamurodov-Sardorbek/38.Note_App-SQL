import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app_sql_database/models/note.dart';
import 'package:note_app_sql_database/pages/add_edit_page.dart';
import 'package:note_app_sql_database/services/sql_database.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Note note;
  bool isLoading = false;

  Future refreshNote() async {
    setState(() => isLoading = true);
    note = await SQLDatabase.instance.read(widget.id);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            note.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            DateFormat.yMMMd().format(note.createdTime),
            style: const TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 8.0),
          Text(
            note.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          )
        ],
      )
    );
  }

  Widget editButton(){
    return IconButton(
        onPressed: ()async{
          if(isLoading) return;

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditPage(note: note))
          );
          refreshNote();
        },
        icon: const Icon(Icons.edit_outlined)
    );
  }

  Widget deleteButton(){
    return IconButton(
        onPressed: ()async{
          if(isLoading) return;
          await SQLDatabase.instance.delete(widget.id);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete, color: CupertinoColors.systemRed)
    );
  }
}
