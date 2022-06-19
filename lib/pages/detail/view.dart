import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app_sql_database/pages/create_update/view.dart';
import 'package:note_app_sql_database/services/sql_database.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final provider = DetailProvider();

  @override
  void initState() {
    // context.watch<DetailProvider>().id = widget.id;
    // context.read<DetailProvider>().refreshNote();
    provider.id = widget.id;
    provider.refreshNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider, // (BuildContext context) => DetailProvider(),
      builder: (context, child) {
        final provider = context.watch<DetailProvider>();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:  Text(
              DateFormat.yMMMd().add_jms().format(provider.note.createdTime).substring(0, 20),
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white38
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    if (provider.isLoading) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateUpdatePage(note: provider.note),
                      ),
                    );
                    provider.refreshNote();
                  },
                  icon: const Icon(Icons.edit_outlined)),
              IconButton(
                onPressed: () async {
                  if (provider.isLoading) return;
                  await SQLDatabase.instance.delete(widget.id);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: CupertinoColors.systemRed,
                ),
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(12),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          provider.note.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      provider.note.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
