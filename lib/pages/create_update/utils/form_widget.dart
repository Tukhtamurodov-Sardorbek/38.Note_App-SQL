import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final bool? isImportant;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const FormWidget({
    Key? key,
    this.isImportant = false,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Importance level',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: isImportant == null
                      ? Colors.white
                      : isImportant!
                          ? CupertinoColors.systemRed
                          : CupertinoColors.systemGreen,
                ),
              ),
              const Spacer(),
              GestureDetector(
                child: Icon(
                  CupertinoIcons.exclamationmark_octagon_fill,
                  color: isImportant == null || isImportant == true
                      ? Colors.green.shade700
                      : CupertinoColors.systemGreen,
                  size: 29,
                ),
                onTap: () {
                  onChangedImportant(false);
                },
              ),
              const SizedBox(width: 10),
              GestureDetector(
                child: Icon(
                  CupertinoIcons.exclamationmark_octagon_fill,
                  color: isImportant == null || isImportant == false
                      ? Colors.red.shade700
                      : CupertinoColors.systemRed,
                  size: 29,
                ),
                onTap: () {
                  onChangedImportant(true);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          buildTitle(),
          const Divider(color: Color(0xff5952cc), thickness: 2),
          const SizedBox(height: 8),
          buildDescription(),
          const Divider(color: Color(0xff5952cc), thickness: 2),
        ],
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: null,
        initialValue: description,
        style: const TextStyle(color: Colors.white70, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );
}