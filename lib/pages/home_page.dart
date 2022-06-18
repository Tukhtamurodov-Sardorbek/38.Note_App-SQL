import 'package:flutter/material.dart';
import 'package:note_app_sql_database/models/note.dart';
import 'package:note_app_sql_database/pages/add_edit_page.dart';
import 'package:note_app_sql_database/pages/detail_page.dart';
import 'package:note_app_sql_database/services/sql_database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app_sql_database/widgets/card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Note> notes;
  bool isLoading = false;

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await SQLDatabase.instance.readAll();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    SQLDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text('Empty')
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditPage()));
          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotes() {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(8.0),
      itemCount: notes.length,
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (BuildContext context, int index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(id: note.id!)));
            refreshNotes();
          },
          child: NoteWidget(note: note, index: index),
        );
      },
    );
  }
}
