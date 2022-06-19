import 'package:flutter/material.dart';
import 'package:note_app_sql_database/pages/home/provider.dart';
import 'package:note_app_sql_database/services/sql_database.dart';
import 'package:provider/provider.dart';

class ListGridViewButton extends StatelessWidget {
  const ListGridViewButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return IconButton(
      splashRadius: 1,
      icon: AnimatedIcon(
        icon: AnimatedIcons.list_view,
        progress: provider.animationController,
        color: const Color(0xff00c6ff),
        size: 27,
      ),
      onPressed: () => provider.handleOnPressed(),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return IconButton(
      splashRadius: 1,
      icon: const Icon(Icons.delete),
      onPressed: () async {
        if (provider.isLoading) return;
        await SQLDatabase.instance.deleteAll(provider.notesToBeDeleted);
        provider.clear();
        provider.refreshNotes();
      },
    );
  }
}
