import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app_sql_database/pages/home/provider.dart';
import 'package:note_app_sql_database/pages/home/utils/build_note.dart';
import 'package:provider/provider.dart';

class BuildNotes extends StatelessWidget {
  const BuildNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return provider.layoutChanged
        ? ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            itemCount: provider.notes.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (BuildContext context, int index) {
              return BuildNote(index: index);
            },
          )
        : MasonryGridView.count(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            itemCount: provider.notes.length,
            crossAxisCount: 2,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            itemBuilder: (BuildContext context, int index) {
              return BuildNote(index: index);
            },
          );
  }
}
