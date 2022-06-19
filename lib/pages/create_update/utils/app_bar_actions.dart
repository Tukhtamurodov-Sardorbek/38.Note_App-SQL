import 'package:flutter/material.dart';
import 'package:note_app_sql_database/models/note.dart';
import 'package:note_app_sql_database/pages/create_update/provider.dart';
import 'package:provider/provider.dart';

class BuildButton extends StatelessWidget {
  final Note? note;
  const BuildButton({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateUpdateProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary:
              provider.isFormValid() ? const Color(0xff5952cc) : Colors.white54,
        ),
        onPressed: () async {
          provider.isImportant = provider.isImportant ?? false;
          await provider.createOrUpdate(note, context);
        },
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
