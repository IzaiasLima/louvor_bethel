import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: circleAvatar('', 20), // userAvatar(model, 20),
        )
      ],
      titleSpacing: 0.0,
      title: Text(Constants.title),
    );
  }
}
