import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app_sql_database/pages/detail/view.dart';
import 'package:note_app_sql_database/pages/home/provider.dart';
import 'package:provider/provider.dart';

class BuildNote extends StatelessWidget {
  final int index;
  const BuildNote({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final note = provider.notes[index];
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DetailPage(id: note.id!)),
        );
        provider.refreshNotes();
      },
      onLongPress: () {
        provider.isSelected(note);
        if (note.isSelected) {
          provider.addElement(note.id!);
        } else {
          provider.removeElement(note.id!);
        }
        debugPrint(provider.notesToBeDeleted.toString());
      },
      onLongPressCancel: () {
        provider.notes.map((note) {
          provider.isNotSelected(note);
        });
        provider.clear();
      },
      child: Container(
        constraints: BoxConstraints(minHeight: provider.minHeight(index)),
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              note.isSelected
                  ? provider.gradients.keys
                      .toList()[index % provider.gradients.keys.toList().length]
                      .withOpacity(0.2)
                  : provider.gradients.keys.toList()[
                      index % provider.gradients.keys.toList().length],
              note.isSelected
                  ? provider.gradients.values
                      .toList()[
                          index % provider.gradients.values.toList().length]
                      .withOpacity(0.2)
                  : provider.gradients.values.toList()[
                      index % provider.gradients.values.toList().length],
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    provider.time(note),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ),
                Icon(
                  CupertinoIcons.exclamationmark_octagon_fill,
                  color: note.isImportant
                      ? CupertinoColors.systemRed
                      : CupertinoColors.systemGreen,
                  size: 28,
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              note.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                note.description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: provider.layoutChanged ? 5 : 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
