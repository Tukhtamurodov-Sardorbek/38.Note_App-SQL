import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app_sql_database/pages/create_update/view.dart';
import 'package:note_app_sql_database/pages/home/utils/app_bar_actions.dart';
import 'package:note_app_sql_database/pages/home/utils/app_bar_leading.dart';
import 'package:note_app_sql_database/pages/home/utils/build_notes.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final provider = HomeProvider();

  @override
  void initState() {
    provider.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    // Provider.of<HomeProvider>(context, listen: false).refreshNotes();
    provider.refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    // context.read<HomeProvider>().refreshNotes();
    // Provider.of<HomeProvider>(context, listen: false).closeDatabase();
    provider.closeDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      builder: (context, child) {
        final provider = context.watch<HomeProvider>();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Notes',
              style: TextStyle(fontSize: 24),
            ),
            leadingWidth: 110,
            leading: const AppBarLeading(),
            actions: [
              provider.notesToBeDeleted.isNotEmpty
                  ? const DeleteButton()
                  : const SizedBox(),
              const ListGridViewButton(),
            ],
          ),
          body: Center(
            child: provider.isLoading
                ? const CircularProgressIndicator()
                : provider.notes.isEmpty
                    ? Lottie.asset(
                        'assets/lottie/no-data.json',
                        height: 230,
                      )
                    : const BuildNotes(),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff00ddff),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff00c6ff), Color(0xff0072ff)],
                ),
              ),
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateUpdatePage(note: null),
                ),
              );
              provider.refreshNotes();
            },
          ),
        );
      },
    );
  }
}
