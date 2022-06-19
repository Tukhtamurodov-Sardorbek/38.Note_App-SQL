import 'package:flutter/cupertino.dart';
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
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => RotationTransition(
          turns: child.key == const ValueKey('icon5')
              ? Tween<double>(begin: 0.5, end: 1).animate(anim)
              : Tween<double>(begin: 1.5, end: 1).animate(anim),
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: provider.currentIndex2 == 0
            ? const Image(
                key: ValueKey('icon5'),
                image: AssetImage('assets/icons/grid_view.png'),
                height: 29,
                width: 29,
              )
            : const Image(
                key: ValueKey('icon6'),
                image: AssetImage('assets/icons/list_view.png'),
                height: 30,
                width: 30,
              ),
      ),
      onPressed: () {
        provider.updateLayout();

        provider.currentIndex2 = provider.currentIndex2 == 0 ? 1 : 0;
      }
    );
    }
    /* IconButton(
      splashRadius: 1,
      icon: AnimatedIcon(
        icon: AnimatedIcons.list_view,
        progress: provider.animationController,
        color: const Color(0xff00c6ff),
        size: 27,
      ),
      onPressed: () => provider.handleOnPressed(),
    );*/
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return IconButton(
      splashRadius: 1,
      icon: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage('assets/icons/trash.png'),
              height: 28,
              width: 30,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 15,
              width: 15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.systemRed,
              ),
              child: Text(
                provider.notesToBeDeleted.length > 10 ? '9+' : provider.notesToBeDeleted.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),
              ),
            ),
          )
        ],
      ),
      onPressed: () async {
        if (provider.isLoading) return;
        await SQLDatabase.instance.deleteAll(provider.notesToBeDeleted);
        provider.clear();
        provider.refreshNotes();
      },
    );
  }
}
