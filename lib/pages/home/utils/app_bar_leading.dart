import 'package:flutter/material.dart';
import 'package:note_app_sql_database/pages/home/provider.dart';
import 'package:provider/provider.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Row(
      children: [
        IconButton(
          splashRadius: 1,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: child.key == const ValueKey('icon1')
                  ? Tween<double>(begin: 0.5, end: 1).animate(anim)
                  : Tween<double>(begin: 1.5, end: 1).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: provider.currentIndex == 0
                ? const Image(
                    key: ValueKey('icon2'),
                    image: AssetImage('assets/icons/time.png'),
                    height: 34,
                    width: 34,
                  )
                : const Image(
                    key: ValueKey('icon1'),
                    image: AssetImage('assets/icons/importance.png'),
                    height: 32,
                    width: 32,
                  ),
          ),
          onPressed: () {
            provider.byTime();
            provider.refreshNotes();
            provider.currentIndex = provider.currentIndex == 0 ? 1 : 0;
          },
        ),
        IconButton(
          splashRadius: 1,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => RotationTransition(
              turns: child.key == const ValueKey('icon3')
                  ? Tween<double>(begin: 1.5, end: 1).animate(anim)
                  : Tween<double>(begin: 1.0, end: 1.25).animate(anim),
              child: ScaleTransition(scale: anim, child: child),
            ),
            child: provider.currentIndex1 == 0
                ? const Image(
                    key: ValueKey('icon3'),
                    image: AssetImage('assets/icons/ascending_descending.png'),
                    height: 25,
                    width: 25,
                  )
                : const Image(
                    key: ValueKey('icon4'),
                    image: AssetImage('assets/icons/ascending_descending.png'),
                    height: 25,
                    width: 25,
                  ),
          ),
          onPressed: () {
            provider.isAscendingOrder();
            provider.refreshNotes();
            provider.currentIndex1 = provider.currentIndex1 == 0 ? 1 : 0;
          },
        ),
      ],
    );
  }
}
