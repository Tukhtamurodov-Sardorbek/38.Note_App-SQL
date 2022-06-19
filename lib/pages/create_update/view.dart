import 'package:flutter/material.dart';
import 'package:note_app_sql_database/models/note.dart';
import 'package:note_app_sql_database/pages/create_update/utils/app_bar_actions.dart';
import 'package:note_app_sql_database/pages/create_update/utils/form_widget.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class CreateUpdatePage extends StatefulWidget {
  final Note? note;
  const CreateUpdatePage({Key? key, required this.note}) : super(key: key);

  @override
  State<CreateUpdatePage> createState() => _CreateUpdatePageState();
}

class _CreateUpdatePageState extends State<CreateUpdatePage> {
  final provider = CreateUpdateProvider();

  @override
  void initState() {
    // context.read<CreateUpdateProvider>().onInit(widget.note);
    provider.onInit(widget.note);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider, // (BuildContext context) => CreateUpdateProvider(),
      builder: (context, child) {
        final provider = context.watch<CreateUpdateProvider>();
        return Scaffold(
          appBar: AppBar(
            actions: [BuildButton(note: widget.note)],
          ),
          body: Form(
            key: provider.key,
            child: FormWidget(
              isImportant: provider.isImportant,
              title: provider.title,
              description: provider.description,
              onChangedImportant: (isImportant) => provider.isImportant = isImportant,
              onChangedTitle: (title) => provider.title = title,
              onChangedDescription: (description) => provider.description = description,
            ),
          ),
        );
      },
    );
  }
}
